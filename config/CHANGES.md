# Configuration Changes Summary

This document summarizes the major structural changes made to align the OPODIS website template with consistent documentation patterns.

## Overview

All YAML configuration files and templates have been updated to:
1. **Eliminate inconsistencies** between documentation (CONFIG.md, QUICKSTART.md) and actual implementation
2. **Implement visibility toggles** via `enabled` and `show_on_site` flags on all data files
3. **Simplify data structures** to match original CONFIG.md patterns (lower granularity, markdown text blocks)
4. **Support flexible schemas** for papers authors and date updates

## 2026-01-08 — Schedule Durations and Ranges

- Documented explicit time ranges (`HH:MM-HH:MM`) and optional `duration` fields; generator resolves end times in order: range → explicit `duration` → computed (papers/keynotes) → next item's start
- Generator validation now warns on overlaps and gaps; BUILD instructions call out rerunning the generator after any `program.yml` change
- QUICKSTART and CONFIG examples updated to show time ranges/durations; troubleshooting guidance clarified

## 2026-01-08 — Validator Diagnostics, Draft Styling, Chairs Policy

- Structured validator output for papers/keynotes/time formats (compiler-style location + context), including draft warnings for TBA/TBD speakers
- Time-format validation now accepts ranges (`HH:MM-HH:MM`) and reports invalid entries with context
- Added TBA/TBD badge styling in keynote cards and schedule view; Quickstart/CONFIG note how to mark placeholders
- Session chairs are treated as free-form text sourced only from `program.yml` (no cross-referencing with committees)

## Data Files Modified

### 1. dates.yml
**Structure:** Nested cfp/registration blocks with flexible date updates

**Key Changes:**
- Removed legacy `items` array
- Removed `conference.start/end` (now only in conference.yml)
- Removed redundant `program` wrapper
- Implemented flexible date pattern: string OR `[original, updated]` array
- Each date has optional `label` and `status` fields

**Example:**
```yaml
cfp:
  submission_deadline:
    date: ["2023-09-01", "2023-09-08"]  # shows strikethrough on original
    label: "Submission deadline"
    status: "auto"
```

### 2. cfp.yml
**Structure:** Single markdown text block (lower granularity)

**Key Changes:**
- Consolidated all CFP content into single `text` markdown block
- Removed granular fields: `topics`, `double_blind`, `submission_requirements`, `submission_notes`, `publication`, `awards`, `registration_policy`
- Kept simple `submission_link` and `external_cfp_url`

**Benefits:**
- Easier to maintain (edit one block vs. many fields)
- More flexible formatting
- Matches CONFIG.md documented pattern

### 3. registration.yml
**Structure:** Simplified pricing blocks

**Key Changes:**
- Replaced complex `copy`/`categories` structure with simple `pricing.{early_bird, standard, on_site}` blocks
- Each pricing block has: `deadline`, `student`, `regular`, `description`
- Added `what_is_included` list
- Consolidated policies into single `terms` markdown block

**Size Reduction:** 2.8 KB → 1.3 KB (54% reduction)

### 4. travel.yml
**Structure:** Airports/transport/venue/visa with detailed fields

**Key Changes:**
- Enhanced `airports` with: `code`, `name`, `distance`, `travel_time`, `info`
- Converted to markdown: `public_transport`, `to_venue`, `visa_info`
- Removed legacy fields: `by_train`, `by_plane`, `hotels`

**Benefits:**
- More structured airport information
- Markdown formatting for complex directions
- Matches CONFIG.md documented pattern

### 5. papers.yml
**Structure:** Flexible author schema with affiliation toggles

**Key Changes:**
- Wrapped papers in `items` array
- Added `show_affiliations_in_list` and `show_affiliations_in_schedule` toggles
- Implemented flexible authors: string | array of strings | array of `{name, affiliation}` objects

**Example:**
```yaml
# All three formats work:
authors: "Alice, Bob"
authors: ["Alice", "Bob"]
authors:
  - name: "Alice"
    affiliation: "MIT"
```

### 6. committees.yml
**Structure:** Nested items with per-section toggles

**Key Changes:**
- All committee lists wrapped in `items` arrays
- Each subsection has `enabled` toggle: `organizing.general_chairs`, `organizing.publication_chair`, `program_chairs`, `program_committee`, `steering`
- Top-level `enabled` and `show_on_site` control entire section

### 7. venue.yml, sponsors.yml
**Minimal Changes:**
- Added `show_on_site: true` toggle for consistency

### 8. conference.yml
**No Structural Changes:**
- Already had correct `general`/`year` split
- Added documentation clarification in CONFIG.md

## Templates Updated

### 1. cfp.html
- Renders single `text` markdown block with `markdownify` filter
- Removed loops for `topics`, `submission_requirements`, etc.

### 2. dates.html
- Complete rewrite for nested `cfp.*` and `registration.*` structure
- Handles flexible date arrays `[original, updated]`
- Renders strikethrough on original when updated
- Removed legacy `items` array fallback

### 3. registration.html
- Complete rewrite for simplified pricing blocks
- Renders `pricing.{early_bird, standard, on_site}` as cards
- Displays `what_is_included` list
- Renders `terms` as markdown

### 4. travel.html
- Updated to render detailed airport fields
- Markdown rendering for `public_transport`, `to_venue`, `visa_info`
- Removed legacy field fallbacks

### 5. accepted_papers.html
- Supports flexible author formats (string/array/object)
- Respects `show_affiliations_in_list` toggle

### 6. program_schedule.html
- Supports flexible authors in schedule
- Respects `show_affiliations_in_schedule` toggle

### 7. committees.html
- Uses nested `items` structure
- Checks `enabled` flag for each subsection

### 8. venue.html, sponsors.html
- Added `enabled`/`show_on_site` gates

### 9. header.html
- Navigation uses per-data `show_on_site` toggles (case statement)

### 10. index.html
- Section includes gated by per-data `show_on_site` checks

## Documentation Updated

### CONFIG.md
Updated sections for:
- **1.2 Important Dates:** Nested structure, flexible date arrays, status/label fields
- **1.5 Call for Papers:** Markdown text block pattern
- **2.2 Committees:** Nested items structure with enabled toggles
- **2.4 Travel:** Airports, public_transport, to_venue, visa_info structure
- **2.5 Registration:** Simplified pricing blocks
- **3.1 Accepted Papers:** Flexible author schema with toggles

### QUICKSTART.md
Updated examples for:
- Dates.yml with date arrays
- Papers.yml with flexible authors
- Committees.yml with nested structure
- CFP.yml with markdown text
- Travel.yml with airports/transport
- Registration.yml with pricing blocks

## Visibility Toggle System

All 11 data files now have consistent visibility controls:

| File | Toggle Fields |
|------|---------------|
| conference.yml | `show_on_site` |
| dates.yml | `show_on_site` |
| cfp.yml | `show_on_site` |
| travel.yml | `show_on_site` |
| registration.yml | `enabled`, `show_on_site` |
| venue.yml | `show_on_site` |
| sponsors.yml | `show_on_site` |
| committees.yml | `enabled`, `show_on_site` + per-subsection `enabled` |
| papers.yml | `enabled`, `show_on_site` + affiliation toggles |
| program.yml | `show_on_site` |
| keynotes.yml | `show_on_site` |

**Removed:** `site.sections` centralized toggle block (replaced by per-data toggles)

## Testing

All changes validated:
- ✅ `bundle exec ruby scripts/generate_outline_grid.rb` - successful
- ✅ `bundle exec jekyll build --source docs` - successful (0 errors)
- ✅ All templates consume new data structures correctly
- ✅ Backward compatibility maintained where feasible (fallbacks in templates)

## Migration Notes

For existing OPODIS instances:

1. **dates.yml:** Move to nested structure; conference dates go in `conference.yml` only
2. **cfp.yml:** Consolidate granular fields into single `text` block
3. **registration.yml:** Replace categories with simple pricing blocks
4. **travel.yml:** Enhance airport data, convert text to markdown
5. **papers.yml:** Wrap in `items`, add affiliation toggles
6. **committees.yml:** Wrap all lists in `items` with `enabled` flags
7. **site.yml:** Delete `sections` block
8. **All files:** Add appropriate `show_on_site` toggles

## Benefits

1. **Consistency:** Documentation matches implementation exactly
2. **Maintainability:** Simpler structures, less duplication
3. **Flexibility:** Support for common patterns (date updates, various author formats)
4. **Clarity:** Comprehensive inline comments in all YAML files
5. **Control:** Granular visibility toggles per data file and subsection
