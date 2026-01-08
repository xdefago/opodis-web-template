#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'yaml'
require 'date'
require 'set'

ROOT = File.expand_path('..', __dir__)
PROGRAM_YML = File.join(ROOT, 'docs', '_data', 'program.yml')
OUTPUT_JSON = File.join(ROOT, 'docs', '_data', 'outline_grid.json')

ALLOWED_TYPES = %w[registration break session keynote opening closing business plenary].freeze

RED = "\033[31m"
YELLOW = "\033[33m"
RESET = "\033[0m"

class OutlineError < StandardError
  attr_reader :day_label, :day_date, :item_index, :item, :code, :details

  def initialize(message, code:, day_label:, day_date:, item_index:, item:, details: nil)
    super(message)
    @code = code
    @day_label = day_label
    @day_date = day_date
    @item_index = item_index
    @item = item
    @details = details
  end
end

def fatal_error!(code:, message:, day:, idx:, item:, details: nil)
  raise OutlineError.new(
    message,
    code: code,
    day_label: day['label'],
    day_date: day['date'],
    item_index: idx,
    item: item,
    details: details
  )
end

def warn!(msg)
  $stderr.puts "#{YELLOW}WARNING: #{msg}#{RESET}"
end

def parse_minutes(label)
  parts = label.to_s.split(':')
  raise "Invalid time format: #{label.inspect}" unless parts.size == 2
  h = Integer(parts[0], 10, exception: false)
  m = Integer(parts[1], 10, exception: false)
  raise "Invalid time numbers: #{label.inspect}" if h.nil? || m.nil?
  h * 60 + m
end

def parse_time_field(value)
  return [nil, nil] if value.nil?

  if value.is_a?(String) && value.include?('-')
    start_str, end_str = value.split('-', 2).map(&:strip)
    start_min = parse_minutes(start_str)
    end_min = parse_minutes(end_str)
    [start_min, end_min]
  else
    [parse_minutes(value), nil]
  end
end

def fmt_minutes(total)
  hours = total / 60
  mins = total % 60
  format('%d:%02d', hours, mins)
end

def include_outline_item?(item)
  type = item['type']
  return true if ALLOWED_TYPES.include?(type)

  false
end

def normalize_day(day, paper_duration, keynote_duration, labels_map)
  items = day.fetch('items', [])
  prev_end = nil
  norm = []

  items.each_with_index do |item, idx|
    type = item['type'] || fatal_error!(
      code: 'missing-type',
      message: 'missing type for outline item',
      day: day,
      idx: idx,
      item: item
    )
    include_item = include_outline_item?(item)

    time_field = item['time']
    start_min, explicit_end = parse_time_field(time_field)

    if include_item
      start_min ||= prev_end
      fatal_error!(
        code: 'missing-start',
        message: 'missing start time for outline item',
        day: day,
        idx: idx,
        item: item,
        details: 'Provide a time (HH:MM or HH:MM-HH:MM) or ensure the previous item has an end time to inherit from.'
      ) if start_min.nil?
    else
      start_min ||= prev_end
      prev_end = start_min if start_min
      next
    end

    next_item = items[idx + 1]
    next_start = nil
    if next_item && next_item['time']
      ns, = parse_time_field(next_item['time'])
      next_start = ns
    end

    duration_raw = item['duration']
    duration_min = duration_raw.nil? ? nil : duration_raw.to_i
    computed = nil
    computed_kind = nil

    if type == 'session'
      papers = item['papers'] || []
      computed = papers.size * paper_duration
      computed_kind = :papers
    elsif type == 'keynote'
      computed = keynote_duration
      computed_kind = :keynote
    end

    end_min = nil
    # Priority: explicit range > explicit duration > computed > next start
    if explicit_end
      end_min = explicit_end
      if duration_min && start_min + duration_min != end_min
        warn!("start+duration != explicit end at #{day['label'] || day['date']} item #{idx}")
      end
    elsif duration_min
      end_min = start_min + duration_min
    elsif computed
      end_min = start_min + computed
    elsif next_start
      end_min = next_start
    else
      fatal_error!(
        code: 'end-time',
        message: 'cannot infer end time for outline item',
        day: day,
        idx: idx,
        item: item,
        details: 'Specify duration, add papers, or set a start time for the next item.'
      )
    end

    if explicit_end && end_min < start_min
      fatal_error!(
        code: 'negative-duration',
        message: 'end time is before start time',
        day: day,
        idx: idx,
        item: item,
        details: "Start #{fmt_minutes(start_min)}, end #{fmt_minutes(end_min)}"
      )
    end

    # Consistency checks
    if duration_min && computed && computed_kind == :papers
      expected_comp = start_min + computed
      warn!("start+duration != papers*paper_duration at #{day['label'] || day['date']} item #{idx}") if end_min != expected_comp
    end

    if next_start
      if end_min > next_start
        fatal_error!(
          code: 'duration-overlap',
          message: 'duration exceeds start of next item',
          day: day,
          idx: idx,
          item: item,
          details: "Ends at #{fmt_minutes(end_min)} but next item starts at #{fmt_minutes(next_start)}."
        )
      elsif end_min < next_start
        warn!("gap detected: #{day['label'] || day['date']} item #{idx} ends before next start")
      end
    end

    resolved_label = item['label'] || labels_map[type]

    norm << item.merge(
      'start_min' => start_min,
      'end_min' => end_min,
      'include' => include_item,
      'label' => resolved_label
    )

    prev_end = end_min
  end

  norm
end

def build_boundaries(days)
  bounds = []
  days.each do |items|
    items.each do |item|
      next unless item['include']

      bounds << item['start_min']
      bounds << item['end_min']
    end
  end
  bounds.uniq.sort
end

def active_item(items, minute)
  items.find { |it| it['include'] && it['start_min'] <= minute && minute < it['end_min'] }
end

def build_rows(boundaries, days_items)
  index_for = boundaries.each_with_index.to_h
  skip_until = Array.new(days_items.size, 0)
  rows = []

  (0...(boundaries.size - 1)).each do |bi|
    start_min = boundaries[bi]

    row_cells = []
    row_break = true
    break_labels = []

    days_items.each_with_index do |items, di|
      if skip_until[di] > bi
        row_cells << { 'kind' => 'skip' }
        next
      end

      active = active_item(items, start_min)
      if active
        if active['type'] != 'break'
          row_break = false
        else
          break_labels << active['label'] if active['label']
        end

        if active['start_min'] == start_min
          span = index_for.fetch(active['end_min']) - bi
          row_cells << {
            'kind' => 'cell',
            'type' => active['type'],
            'label' => active['label'],
            'title' => active['title'],
            'number' => active['number'],
            'rowspan' => span,
            'talk_count' => (active['papers'] || []).size,
            'papers' => active['papers'],
            'chair' => active['chair']
          }
          skip_until[di] = bi + span
        else
          row_cells << { 'kind' => 'skip' }
        end
      else
        row_cells << nil
      end
    end

    next if row_cells.all?(&:nil?)

    if row_break && !break_labels.empty?
      rows << {
        'time' => start_min,
        'time_label' => fmt_minutes(start_min),
        'break' => true,
        'label' => break_labels.uniq.join(' / ')
      }
    else
      rows << {
        'time' => start_min,
        'time_label' => fmt_minutes(start_min),
        'break' => false,
        'cells' => row_cells
      }
    end
  end

  rows
end

# Configuration Validation Functions

def load_papers_yml
  papers_file = File.join(ROOT, 'docs', '_data', 'papers.yml')
  return {} unless File.exist?(papers_file)
  raw = YAML.safe_load(File.read(papers_file), permitted_classes: [Date], aliases: true)
  raw || {}
end

def load_committees_yml
  committees_file = File.join(ROOT, 'docs', '_data', 'committees.yml')
  return {} unless File.exist?(committees_file)
  raw = YAML.safe_load(File.read(committees_file), permitted_classes: [Date], aliases: true)
  raw || {}
end

def load_keynotes_yml
  keynotes_file = File.join(ROOT, 'docs', '_data', 'keynotes.yml')
  return {} unless File.exist?(keynotes_file)
  raw = YAML.safe_load(File.read(keynotes_file), permitted_classes: [Date], aliases: true)
  raw || {}
end

def validate_papers(days_data, papers_data)
  return if papers_data.empty?

  items = papers_data.fetch('items', [])
  available_papers = items.map { |p| p['number'] }.compact.to_set

  seen_papers = Set.new
  errors = []

  days_data.each_with_index do |day, day_idx|
    day_label = day['label'] || day['date']
    items_list = day.fetch('items', [])

    items_list.each_with_index do |item, item_idx|
      next unless item['type'] == 'session'
      
      papers = item.fetch('papers', [])
      papers.each do |paper|
        paper_num = paper.is_a?(Hash) ? paper['number'] : paper
        
        unless available_papers.include?(paper_num)
          errors << "#{YELLOW}warning[paper-404]: Paper ##{paper_num} referenced in program but not in papers.yml#{RESET}\n" \
                    "   --> program.yml:#{day_label}, session #{item['number']}\n" \
                    "    | papers: #{papers.map { |p| p.is_a?(Hash) ? p['number'] : p }.inspect}\n" \
                    "    | note: Add paper ##{paper_num} to papers.yml or remove from session."
        end

        if seen_papers.include?(paper_num)
          errors << "#{YELLOW}warning[paper-duplicate]: Paper ##{paper_num} appears in multiple sessions#{RESET}\n" \
                    "   --> program.yml:#{day_label}, session #{item['number']}\n" \
                    "    | papers: #{papers.map { |p| p.is_a?(Hash) ? p['number'] : p }.inspect}\n" \
                    "    | note: Each paper should appear in exactly one session."
        end
        
        seen_papers.add(paper_num)
      end
    end
  end

  errors.each { |err| $stderr.puts err }
end

def validate_chairs(days_data, committees_data, keynotes_data)
  # Build list of known people
  known_people = Set.new
  
  # Add keynote speakers
  keynotes_items = keynotes_data.fetch('items', [])
  keynotes_items.each do |kn|
    speaker = kn.fetch('speaker', {})
    known_people.add(speaker['name']) if speaker['name']
  end
  
  # Add committee members
  committees = committees_data.fetch('organizing', {})
  %w[general_chairs publication_chair organizing_team].each do |role|
    role_data = committees.fetch(role, {})
    items = role_data.is_a?(Hash) ? role_data.fetch('items', []) : role_data
    items.each { |p| known_people.add(p['name']) if p['name'] }
  end

  steering = committees_data.fetch('steering', {})
  items = steering.is_a?(Hash) ? steering.fetch('items', []) : steering
  items.each { |p| known_people.add(p['name']) if p['name'] }

  program_chairs = committees_data.fetch('program_chairs', {})
  items = program_chairs.is_a?(Hash) ? program_chairs.fetch('items', []) : program_chairs
  items.each { |p| known_people.add(p['name']) if p['name'] }

  program_committee = committees_data.fetch('program_committee', {})
  items = program_committee.is_a?(Hash) ? program_committee.fetch('items', []) : program_committee
  items.each { |p| known_people.add(p['name']) if p['name'] }

  errors = []

  days_data.each_with_index do |day, day_idx|
    day_label = day['label'] || day['date']
    items_list = day.fetch('items', [])

    items_list.each_with_index do |item, item_idx|
      chair = item['chair']
      next unless chair && chair != 'TBA' && chair != 'TBD' && !chair.empty?
      
      unless known_people.include?(chair)
        errors << "#{YELLOW}warning[chair-unknown]: Session chair not found#{RESET}\n" \
                  "   --> program.yml:#{day_label}, #{item['type']} #{item['number']}\n" \
                  "    | chair: \"#{chair}\"\n" \
                  "    | note: Add \"#{chair}\" to committees.yml or update name."
      end
    end
  end

  errors.each { |err| $stderr.puts err }
end

def validate_time_format(days_data)
  errors = []

  days_data.each_with_index do |day, day_idx|
    day_label = day['label'] || day['date']
    items_list = day.fetch('items', [])

    items_list.each_with_index do |item, item_idx|
      time = item['time']
      next unless time

      unless /^\d{1,2}:\d{2}$/.match?(time.to_s)
        errors << "#{YELLOW}warning[time-format]: Invalid time format#{RESET}\n" \
                  "   --> program.yml:#{day_label}, #{item['type']} #{item['number']}\n" \
                  "    | time: \"#{time}\"\n" \
                  "    | note: Use HH:MM format (e.g., '09:00' or '9:00')."
      end
    end
  end

  errors.each { |err| $stderr.puts err }
end


begin
  raw = YAML.safe_load(File.read(PROGRAM_YML), permitted_classes: [Date], aliases: true)
  schedule = raw.fetch('schedule')
  durations = schedule['durations'] || {}
  paper_duration = durations['paper'] || 20
  keynote_duration = durations['keynote'] || 60
  labels_map = schedule['labels'] || {}

  days = schedule.fetch('days', [])
  
  # Run validations
  papers_data = load_papers_yml
  committees_data = load_committees_yml
  keynotes_data = load_keynotes_yml
  
  validate_time_format(days)
  validate_papers(days, papers_data)
  validate_chairs(days, committees_data, keynotes_data)
  
  normalized_days = days.map { |day| normalize_day(day, paper_duration, keynote_duration, labels_map) }

  boundaries = build_boundaries(normalized_days)
  if boundaries.empty?
    warn!('No outline items found; not writing outline_grid.json')
    exit 0
  end

  rows = build_rows(boundaries, normalized_days)

  day_labels = days.map do |day|
    day['label'] || Date.parse(day['date'].to_s).strftime('%a %b %-d')
  end

  payload = {
    'days' => day_labels,
    'rows' => rows
  }

  File.write(OUTPUT_JSON, JSON.pretty_generate(payload))
  puts "Wrote outline grid to #{OUTPUT_JSON}"
rescue RuntimeError => e
  abort e.message
rescue OutlineError => e
  header = "#{RED}error[#{e.code}]: #{e.message}#{RESET}"
  location = [e.day_label || e.day_date, "item #{e.item_index}", e.item && e.item['type']].compact.join(' • ')
  $stderr.puts header
  $stderr.puts "   --> #{location}"
  if e.item && e.item['time']
    $stderr.puts "    | start: #{e.item['time']}"
  end
  if e.details
    $stderr.puts "    | note: #{e.details}"
  end
  abort "error[#{e.code}]"
rescue StandardError => e
  raise
end
