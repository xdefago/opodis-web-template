# Post-Migration Validation Checklist

Use this checklist after applying the configuration changes to ensure everything works correctly.

## Build Validation

- [x] `bundle exec ruby scripts/generate_outline_grid.rb` runs without errors
- [x] `bundle exec jekyll build --source docs` completes successfully
- [ ] `bundle exec jekyll serve --source docs --livereload` starts server
- [ ] Site loads at http://localhost:4000 without errors

## Data File Validation

### All Files Have Toggles
- [x] conference.yml has `show_on_site`
- [x] dates.yml has `show_on_site`
- [x] cfp.yml has `show_on_site`
- [x] travel.yml has `show_on_site`
- [x] registration.yml has `enabled` and `show_on_site`
- [x] venue.yml has `show_on_site`
- [x] sponsors.yml has `show_on_site`
- [x] committees.yml has `enabled` and `show_on_site`
- [x] papers.yml has `enabled` and `show_on_site`
- [x] program.yml has `show_on_site`
- [x] keynotes.yml has `show_on_site`

### Structure Validation

#### dates.yml
- [x] Has nested `cfp` block with date fields
- [x] Has nested `registration` block with date fields
- [x] Each date can be string OR array `[original, updated]`
- [x] NO `conference.start/end` (those are in conference.yml only)
- [x] NO legacy `items` array
- [x] Has informative header comments

#### cfp.yml
- [x] Has single `text` markdown block
- [x] NO `topics` array
- [x] NO `double_blind`, `submission_requirements`, `submission_notes`, `publication`, `awards`, `registration_policy` fields
- [x] Has `submission_link`
- [x] Has informative header comments

#### registration.yml
- [x] Has `pricing.early_bird` with deadline/student/regular
- [x] Has `pricing.standard` with deadline/student/regular
- [x] Has `pricing.on_site` with student/regular
- [x] Has `what_is_included` list
- [x] Has `terms` markdown block
- [x] NO `copy`, `pricing_labels`, `categories` fields
- [x] Has informative header comments

#### travel.yml
- [x] Has `airports` array with code/name/distance/travel_time/info
- [x] Has `public_transport` markdown block
- [x] Has `to_venue` markdown block
- [x] Has `visa_info` markdown block
- [x] NO `by_train`, `by_plane`, `hotels` fields
- [x] Has informative header comments

#### papers.yml
- [x] Papers wrapped in `items` array
- [x] Has `show_affiliations_in_list` toggle
- [x] Has `show_affiliations_in_schedule` toggle
- [x] Supports flexible authors (string/array/object)
- [x] Has informative header comments

#### committees.yml
- [x] Has `organizing.general_chairs.{enabled, items}`
- [x] Has `organizing.publication_chair.{enabled, items}`
- [x] Has `organizing.organizing_team.{enabled, items}`
- [x] Has `steering.{enabled, items}`
- [x] Has `program_chairs.{enabled, items}`
- [x] Has `program_committee.{enabled, items}`
- [x] Has informative header comments

#### conference.yml
- [x] Has `general` block with series defaults
- [x] Has `year` block with instance overrides
- [x] `year.dates.start` exists (conference start date)
- [x] `year.dates.end` exists (conference end date)

#### site.yml
- [x] NO `sections` block (removed - replaced by per-data toggles)

## Template Validation

### Section Templates Updated
- [x] cfp.html renders `cfp.text` with markdownify
- [x] dates.html handles nested `cfp.*` and `registration.*`
- [x] dates.html renders date arrays with strikethrough
- [x] registration.html renders pricing blocks
- [x] registration.html renders what_is_included list
- [x] travel.html renders airports with all fields
- [x] travel.html renders markdown blocks
- [x] venue.html has enabled/show_on_site gate
- [x] sponsors.html has enabled/show_on_site gate
- [x] accepted_papers.html supports flexible authors
- [x] program_schedule.html supports flexible authors
- [x] committees.html uses nested items structure

### Navigation & Layout
- [x] header.html uses per-data toggles (NO site.sections references)
- [x] index.html uses per-data toggles for section includes

## Functional Testing

### Navigation
- [ ] Menu items appear/disappear based on `show_on_site` toggles
- [ ] All nav links work correctly

### Sections
- [ ] Dates section displays with proper formatting
- [ ] Date updates show strikethrough on original
- [ ] CFP renders as formatted markdown
- [ ] Registration shows pricing cards correctly
- [ ] Travel shows airport info, transport, venue directions, visa
- [ ] Committees show all subsections with members
- [ ] Papers list shows with correct author format
- [ ] Program schedule displays papers with authors
- [ ] Venue section visible
- [ ] Sponsors section visible

### Toggles
- [ ] Set `cfp.show_on_site: false` → CFP nav item disappears
- [ ] Set `committees.organizing.general_chairs.enabled: false` → General chairs hidden
- [ ] Set `papers.show_affiliations_in_list: false` → No affiliations in papers list

## Search for Issues

Run these commands to verify no lingering problems:

```bash
# No references to removed site.sections
grep -r "site\.data\.site\.sections" docs/_includes/

# No references to removed CFP fields
grep -r "cfp\.topics\|cfp\.double_blind\|cfp\.submission_requirements" docs/_includes/

# No references to removed registration fields
grep -r "reg\.copy\|reg\.pricing_labels\|reg\.categories" docs/_includes/

# No conference dates in dates.yml
grep "conference:" docs/_data/dates.yml

# Conference dates exist in conference.yml
grep "dates:" docs/_data/conference.yml
```

All should return empty (or correct results for last two).

## Documentation Check

- [x] CONFIG.md updated for dates, cfp, travel, registration, committees, papers
- [x] QUICKSTART.md updated with examples for all modified structures
- [x] CHANGES.md created with summary

## Compatibility

- [x] Templates have fallbacks for backward compatibility where feasible
- [ ] Old YAML files can be migrated with documented patterns

## Performance

- [ ] Page load time acceptable
- [ ] No console errors in browser
- [ ] All images load correctly

## Final Check

- [ ] Run full test suite (if available)
- [ ] Review generated HTML for correctness
- [ ] Test on mobile/tablet viewports
- [ ] Verify print stylesheet works

---

## Issues Found

Document any issues discovered during validation:

1. 
2. 
3. 

## Notes

Document any observations or recommendations:

1. 
2. 
3.
