# OPODIS Website: Quick Start Guide

This guide gets you running a new OPODIS instance website in **under 15 minutes**.

## Prerequisites

- Ruby 3.0+ with bundler
- Previous year's configuration as reference (optional)
- Basic understanding of YAML

## Quick Start (5 minutes)

### 1. **Update Core Information**

Edit `docs/_data/conference.yml` (use `general` for series-level defaults, `year` for annual overrides):

```yaml
general:
  acronym: "OPODIS"
  fullname: "International Conference on Principles of Distributed Systems"
  date_format: "%A, %B %-d, %Y"

year:
  year: 2024
  edition: 28
  city: "Tokyo"
  country: "Japan"
  dates:
    start: 2024-12-04
    end: 2024-12-06
```

Edit `docs/_data/dates.yml` (nested structure with flexible date updates):

```yaml
show_on_site: true
timezone_label: "Anywhere on Earth (AoE)"
timezone: "Etc/GMT+12"

cfp:
  submission_deadline:
    date: ["2024-03-31", "2024-04-07"]  # Show original + extended
    label: "Submission deadline"
    status: "auto"
  notification_deadline:
    date: "2024-05-30"
    label: "Notification"
  camera_ready_deadline:
    date: "2024-06-15"

registration:
  early_bird_deadline:
    date: "2024-10-31"
  standard_deadline:
    date: "2024-11-30"
```

**Note:** Conference start/end dates are in `conference.yml` under `year.dates`

Edit `docs/_data/venue.yml`:

```yaml
show_on_site: true

venue:
  name: "Tokyo Institute of Technology"
  building: "West Building 9"
  address: "2-12-1-W9-10, O-okayama, Meguro-ku, Tokyo"
  map_url: "https://maps.app.goo.gl/..."
```

### 2. **Initialize Program Schedule**

Edit `docs/_data/program.yml`:

```yaml
schedule:
  date: 2024-12-04              # Base date
  durations:
    paper: 20                    # Minutes per paper
    keynote: 60                  # Minutes per keynote
  
  days:
    - date: 2024-12-04
      label: "Wed Dec 4"
      items:
        - time: "08:30-09:00"    # Explicit range (preferred if known)
          type: "registration"
        - time: "09:00"
          type: "opening"
          duration: 15           # Explicit duration (HH:MM inferred from start + 15)
        - time: "09:15"
          type: "keynote"
          number: 1
          chair: "Chair Name"
          # Duration will fall back to keynote default if not provided
        # Continue with sessions, breaks, etc.
```

### 3. **Add Keynote Speakers**

Edit `docs/_data/keynotes.yml`:

```yaml
items:
  - number: 1
    speaker:
      name: "Speaker Name"
      affiliation: "University/Company"
    title: "Talk Title"
    # Add photo and abstract when available
```

  Placeholders: set `speaker.name` to `"TBA"`/`"TBD"` while finalizing; the site will render a "To Be Announced" badge so draft content is visually distinct.

### 4. **Build and Test**

```bash
# Install dependencies
bundle install

# Generate outline grid (converts program.yml to JSON)
bundle exec ruby scripts/validate_and_generate.rb

# Build the site
bundle exec jekyll build --source docs --destination docs/_site

# Serve locally
bundle exec jekyll serve --source docs --destination docs/_site --livereload
```

Visit `http://localhost:4000` to preview.

---

## Full Configuration Workflow

For a complete setup, follow the **stages** outlined in [CONFIG.md](config/CONFIG.md).

## Common Tasks

### Update Schedule After Changes

```bash
bundle exec ruby scripts/validate_and_generate.rb
```

The generator:
- Reads `docs/_data/program.yml`
- Resolves end times using this priority: time range → explicit `duration` → computed (papers/keynotes) → next item's start
- Validates consistency (no overlaps; warns on gaps)
- Emits helpful diagnostics: missing papers, duplicate paper assignments, keynote/speaker placeholders, and invalid time formats (session chairs are free-form; no cross-checks)
- Generates `docs/_data/outline_grid.json`
- **Must be run after any program.yml change**

### Add Accepted Papers

Edit `docs/_data/papers.yml` (flexible author formats):

```yaml
enabled: true
show_on_site: true
show_affiliations_in_list: true
show_affiliations_in_schedule: false

items:
  # Simple string
  - number: 1
    title: "Paper Title"
    authors: "Author One, Author Two"
  
  # Array of strings
  - number: 2
    title: "Another Paper"
    authors:
      - "Author Three"
      - "Author Four"
  
  # Detailed with affiliations
  - number: 3
    title: "Third Paper"
    authors:
      - name: "Author Five"
        affiliation: "University A"
      - name: "Author Six"
        affiliation: "University B"
```

### Add Committee Members

Edit `docs/_data/committees.yml`:

```yaml
enabled: true
show_on_site: true

organizing:
  general_chairs:
    enabled: true
    items:
      - name: "Chair Name"
        affiliation: "University"

program_chairs:
  enabled: true
  items:
    - name: "PC Chair"
      affiliation: "University"

program_committee:
  enabled: true
  items:
    - name: "Member Name"
      affiliation: "University"
```

### Update CFP

Edit `docs/_data/cfp.yml`:

```yaml
show_on_site: true
title: "Call for Papers"
status: "open"

text: |
  # OPODIS 2024: Call for Papers
  
  All your CFP content here as markdown...
  
  ## Topics
  - Topic 1
  - Topic 2
  
  ## Submission Guidelines
  etc.

submission_link: "https://hotcrp.example.com"
```

### Update Travel Info

Edit `docs/_data/travel.yml`:

```yaml
show_on_site: true
title: "Travel Information"

airports:
  - code: "NRT"
    name: "Narita Airport"
    distance: "60 km from Tokyo"
    travel_time: "60-90 minutes"
    info: "Take N'EX train to Tokyo Station"

public_transport: |
  ## Getting Around
  Use Suica card...

to_venue: |
  ## To Tokyo Tech
  Take JR Line to O-okayama...

visa_info: |
  Check visa requirements...
```

### Update Registration

Edit `docs/_data/registration.yml`:

```yaml
enabled: true
show_on_site: true
status: "open"
registration_link: "https://reg.example.com"

pricing:
  early_bird:
    deadline: "2024-10-31"
    student: "100 EUR"
    regular: "300 EUR"
  standard:
    deadline: "2024-11-30"
    student: "150 EUR"
    regular: "400 EUR"
  on_site:
    student: "200 EUR"
    regular: "500 EUR"

what_is_included:
  - "Conference sessions"
  - "Proceedings"
  - "Coffee breaks"

terms: |
  ### Cancellation Policy
  etc.
```

---

## File Structure Reference

```
docs/_data/                    # Configuration files (YAML)
├── conference.yml            # Conference metadata
├── dates.yml                 # Important dates
├── venue.yml                 # Location information
├── keynotes.yml              # Keynote speakers
├── program.yml               # Schedule definition
├── papers.yml                # Accepted papers
├── committees.yml            # Organizational committees
├── cfp.yml                   # Call for papers
├── registration.yml          # Registration info
├── sponsors.yml              # Sponsor information
├── travel.yml                # Travel & accommodation
└── outline_grid.json         # Generated schedule (DO NOT EDIT)

docs/_includes/               # Template partials
docs/                         # Static pages and layouts
```

## Troubleshooting

### Generator Error: "Cannot infer end time"

**Cause:** Schedule item missing time information.

**Solution:** 
- Ensure each session has a `time` field or a following item with `time`
- Or add explicit `duration` field

```yaml
items:
  - time: "09:00"
    type: "opening"
    duration: 10              # Optional: explicitly set duration
```

### Schedule Not Updating

**Cause:** Forgot to regenerate outline grid.

**Solution:**
```bash
bundle exec ruby scripts/validate_and_generate.rb
bundle exec jekyll build --source docs --destination docs/_site
```

### Changes Not Showing on Live Site

**Cause:** Browser cache or rebuild incomplete.

**Solution:**
```bash
# Force rebuild
bundle exec jekyll build --source docs --destination docs/_site --force
# Hard refresh browser (Cmd+Shift+R on macOS)
```

---

## Next Steps

1. Read [CONFIG.md](config/CONFIG.md) for stage-by-stage guidance
2. Check [BUILD.md](config/BUILD.md) for building and deployment
3. Review [tmp/analysis/similarity.md](tmp/analysis/similarity.md) for design rationale

---

**Need Help?** Consult [CONFIG.md](config/CONFIG.md) for detailed workflow guidance.
