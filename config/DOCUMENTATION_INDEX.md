# OPODIS Website Documentation Index

Complete guide to all documentation in this repository.

## Start Here

**New to this project?**  
👉 Read [QUICKSTART.md](QUICKSTART.md) (5 minutes)

**Setting up a conference?**  
👉 Follow [CONFIG.md](CONFIG.md) (stage-by-stage guide)

**Troubleshooting a build?**  
👉 Check [BUILD.md](BUILD.md)

---

## Documentation by Purpose

### For Users & Maintainers

| Document | Purpose | Time | Audience |
|----------|---------|------|----------|
| [README.md](/README.md) | Project overview, features, quick links | 5 min | Everyone |
| [QUICKSTART.md](/QUICKSTART.md) | 15-minute setup for new instance | 15 min | Conference organizers |
| [CONFIG.md](CONFIG.md) | Detailed configuration by planning stage | 30 min | Configuration managers |
| [BUILD.md](BUILD.md) | Building and deploying the site | 10 min | Technical staff |
developers |

### For Configuration Reference

| File | Purpose | Key Topics |
|------|---------|------------|
| [docs/_data/program.yml](/docs/_data/program.yml) | Schedule definition | Times, sessions, papers, duration inference |
| [docs/_data/keynotes.yml](/docs/_data/keynotes.yml) | Speaker information | Names, affiliations, photos, bios |
| [docs/_data/papers.yml](/docs/_data/papers.yml) | Accepted papers | Paper numbers, authors, titles, abstracts |
| [docs/_data/committees.yml](/docs/_data/committees.yml) | Committee members | Chairs, roles, affiliations |

---

## Documentation by Planning Stage

### Stage 1: Initial Setup (9-8 months before)
- **Read:** [CONFIG.md - Stage 1](CONFIG.md#stage-1-initial-setup)
- **Configure:** `conference.yml`, `dates.yml`, `venue.yml`, `program.yml`
- **Reference:** See CONFIG.md examples for each file
- **Time Required:** 2-3 hours

### Stage 2: Build-out (7-4 months before)
- **Read:** [CONFIG.md - Stage 2](CONFIG.md#stage-2-build-out)
- **Add:** Keynote details, committees, travel info, registration details
- **Time Required:** 3-4 hours

### Stage 3: Maturation (3-1 months before)
- **Read:** [CONFIG.md - Stage 3](CONFIG.md#stage-3-maturation)
- **Complete:** Papers list, session assignments, sponsors
- **Time Required:** 2-3 hours

### Stage 4: Launch (Final weeks)
- **Read:** [CONFIG.md - Stage 4](CONFIG.md#stage-4-launch)
- **Finalize:** All details, enable all sections
- **Deployment:** Follow [BUILD.md](BUILD.md)
- **Time Required:** 1-2 hours

---

## Troubleshooting Guide

### Build Issues

**Problem:** `bundle exec jekyll build` fails  
**Solution:** See [BUILD.md - Troubleshooting](BUILD.md#troubleshooting)

**Problem:** Generator error "Cannot infer end time"  
**Solution:** See [QUICKSTART.md - Troubleshooting](/QUICKSTART.md#troubleshooting)

### Configuration Questions

**Problem:** Not sure when to set up speakers  
**Solution:** See [CONFIG.md - Stage 2](CONFIG.md#stage-2-build-out)

**Problem:** How to show/hide sections  
**Solution:** See [CONFIG.md - Configuration Reference](CONFIG.md#configuration-reference)

---

## Key Commands Reference

```bash
# Update configuration
# Edit files in docs/_data/*.yml

# Generate schedule from configuration
bundle exec ruby scripts/generate_outline_grid.rb

# Build site locally
bundle exec jekyll build --source docs --destination docs/_site

# Preview with live reload
bundle exec jekyll serve --source docs --destination docs/_site --livereload

# Check for issues
bundle exec jekyll build --source docs --destination docs/_site --trace
```

---

## Configuration File Quick Reference

| File | Controls | Edit When |
|------|----------|-----------|
| `conference.yml` | Conference name, year, leadership | Stage 1 |
| `dates.yml` | Key dates (CFP, conference, registration) | Stage 1-2 |
| `venue.yml` | Location, timezone, travel info | Stage 1-2 |
| `keynotes.yml` | Speaker names, bios, photos, talks | Stage 2-3 |
| `program.yml` | Schedule, sessions, papers assignments | Stage 1-3 |
| `papers.yml` | Paper list, authors, abstracts | Stage 3 |
| `committees.yml` | Committee members and roles | Stage 2-3 |
| `cfp.yml` | Call for papers text and link | Stage 1-2 |
| `registration.yml` | Pricing, deadlines, registration link | Stage 2-3 |
| `sponsors.yml` | Sponsor logos and links | Stage 3 |
| `travel.yml` | Travel and accommodation info | Stage 2 |
| `site.yml` | Site-wide settings and toggles | As needed |

---

## Getting Help

### Understanding the Configuration

1. Open the relevant `docs/_data/*.yml` file
2. Read the comment header at the top
3. Check [CONFIG.md](CONFIG.md) for examples

### Troubleshooting Errors

1. Run generator: `bundle exec ruby scripts/validate_and_generate.rb`
2. Check error message (it's very descriptive!)
3. Find the issue in the suggested file and line
4. Consult [QUICKSTART.md - Troubleshooting](/QUICKSTART.md#troubleshooting)

### Planning Timeline

1. Determine which stage you're in
2. Open [CONFIG.md](CONFIG.md) to that stage
3. Follow the checklist
4. Reference the YAML examples provided

### Design Questions

1. Check [RECOMMENDATIONS.md](RECOMMENDATIONS.md) for planned features
2. Open an issue if you have suggestions

---

## Document Statistics

| Document | Size | Lines | Type |
|----------|------|-------|------|
| README.md | 7.0 KB | 350 | Markdown |
| QUICKSTART.md | 4.7 KB | 220 | Markdown |
| CONFIG.md | 22 KB | 900 | Markdown |
| BUILD.md | 1.6 KB | 80 | Markdown |

**Total Documentation:** ~70 KB, ~3,200 lines

---

## Version Information

- **Documentation Version:** 1.0
- **Repository:** opodis-web-template (Jekyll-based)
- **Last Updated:** January 8, 2026
- **Validated Against:** OPODIS 2022, 2023, 2025 instances

---

## Quick Links

- 📖 [Main README](README.md)
- 🚀 [Quick Start](QUICKSTART.md)
- ⚙️ [Configuration Guide](CONFIG.md)
- 🔨 [Build Instructions](BUILD.md)


---

Created: January 8, 2026  
Purpose: Help users navigate all documentation  
Status: Ready for use
