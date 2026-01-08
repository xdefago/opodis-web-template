# OPODIS Website: Configuration Guide

Complete guide to configuring the website for a new OPODIS instance, organized by **planning stage**.

## Table of Contents

1. [Stage 1: Initial Setup](#stage-1-initial-setup) (Months 9-8 before)
2. [Stage 2: Build-out](#stage-2-build-out) (Months 7-4 before)
3. [Stage 3: Maturation](#stage-3-maturation) (Months 3-1 before)
4. [Stage 4: Launch](#stage-4-launch) (Final weeks)
5. [Configuration Reference](#configuration-reference)

---

## Stage 1: Initial Setup
**Timeline:** 9–8 months before the conference

### Goals
- Announce conference dates and location
- Open call for papers
- Establish initial visual presence
- Set up organization structure

### Required Configuration

#### 1.1 Conference Metadata

**File:** `docs/_data/conference.yml`

```yaml
# Series-level defaults (override per year below)
#### 1.1 Conference Metadata (general vs. year)

**File:** `docs/_data/conference.yml`

- `general`: series-level defaults that persist across years (acronym, formats, fallback text)
- `year`: overrides for the current edition (city, dates, contacts); values here replace `general` when present

```yaml
show_on_site: true

general:
  acronym: "OPODIS"
  fullname: "International Conference on Principles of Distributed Systems"
  date_format: "%A, %B %-d, %Y"
  tbd: "TBD"

year:
  year: 2024
  edition: 28
  city: "Tokyo"
  country: "Japan"
  dates:
    start: 2024-12-04
    end: 2024-12-06
  locale:
    timezone: "Asia/Tokyo"

contacts:
  - label: "OPODIS 2024 Organizing Team"
    email: "opodis24@coord.example.org"
```

general_chairs:
  - name: "Chair One"
    affiliation: "University A"
  - name: "Chair Two"
    affiliation: "University B"

program_chairs:
  - name: "PC Chair One"
    affiliation: "University C"
  - name: "PC Chair Two"
    affiliation: "University D"
```

#### 1.2 Important Dates

**File:** `docs/_data/dates.yml`

Flexible date structure with support for deadline extensions.

```yaml
# Toggle visibility in navigation and sections
show_on_site: true

# Timezone label displayed to users
timezone_label: "Anywhere on Earth (AoE)"
timezone: "Etc/GMT+12"

# CFP-related deadlines
cfp:
  announcement:
    date: "2023-08-28"
    label: "CFP announcement"
  
  abstract_registration:
    date: "2023-08-29"
    label: "Abstract registration"
  
  # Show date updates with strikethrough on original
  submission_deadline:
    date: ["2023-09-01", "2023-09-08"]  # [original, updated]
    label: "Submission deadline"
    status: "auto"  # auto (computed from date), past, or upcoming
  
  notification_deadline:
    date: "2023-10-02"
    label: "Notification deadline"
  
  camera_ready_deadline:
    date: "2023-10-15"
    label: "Camera-ready deadline"

# Registration-related deadlines
registration:
  opens:
    date: "2023-09-01"
    label: "Registration opens"
  
  early_bird_deadline:
    date: "2024-10-31"
    label: "Early-bird deadline"
  
  standard_deadline:
    date: "2024-11-30"
    label: "Standard deadline"
  
  on_site:
    date: "2024-12-04"
    label: "On-site registration"
```

**Notes:**
- Conference start/end dates are in `conference.yml` under `year.dates`
- Each date can be a string or an array `[original, updated]` to show deadline extensions
- Status can be: `auto` (computed from current date), `past`, or `upcoming`
- Display controlled by `show_on_site: true`

#### 1.3 Venue Information

**File:** `docs/_data/venue.yml`

```yaml
# Toggle visibility
show_on_site: true

# Venue details
venue:
  name: "Tokyo Institute of Technology"
  building: "West Building 9"
  address: "2-12-1-W9-10, O-okayama, Meguro-ku"
  postal_code: "152-8552"
  phone: "TBD"
  
  # Website for more info
  url: "https://www.titech.ac.jp"
  
  # Map link (Google Maps preferred)
  map_url: "https://maps.app.goo.gl/..."
  
  # Transportation info (added in Stage 2)
  access: null  # Will add public transit directions

# Timezone (critical for schedule display)
timezone: "+09:00"  # Japan Standard Time
timezone_abbr: "JST"

# Conference center or main building (optional)
conference_room: "TBD"
```

**Critical Fields:**
- `city`, `country` – Required for SEO and clarity
- `venue.name` – Shows on venue section
- `timezone` – Used for schedule display calculations

#### 1.4 Initial Program Schedule

**File:** `docs/_data/program.yml`

```yaml
schedule:
  # Base date (if individual days don't specify date)
  date: 2024-12-04
  
  # Flip time: when auto-switching to next day in live view (HH:MM)
  flip_time: "22:00"
  
  # Default durations for papers and keynotes
  durations:
    paper: 20         # Minutes per paper presentation
    keynote: 60       # Minutes for keynote talks
  
  # Labels for common item types
  labels:
    break: "Coffee break"
    registration: "Registration"
    business: "Business meeting"
    opening: "Opening"
    closing: "Closing"
  
  days:
    - date: 2024-12-04
      label: "Wed Dec 4"  # Display label
      items:
        # First day skeleton - no papers yet
        - time: "08:30-09:00"  # Explicit range (preferred when known)
          type: "registration"
        
        - time: "09:00"
          type: "opening"
          duration: 15          # Explicit duration when only start time is known
        
        - time: "09:15"
          type: "keynote"
          number: 1
          chair: "TBD"
          # Falls back to default keynote duration if none provided
        
        - time: "10:15"
          type: "break"
        
        - time: "10:45"
          type: "session"
          number: 1
          title: "Session 1"
          chair: "TBD"
          papers: []  # Empty until papers assigned
        
        - time: "12:15"
          type: "break"
          label: "LUNCH"
        
        - time: "13:30"
          type: "session"
          number: 2
          title: "Session 2"
          chair: "TBD"
          papers: []
        
        - time: "15:00"
          type: "break"
        
        - time: "15:30"
          type: "session"
          number: 3
          title: "Session 3"
          chair: "TBD"
          papers: []
        
        - time: "17:30"
          type: "closing"
    
    # Day 2 and 3 similar structure...
```

**Important Notes:**
- Skeleton schedule can have empty `papers: []` – papers added in Stage 3
- `chair: "TBD"` is acceptable – will be filled in Stage 2
- Times accept `HH:MM` or `HH:MM-HH:MM` plus optional `duration:` (minutes)
- End times resolve in order: explicit time range → explicit `duration` → computed (papers/keynotes) → next item's start; generator warns on gaps or overlaps
- Times are crucial – outline grid generation depends on them
- Session titles can be generic initially

#### 1.5 Call for Papers

**File:** `docs/_data/cfp.yml`

Single markdown text block for maximum flexibility. All CFP content in one place.

```yaml
# Toggle visibility
show_on_site: true

title: "Call for Papers"

# Status: "open", "closed", "announcement"
status: "open"

# All CFP content as markdown
text: |
  # OPODIS 2024: Call for Papers
  
  The 28th International Conference on Principles of Distributed Systems (OPODIS 2024) 
  will be held in Tokyo, Japan, December 4-6, 2024.
  
  ## Topics of Interest
  
  We welcome submissions on all aspects of distributed systems, including but not limited to:
  
  - Distributed algorithms and protocols
  - Fault-tolerant and self-stabilizing systems
  - Concurrent and parallel algorithms
  - Network protocols and wireless networks
  - Distributed operating systems and middleware
  - Cloud and peer-to-peer computing
  - Blockchain and cryptocurrencies
  - Game theory and mechanism design
  - Security and privacy in distributed systems
  
  ## Important Dates
  
  Please see the [Dates](/#dates) section for submission deadlines.
  
  ## Submission Guidelines
  
  - Papers should be submitted in LIPIcs format
  - Maximum 14 pages excluding references
  - Submit via HotCRP: [https://opodis2024.hotcrp.com/](https://opodis2024.hotcrp.com/)
  
  ### Double-blind Review
  
  OPODIS uses double-blind reviewing. Author names and affiliations must be omitted 
  from submissions.
  
  ## Publication
  
  Accepted papers will be published in LIPIcs (Leibniz International Proceedings in 
  Informatics) with open access.
  
  ## Awards
  
  Best paper and best student paper awards will be presented at the conference.
  
  ## Registration and Presentation
  
  At least one author must register for the conference and present the paper.

# Where to submit
submission_link: "https://opodis2024.hotcrp.com/"

# Optional: external CFP page
external_cfp_url: null
```

**Key Features:**
- All content in single `text` block (markdown formatted)
- Lower granularity = easier to maintain
- Flexible formatting with markdown
- Links and formatting preserved

#### 1.6 Keynote Speakers (Initial)

**File:** `docs/_data/keynotes.yml`

```yaml
# Toggle visibility
show_on_site: true

# Initial keynote info - can be TBD
items:
  - number: 1
    speaker:
      name: "Keynote Speaker Name TBD"
      affiliation: "TBD"
      photo: null  # Will add later
    
    title: "Talk Title TBD"
    
    # Biography and abstract added in Stage 2-3
    bio: null
    abstract: null
  
  - number: 2
    speaker:
      name: "To be announced"
      affiliation: null
    title: null
    bio: null
    abstract: null
  
  - number: 3
    speaker:
      name: null
      affiliation: null
    title: null
    bio: null
    abstract: null
```

**Notes:**
- Use `speaker.name: "TBA"` or `"TBD"` for placeholders; the site shows a "To Be Announced" badge and the generator emits draft warnings so you remember to replace them.

**Note:** Site gracefully handles `null` and "TBD" values in templates.

#### 1.7 Site-wide Configuration

**File:** `docs/_data/site.yml`

```yaml
# Logo and branding
logo:
  image: "img/logo-opodis.png"
  alt: "OPODIS"
  url: "/"

# Navigation bar configuration
navigation:
  show_cfp: true         # Show link to CFP
  show_dates: true       # Show dates in navbar
  show_keynotes: true
  show_schedule: true    # Even if skeleton
  show_papers: false     # Hidden in Stage 1 (no accepted papers yet)
  show_committees: false # Hidden in Stage 1 (PC still forming)

# Footer configuration
footer:
  show_past_instances: true
  past_instances:
    - year: 2023
      url: "https://opodis2023.example.com"
    - year: 2022
      url: "https://opodis2022.example.com"
```

### Validation Checklist ✓

- [ ] `conference.yml` has year, acronym, general chairs
- [ ] `dates.yml` has CFP submission deadline
- [ ] `venue.yml` has city, country, timezone
- [ ] `program.yml` has basic 3-day skeleton with times
- [ ] `cfp.yml` has submission link and open status
- [ ] `keynotes.yml` has 3 entries (may be TBD)
- [ ] Generator warnings resolved (missing papers/chairs/keynotes, time format)
- [ ] Test build: `bundle exec jekyll build --source docs`
- [ ] Site renders without errors

---

## Stage 2: Build-out
**Timeline:** 7–4 months before the conference

### Goals
- Finalize program structure with session titles
- Confirm keynote speakers with bios/photos
- Publish program committee
- Add travel and accommodation information
- Update registration details

### Configuration Updates

#### 2.1 Keynote Details (Finalization)

**File:** `docs/_data/keynotes.yml`

Once speakers are confirmed, fill in details:

```yaml
items:
  - number: 1
    speaker:
      name: "Dr. Alice Johnson"
      affiliation: "MIT Computer Science"
      photo: "img/speakers/alice-johnson.jpg"
      bio: |
        Dr. Johnson is a professor of distributed systems at MIT...
    
    title: "Consensus in Unreliable Networks"
    
    abstract: |
      In this talk, we discuss how consensus algorithms can handle
      unreliable network conditions in modern distributed systems...
```

**Action Items:**
- [ ] Request speaker photos (high-res, square format preferred)
- [ ] Collect biographies (100-200 words)
- [ ] Finalize talk titles and abstracts
- [ ] Place photos in `docs/img/speakers/`

#### 2.2 Committees

**File:** `docs/_data/committees.yml`

Nested structure with toggles for each committee section.

```yaml
# Toggle visibility of entire committees section
enabled: true
show_on_site: true

# Organizing committee
organizing:
  general_chairs:
    enabled: true
    items:
      - name: "Xavier Défago"
        affiliation: "Tokyo Institute of Technology"
      - name: "Junya Nakamura"
        affiliation: "The University of Electro-Communications"
  
  publication_chair:
    enabled: true
    items:
      - name: "Publication Chair Name"
        affiliation: "University"
  
  organizing_team:
    enabled: true
    items:
      - name: "Team Member 1"
        affiliation: "Host University"
      - name: "Team Member 2"
        affiliation: "Host University"

# Steering committee
steering:
  enabled: true
  items:
    - name: "Steering Member 1"
      affiliation: "University"
    - name: "Steering Member 2"
      affiliation: "University"

# Program chairs
program_chairs:
  enabled: true
  items:
    - name: "PC Chair 1"
      affiliation: "University A"
    - name: "PC Chair 2"
      affiliation: "University B"

# Program committee members
program_committee:
  enabled: true
  items:
    - name: "Committee Member 1"
      affiliation: "University C"
    - name: "Committee Member 2"
      affiliation: "Company D"
    # ... many more members
```

**Key Features:**
- Each subsection has its own `enabled` toggle
- All members in `items` arrays
- Top-level `show_on_site` controls entire section visibility

**Action Items:**
- [ ] Collect committee member names and affiliations
- [ ] Organize by role (general_chairs, program_chairs, program_committee, etc.)
- [ ] Double-check spellings
- [ ] Set `enabled: true` for sections to display

#### 2.3 Program Schedule Details

**File:** `docs/_data/program.yml`

Update with session titles and assign papers (when available):

```yaml
schedule:
  # ... date/duration fields unchanged ...
  
  days:
    - date: 2024-12-04
      label: "Wed Dec 4"
      items:
        - time: "08:30"
          type: "registration"
        
        - time: "09:00"
          type: "opening"
        
        - time: "09:15"
          type: "keynote"
          number: 1
          # Chair confirmed in Stage 2
          chair: "Xavier Défago"
        
        - time: "10:15"
          type: "break"
        
        # Session now has title and chair
        - time: "10:45"
          type: "session"
          number: 1
          title: "Agreement Protocols"  # Finalized session title
          chair: "Junya Nakamura"
          papers: []  # Still empty if papers not yet assigned
        
        - time: "12:15"
          type: "break"
          label: "LUNCH"
        
        - time: "13:30"
          type: "session"
          number: 2
          title: "Blockchain and Byzantine Behavior"
          chair: "Seth Gilbert"
          papers: []
        
        # ... rest of day
```

**Action Items:**
- [ ] Finalize session titles
- [ ] Assign chairs to each session
- [ ] Verify schedule doesn't have conflicts

#### 2.4 Travel Information

**File:** `docs/_data/travel.yml`

Comprehensive travel guide with markdown formatting.

```yaml
# Toggle visibility
show_on_site: true

title: "Travel Information"

# Detailed airport information
airports:
  - code: "NRT"
    name: "Narita International Airport"
    distance: "About 60 km east of Tokyo"
    travel_time: "60-90 minutes by train"
    info: |
      Narita is Tokyo's primary international airport. Take the Narita Express (N'EX) 
      to Tokyo Station (60 min, ¥3,070) or the Keisei Skyliner to Ueno (45 min, ¥2,570).
  
  - code: "HND"
    name: "Haneda Airport"
    distance: "About 14 km south of Tokyo"
    travel_time: "30 minutes by train"
    info: |
      Haneda is closer to central Tokyo. Take the Keikyu Line or Tokyo Monorail to 
      connect to the subway system.

# Public transportation guide (markdown)
public_transport: |
  ## Getting Around Tokyo
  
  Tokyo has an excellent public transportation system:
  
  - **JR Lines:** Yamanote Line circles central Tokyo
  - **Metro:** 13 lines cover the entire city
  - **IC Cards:** Get a Suica or PASMO card for seamless travel
  
  Recommended card: Purchase a Suica card at any JR station (¥500 deposit, rechargeable).

# Directions to venue (markdown)
to_venue: |
  ## Getting to Tokyo Tech (O-okayama Campus)
  
  **From Tokyo Station:**
  - Take JR Yamanote Line to Meguro (20 min)
  - Transfer to Tokyu Meguro Line to O-okayama (3 min)
  - Exit and walk 1 minute to West Building 9
  
  **From Shinjuku:**
  - Take JR Shonan-Shinjuku Line to O-okayama (15 min, direct)
  
  [Campus Map](https://www.titech.ac.jp/english/maps)

# Visa requirements (markdown)
visa_info: |
  ## Visa Information
  
  Check visa requirements: [MOFA Japan](https://www.mofa.go.jp/j_info/visit/visa/)
  
  If you need an invitation letter, contact the organizers after registering.
```

**Key Features:**
- Airport details include distance, travel time, and specific transport info
- Markdown formatting for better structure
- Venue directions with multiple routes
- Visa info with links to official sources

#### 2.5 Registration Setup

**File:** `docs/_data/registration.yml`

```yaml
# Toggle visibility
  - **Buses:** Useful for some routes
  - **Taxis:** Expensive but convenient
  
  Consider getting a prepaid IC card (Suica/Pasmo) for easy travel.

# Getting to venue
to_venue: |
  ## Getting to Tokyo Institute of Technology
  
  - **By Train:** Take [specific line] from [station]...
  - **Walking:** From [station], about 10 minutes
  - **Maps:** [Link to Google Maps]

# Visa information
visa_info: |
  ## Visa Requirements
  
  Check [MOFA Japan](https://www.mofa.go.jp/) for visa requirements
  for your country. EU/US citizens typically get 90-day visitor status.
```

**Action Items:**
- [ ] Research local transportation
- [ ] Get venue directions finalized
- [ ] Check visa requirements for expected attendees
- [ ] Add airport transfer service info if available

#### 2.5 Registration Information

**File:** `docs/_data/registration.yml`

Structured pricing with separate currency field and a single early bird limit.

```yaml
# Toggle visibility
show_on_site: true

# Registration fees (numeric values, currency separate)
fees:
  currency: "EUR"               # Change to USD, GBP, JPY, etc. as needed
  early_limit: "2025-11-15"     # Single early bird limit date (YYYY-MM-DD)

  student:
    early_bird: 100              # Numeric values only
    late: 150
    on_site: 200

  regular:
    early_bird: 300
    late: 400
    on_site: 500

# What registration includes
what_is_included:
  - "Conference proceedings (LIPIcs)"
  - "Coffee breaks and lunches"
  - "Welcome reception"
  - "Conference dinner"

# Registration terms and policies (markdown)
terms: |
  ## Registration Terms
  
  - At least one author per paper must register
  - Non-refundable after [DATE]
  - Request visa letters after registering
```

**Key Structure:**
- **`fees.currency`** – Currency code (EUR, USD, GBP, JPY, etc.) displayed next to all prices
- **`fees.early_limit`** – Single date when Early Bird ends
- **`fees.student`**, **`fees.regular`** – Each contains `early_bird`, `late`, `on_site` numeric prices
- **`what_is_included`** – List of what's included in registration
- **`terms`** – Markdown text for registration policies

**Action Items:**
- [ ] Determine pricing in your currency
- [ ] Set early bird limit (optional; can be distinct from dates.yml)
- [ ] Choose registration platform (Google Forms, Eventbrite, EasyChair, custom)
- [ ] Confirm what's included in registration
- [ ] Draft cancellation and visa policies

### Validation Checklist ✓

- [ ] Keynote speakers confirmed with photos and bios
- [ ] Program committee published (all members collected)
- [ ] Session titles and chairs finalized
- [ ] Travel and venue directions complete
- [ ] Registration pricing and link ready
- [ ] `bundle exec ruby scripts/generate_outline_grid.rb` succeeds
- [ ] Site builds and renders correctly

---

## Stage 3: Maturation
**Timeline:** 3–1 month(s) before the conference

### Goals
- Publish accepted papers
- Assign papers to sessions
- Complete all details
- Enable all sections on site
- Activate countdown/urgency messaging

### Configuration Updates

#### 3.1 Accepted Papers

**File:** `docs/_data/papers.yml`

Flexible author schema supporting strings, arrays, or detailed objects.

```yaml
# Toggle visibility
enabled: true
show_on_site: true

# Control affiliation display
show_affiliations_in_list: true
show_affiliations_in_schedule: false

# All papers in items array
items:
  # Simple string author
  - number: 1
    title: "A New Consensus Algorithm for Distributed Systems"
    authors: "Alice Smith, Bob Johnson"
  
  # Array of authors (strings)
  - number: 2
    title: "Byzantine Behavior in Modern Networks"
    authors:
      - "Carol Davis"
      - "Eve Martinez"
  
  # Detailed author objects with affiliations
  - number: 3
    title: "Scalable Distributed Ledger"
    authors:
      - name: "Frank Wilson"
        affiliation: "MIT"
      - name: "Grace Lee"
        affiliation: "Stanford"
  
  # ... many more papers (35 total in example)
```

**Key Features:**
- **Flexible authors:** Can be string, array of strings, or array of `{name, affiliation}` objects
- **Affiliation toggles:** Separate control for list view vs. schedule view
- **Required fields:** `number` and `title` only; `authors` optional

**Action Items:**
- [ ] Export accepted papers from review system
- [ ] Add papers with consistent numbering
- [ ] Choose author format based on your needs
- [ ] Set affiliation display preferences

#### 3.2 Assign Papers to Sessions

**File:** `docs/_data/program.yml`

Now papers are assigned by reference number:

```yaml
schedule:
  days:
    - date: 2024-12-04
      items:
        - time: "10:45"
          type: "session"
          number: 1
          title: "Agreement Protocols"
          chair: "Junya Nakamura"
          
          # Papers now assigned (using paper number from papers.yml)
          papers:
            - number: 3
            - number: 5
            - number: 12
        
        - time: "13:30"
          type: "session"
          number: 2
          title: "Blockchain and Byzantine Behavior"
          chair: "Seth Gilbert"
          papers:
            - number: 2
            - number: 8
            - number: 15
            - number: 21
```

**Validation:**
- [ ] All paper numbers reference actual papers in `papers.yml`
- [ ] Papers don't exceed session time (e.g., 3 papers × 20 min = 60 min max)
- [ ] Each paper appears in exactly one session
- [ ] No paper assigned to multiple sessions
- [ ] Session chairs are free-form and not validated against committees

#### 3.3 Update Schedule with Time Ranges or Explicit Durations

Prefer time ranges when you know both start and end. Otherwise, add `duration` (minutes) and let the generator compute end times:

```yaml
items:
  - time: "08:00-08:45"  # Explicit range
    type: "registration"
  
  - time: "08:45"        # Start time only
    type: "opening"
    duration: 15          # Optional explicit duration
```

End times resolve in this order: time range → explicit `duration` → computed (papers/keynotes) → next item's start. The generator validates overlaps and warns about gaps.

#### 3.4 Enable All Sections

**File:** `docs/_data/site.yml`

Update visibility flags:

```yaml
navigation:
  show_cfp: true
  show_dates: true
  show_keynotes: true
  show_schedule: true
  show_papers: true          # Now enabled
  show_committees: true      # Now enabled
  show_registration: true
  show_sponsors: true
```

#### 3.5 Sponsors

**File:** `docs/_data/sponsors.yml`

```yaml
title: "Sponsors"

# Sponsor tiers (Gold, Silver, etc.)
tiers:
  platinum:
    name: "Platinum Sponsors"
    sponsors:
      - name: "Company A"
        logo: "img/sponsors/company-a.png"
        url: "https://company-a.com"
  
  gold:
    name: "Gold Sponsors"
    sponsors:
      - name: "Company B"
        logo: "img/sponsors/company-b.png"
        url: "https://company-b.com"
      - name: "Company C"
        logo: "img/sponsors/company-c.png"
        url: "https://company-c.com"
  
  silver:
    name: "Silver Sponsors"
    sponsors:
      - name: "Company D"
        logo: "img/sponsors/company-d.png"
        url: "https://company-d.com"
```

**Action Items:**
- [ ] Collect sponsor logos in `docs/img/sponsors/`
- [ ] Organize by sponsorship tier
- [ ] Get approval for each logo and link
- [ ] Update sponsor contract details if needed

### Validation Checklist ✓

- [ ] Papers list complete with titles, authors, abstracts
- [ ] Papers assigned to all sessions
- [ ] Schedule validates: `bundle exec ruby scripts/generate_outline_grid.rb`
- [ ] No papers exceed session time
- [ ] All navigation sections enabled and visible
- [ ] Sponsors added with logos
- [ ] Final site review: `bundle exec jekyll serve`
- [ ] [ ] All deadlines in past are marked as closed

---

## Stage 4: Launch
**Timeline:** Final 2 weeks

### Final Checks

```yaml
# docs/_data/registration.yml
status: "deadline_approaching"  # If registration still open

# docs/_data/site.yml
# Verify all toggles are correct
navigation:
  show_cfp: true             # May be closed
  show_papers: true
  show_committees: true
  show_registration: true    # Unless you want to hide
  show_schedule: true
```

### Launch Deployment

```bash
# Final build
bundle exec jekyll build --source docs --destination docs/_site --force

# Deploy to production
# (Process depends on your hosting setup)
```

### Post-Launch Updates

After launch, frequent updates:

```yaml
# Registration closing soon?
# docs/_data/registration.yml
status: "deadline_approaching"

# Conference underway?
# docs/_data/registration.yml
status: "closed_on_site_available"
```

### Archive Configuration

After conference:

```yaml
# docs/_data/conference.yml
status: "completed"  # Optional flag for past conferences
archived: true

# docs/_data/registration.yml
status: "closed"
```

---

## Configuration Reference

### Common Fields

#### Dates
```yaml
# ISO 8601 format (preferred)
date: "2024-12-04"
datetime: "2024-12-04T09:15:00Z"

# Timezone-aware
deadline: "2024-03-31T23:59:59+02:00"  # EET (UTC+2)
```

#### Status Fields
```yaml
# Visibility control
status: "closed|open|opens_soon|upcoming|completed"
show: true|false
enabled: true|false
```

#### TBD/Placeholder Values
```yaml
# Handling unknown information gracefully
speaker:
  name: "To be announced"  # or null
  affiliation: "TBD"
  
title: null                # Will render as "TBD" in some templates

chair: "TBA"              # To Be Announced
```

#### Contact Information
```yaml
contact:
  name: "Name"
  email: "email@example.com"
  phone: "+1 (555) 123-4567"  # Optional
  affiliation: "Organization"
```

---

## Troubleshooting

### Schedule Generation Fails

**Error:** "Cannot infer end time"

**Solution:**
```yaml
# Add duration or ensure next item has time
items:
  - time: "09:00"
    type: "opening"
    duration: 10       # Add this
  
  - time: "09:10"     # Or ensure next item starts here
    type: "keynote"
```

You can also use explicit ranges (`"09:00-09:10"`). End times resolve in order: range → explicit `duration` → computed (papers/keynotes) → next item's start.

### Papers Don't Show in Schedule

**Cause:** Paper numbers don't match `papers.yml`

**Solution:**
```bash
# Verify paper references
bundle exec ruby scripts/generate_outline_grid.rb
```

This generates helpful error messages.

### Section Not Appearing on Site

**Cause:** Visibility flag is false

**Solution:**
1. Check `site.yml` navigation flags
2. Check individual YAML file's `enabled` or `show` flag
3. Rebuild: `bundle exec jekyll build --source docs`

---

## Summary: Configuration Checklist by Stage

### Stage 1 (Month 9-8)
- [ ] conference.yml: basics
- [ ] dates.yml: CFP deadline
- [ ] venue.yml: city, country, timezone
- [ ] program.yml: skeleton schedule
- [ ] cfp.yml: submission link
- [ ] keynotes.yml: 3 TBD entries

### Stage 2 (Month 7-4)
- [ ] keynotes.yml: full details with photos
- [ ] committees.yml: all members
- [ ] program.yml: session titles and chairs
- [ ] travel.yml: complete
- [ ] registration.yml: pricing and link
- [ ] navigation flags in site.yml

### Stage 3 (Month 3-1)
- [ ] papers.yml: all accepted papers
- [ ] program.yml: papers assigned to sessions
- [ ] sponsors.yml: logos added
- [ ] All visibility toggles enabled
- [ ] Final review and testing

### Stage 4 (Final weeks)
- [ ] Final validation and build
- [ ] Deploy to production
- [ ] Update status fields (e.g., registration closing)
- [ ] Post-conference archive

---

**For quick setup, see [QUICKSTART.md](QUICKSTART.md)**  
**For build and deployment, see [BUILD.md](BUILD.md)**
