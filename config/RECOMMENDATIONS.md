# Recommendations: Repository Refinements

**Based on:** Comparative analysis of OPODIS 2022, 2023, 2025 instances  
**Status:** Actionable recommendations for repository improvement  
**Priority Levels:** High (quick wins), Medium (important features), Low (enhancements)

---

## Executive Summary

The current repository structure is **sound and reusable**. Recommended improvements are **additive** (no breaking changes) and fall into three categories:

1. **Structural improvements** – Better support for planning stages
2. **Feature additions** – Enable capabilities observed in historical instances
3. **Quality enhancements** – Better error handling and validation

---

## High Priority (Implement Next Sprint)

### 1. Add Visibility/Activation Toggles

**Current Issue:** All configured items appear on site regardless of completion status.

**Recommendation:** Add `enabled` and `show_on_site` flags to control visibility.

**Impact:** Allows early-stage configuration without visual clutter.

**Implementation:**

```yaml
# docs/_data/committees.yml
committees:
  enabled: true                    # Can be set to false until finalized
  show_on_site: false              # Hidden until Month 6
  
  program_committee:
    enabled: true
    items:
      - name: "..."
        affiliation: "..."

# docs/_data/papers.yml
papers:
  enabled: true
  show_on_site: false              # Hidden until peer review complete
  items: [...]

# docs/_includes/sections/committees.html
{% if site.data.committees.show_on_site %}
  <!-- Render committees -->
{% endif %}
```

**Effort:** Low (1-2 hours)  
**Benefit:** High (supports progressive disclosure)

---

### 2. Implement Configuration Validation in Generator

**Current Issue:** Errors are caught late, sometimes after Jekyll build.

**Recommendation:** Add pre-validation to `scripts/generate_outline_grid.rb`.

**Impact:** Faster feedback loop for configuration errors.

**Add Checks For:**
- [ ] All paper numbers referenced in schedule exist in `papers.yml`
- [ ] All chairs mentioned in schedule exist (either in keynotes or committees)
- [ ] No paper appears in multiple sessions
- [ ] Time formatting is consistent (HH:MM)
- [ ] Paper count doesn't exceed session time
- [ ] Paper references have matching entries

**Example Output:**
```
warning[paper-404]: Paper #42 referenced in Session 3 but not in papers.yml
   --> program.yml:day-1, session-3
    | papers: [40, 41, 42, 43]
    | note: Add paper #42 to papers.yml or remove from session.
```

**Effort:** Medium (3-4 hours)  
**Benefit:** High (catches errors early)

---

### 3. Create Program Committee Display Template

**Current Issue:** Committee member list is not currently displayed on site.

**Recommendation:** Create `docs/_includes/sections/committees.html` template.

**Impact:** Enables publication of organizing and program committees.

**Template Features:**
- [ ] Render organizing committee (general chairs, publication chair, team)
- [ ] Render steering committee (series-level governance)
- [ ] Render program committee (PC chair, vice chairs, members)
- [ ] Role-based styling (chairs in bold/prominent)
- [ ] Affiliation display
- [ ] Support for TBA/incomplete entries
- [ ] Responsive layout for mobile

**Similar To:** 
```html
<!-- Like keynotes section but for committee members -->
<section id="committees">
  <h2>Committees</h2>
  
  <div class="committee-group">
    <h3>Program Committee</h3>
    <ul>
      {% for member in site.data.committees.program_committee.members %}
        <li>
          <strong>{{ member.name }}</strong> {% if member.role %}({{ member.role }}){% endif %}
          <br>{{ member.affiliation }}
        </li>
      {% endfor %}
    </ul>
  </div>
</section>
```

**Effort:** Low (2-3 hours)  
**Benefit:** Medium (needed feature)

---

## Medium Priority (Implement in Following Sprint)

### 4. Add Explicit Duration Support with Time Ranges

**Current Issue:** 2025 instance uses time ranges (08:00 - 08:45), but current system infers durations.

**Recommendation:** Add optional explicit `duration` field to items (already partially done).

**Impact:** Allows explicit time ranges without relying on next item's start time.

**Enhancement:**
```yaml
# docs/_data/program.yml
items:
  - time: "08:00"
    type: "registration"
    duration: 45           # Explicit: 08:00 - 08:45
  
  - time: "08:45"
    type: "opening"
    duration: 15           # Explicit: 08:45 - 09:00
  
  # Or use implicit (current method)
  - time: "09:00"
    type: "keynote"
    # Duration inferred from papers or next item
```

**Generator Updates:**
- [ ] Prioritize explicit duration if provided
- [ ] Fall back to computed duration (papers × 20min)
- [ ] Fall back to next item's start time
- [ ] Validate no gaps or overlaps

**Effort:** Low (1-2 hours, mostly testing)  
**Benefit:** Medium (supports 2025-style configuration)

---

### 5. Enhanced Error Messages (Rust Compiler Style)

**Current Status:** Already implemented in generator!

**Observation:** Current error format is excellent:
```
error[duration-overlap]: duration exceeds start of next item
   --> Fri Dec 8 • item 8 • closing
    | start: 17:50
    | note: Ends at 18:00 but next item starts at 17:50.
```

**Recommendation:** Extend to other validators (papers, chairs, etc.).

**To Add:**
```
error[paper-404]: Paper not found
   --> program.yml:Wed Dec 4, Session 1, paper index 2
    | papers: [3, 5, 12]
    | note: Paper #12 referenced but not in papers.yml
error[paper-404]

error[chair-unknown]: Session chair not found
   --> program.yml:Wed Dec 4, Session 1
    | chair: "Unknown Person"
    | note: Add "Unknown Person" to committees.yml or update name
error[chair-unknown]
```

**Effort:** Medium (3-4 hours)  
**Benefit:** High (better user experience)

---

### 6. Draft and TBD Content Styling

**Current Issue:** TBA/TBD entries render same as confirmed entries.

**Recommendation:** Add CSS classes and UI indicators for pending content.

**Implementation:**
```yaml
# In YAML
keynotes:
  items:
    - number: 1
      speaker:
        name: "TBA"        # Triggers draft styling
        affiliation: null
      title: null          # Optional if TBA
```

```html
<!-- Template -->
<div class="keynote {% if speaker.name == 'TBA' %}draft-content{% endif %}">
  <span class="badge badge-warning">To Be Announced</span>
  {{ speaker.name }}
</div>
```

```css
/* CSS */
.draft-content {
  opacity: 0.6;
  border-left: 3px solid #ffc107;
}
.badge-tba {
  background-color: #ffc107;
  color: #333;
}
```

**Effort:** Low (2 hours)  
**Benefit:** Medium (better clarity on pending items)

---

## Low Priority (Enhancements)

### 7. Build Interactive Configuration Helper

**Purpose:** Guide new administrators through configuration process.

**Idea:** CLI tool that:
- [ ] Prompts for essential information (year, location, dates)
- [ ] Generates config skeleton from previous year
- [ ] Validates configuration as you go
- [ ] Suggests next steps based on completion
- [ ] Exports checklist for your planning process

**Effort:** High (6+ hours)  
**Benefit:** Low-Medium (nice to have, saves time)

```bash
$ bundle exec ruby scripts/new_conference.rb

Welcome to OPODIS Conference Setup!
What year? 2025
What city? Tokyo
What country? Japan

Generating base configuration...
Created docs/_data/conference.yml
Created docs/_data/dates.yml

What's next?
[ ] Set important dates in docs/_data/dates.yml
[ ] Add keynote speakers to docs/_data/keynotes.yml
[ ] Configure program schedule in docs/_data/program.yml

Continue? (y/n)
```

---

### 8. Previous Years Archive Support

**Purpose:** Serve and link to previous conference instances.

**Idea:** 
- Archive structure for old instances
- Site switcher dropdown showing past years
- Automated version management

**Effort:** High (6+ hours, depends on hosting)  
**Benefit:** Low (nice historical reference)

---

### 9. Multi-Language Support Framework

**Purpose:** If conference goes international, support translations.

**Current State:** Does not prevent multilingual content.

**To Add:**
```yaml
# docs/_data/site.yml
language: "en"  # Could be "en", "fr", "ja", etc.
available_languages:
  - code: "en"
    name: "English"
  - code: "fr"
    name: "Français"
```

**Effort:** High (architecture changes)  
**Benefit:** Low (only if needed)

---

## Implementation Roadmap

### Sprint 1 (Weeks 1-2) – Quick Wins

- [x] Add visibility toggles to section YAML
- [x] Implement committees display template
- [x] Document recommendations (this file)
- [ ] Test with new instance setup

**Time Estimate:** 4-6 hours  
**Blockers:** None

### Sprint 2 (Weeks 3-4) – Quality Improvements

- [ ] Add configuration validation in generator
- [ ] Enhance error messages
- [ ] Add draft/TBD styling
- [ ] Test edge cases

**Time Estimate:** 8-10 hours  
**Blockers:** None

### Sprint 3 (Weeks 5-6) – Optional Enhancements

- [ ] Explicit duration support (mostly testing)
- [ ] Performance optimizations
- [ ] Documentation updates

**Time Estimate:** 4-6 hours  
**Blockers:** None

### Future – Advanced Features

- [ ] Interactive configuration helper
- [ ] Previous years archive
- [ ] Multilingual support

**Time Estimate:** 12+ hours per feature  
**Consider:** Only if multiple instances need support

---

## Testing Strategy

### For Each Improvement

1. **Create Test Case** – Use OPODIS 2022/2023/2025 data as test fixtures
2. **Validate Backward Compatibility** – Ensure old configs still work
3. **Test Edge Cases** – Empty lists, null values, missing fields
4. **Update Documentation** – CONFIG.md, QUICKSTART.md, YAML comments
5. **Manual Site Review** – Build site and check visual output

### Test Data

Use `tmp/opodis2022/`, `tmp/opodis2023/`, `tmp/opodis2025/` as:
- Reference implementations
- Test fixtures
- Validation data
- Before/after comparisons

---

## Success Criteria

After implementing High Priority recommendations:

- [ ] New OPODIS instance can be set up in <30 minutes (currently ~1 hour)
- [ ] Configuration errors caught before Jekyll build
- [ ] All committees publishable on site
- [ ] Support for multiple time-range formats
- [ ] Setup time reduced by 50% vs manual
- [ ] New maintainers can onboard with QUICKSTART.md alone

---

## Risk Assessment

### Low Risk Recommendations

✅ Visibility toggles – Purely additive, no breaking changes  
✅ Committees display – New section, no impact on existing  
✅ Error messages – Improvements to feedback, no output changes  
✅ Draft styling – Optional, default unchanged  

### Medium Risk

⚠️ Configuration validation – Could reject valid configs (test thoroughly)  
⚠️ Explicit duration – Changes time calculation logic (validate against all 3 instances)  

### Implementation Safeguards

1. **Keep all changes backward compatible**
2. **Add feature flags/toggles** before rolling out
3. **Test against historical instances**
4. **Document deprecations clearly**
5. **Provide migration guide** if needed

---

## Long-term Vision

The goal is to make OPODIS website setup **as easy as possible** for future instances:

- 🎯 **15-minute setup** with QUICKSTART.md
- 🎯 **Progressive disclosure** throughout planning cycle
- 🎯 **Automatic validation** with helpful errors
- 🎯 **Reusable templates** across years
- 🎯 **No code changes needed** – configuration only

Current status: **80% toward goal**  
With High Priority recommendations: **95% toward goal**  
With Medium Priority: **Nearly 100%**

---

## References

- **Comparative Analysis:** [tmp/analysis/similarity.md](tmp/analysis/similarity.md)
- **Quick Start:** [QUICKSTART.md](QUICKSTART.md)
- **Detailed Configuration:** [CONFIG.md](CONFIG.md)
- **Test Data:** `tmp/opodis2022/`, `tmp/opodis2023/`, `tmp/opodis2025/`
- **Generator Code:** [scripts/generate_outline_grid.rb](scripts/generate_outline_grid.rb)

---

**Recommendation Document Version:** 1.0  
**Date:** January 8, 2026  
**Status:** Ready for review and implementation planning
