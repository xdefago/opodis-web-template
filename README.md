# OPODIS Website Template

A modular, configuration-driven Jekyll website template for the **OPODIS** (Principles of Distributed Systems) conference, designed for easy adaptation to multiple instances.

## Quick Links

For **setting up a new OPODIS instance**, start here:

- 🚀 **[QUICKSTART.md](QUICKSTART.md)** – 15-minute setup guide
- ⚙️ **[CONFIG.md](config/CONFIG.md)** – Detailed configuration by planning stage
- 🔨 **[BUILD.md](config/BUILD.md)** – Building and deployment instructions

## About This Template

This repository was refactored from the **OPODIS 2023** website to be **reusable across multiple conference years**. It has been validated against instances from 2022, 2023, and 2025 with a **configurability analysis** in [tmp/analysis/similarity.md](tmp/analysis/similarity.md).

### Key Features

- **Configuration-driven**: All content in YAML files (`docs/_data/*.yml`)
- **Modular design**: Liquid includes for reusable components
- **Automated schedule generation**: `scripts/generate_outline_grid.rb` converts program config to presentation-ready JSON
- **Progressive disclosure**: Supports TBD/incomplete information at early planning stages
- **Validation**: Generator validates consistency (times, papers, chairs)
- **Style**: Bootstrap-based responsive design

### Directory Structure

```
docs/
├── _data/                    # Configuration (YAML)
│   ├── conference.yml        # Year, location, leadership
│   ├── dates.yml             # Important dates
│   ├── venue.yml             # Venue and location info
│   ├── keynotes.yml          # Keynote speakers
│   ├── program.yml           # Schedule definition
│   ├── papers.yml            # Accepted papers
│   ├── committees.yml        # Organizational committees
│   ├── cfp.yml               # Call for papers
│   ├── registration.yml      # Registration info
│   ├── sponsors.yml          # Sponsors
│   ├── travel.yml            # Travel/accommodation
│   └── outline_grid.json     # Generated (do not edit)
│
├── _includes/               # Template partials
│   └── sections/             # Reusable page sections
│       ├── program_outline.html
│       ├── program_schedule.html
│       └── ...
│
└── index.html               # Home page

scripts/
└── generate_outline_grid.rb # Schedule generator
```

## Getting Started

### For a New OPODIS Instance

1. **Read [QUICKSTART.md](QUICKSTART.md)** (5 minutes)
2. **Update key files** in `docs/_data/`:
   - `conference.yml` – year, location
   - `dates.yml` – important dates
   - `program.yml` – schedule skeleton
3. **Run generator**: `bundle exec ruby scripts/generate_outline_grid.rb`
4. **Build site**: `bundle exec jekyll build --source docs`

### For Detailed Configuration Guidance

Follow **[CONFIG.md](config/CONFIG.md)** for a **stage-by-stage approach**:

- **Stage 1** (9-8 months before): Initial setup with skeleton schedule
- **Stage 2** (7-4 months before): Details, committees, travel info
- **Stage 3** (3-1 months before): Papers, session assignments
- **Stage 4** (final weeks): Launch and updates

### For Build and Deployment

See **[BUILD.md](config/BUILD.md)** for:
- Installation and dependencies
- Local development with live reload
- Production deployment
- Troubleshooting

## Schedule Generation

The `generate_outline_grid.rb` script:
- Reads `docs/_data/program.yml`
- Infers end times from durations or next items
- Validates consistency (no overlaps, all papers fit)
- Generates `docs/_data/outline_grid.json`
- Provides helpful error messages

**Important:** Run after any `program.yml` changes:

```bash
bundle exec ruby scripts/generate_outline_grid.rb
```

## Configuration Features

### Supports Multiple Planning Stages

- ✅ TBD/incomplete information (e.g., "To be announced")
- ✅ Progressive disclosure (show/hide sections as info becomes available)
- ✅ Optional fields (photos, abstracts can be added later)
- ✅ Validation (catches schedule conflicts and inconsistencies)

### Error Handling

Generator provides clear error messages for:
- Missing start times
- Overlapping sessions
- Papers exceeding session duration
- Inconsistent durations

Example error output (Rust compiler style):

```
error[duration-overlap]: duration exceeds start of next item
   --> Fri Dec 8 • item 8 • closing
    | start: 17:50
    | note: Ends at 18:00 but next item starts at 17:50.
error[duration-overlap]
```

## Configurability Analysis

The **[tmp/analysis/similarity.md](tmp/analysis/similarity.md)** report compares OPODIS 2022, 2023, and 2025 instances and confirms:

- ✅ All three schedules fit the current configuration model
- ✅ Core information architecture is stable
- ✅ Configuration-driven approach is sound
- ✅ Recommended improvements are additive (no breaking changes)

### Key Findings

| Aspect | Consistency | Volatility |
|--------|-------------|-----------|
| **Section structure** | Very stable | None |
| **Schedule format** | Consistent | Times/papers change |
| **Speaker information** | Evolves | Name→Bio→Photo |
| **Registration info** | Standard | Prices/deadlines change |

---

## Documentation Files

| File | Purpose | Audience |
|------|---------|----------|
| [QUICKSTART.md](QUICKSTART.md) | 15-minute setup | New instance admins |
| [CONFIG.md](config/CONFIG.md) | Detailed configuration | Planning/implementation |
| [BUILD.md](config/BUILD.md) | Build and deployment | DevOps/technical staff |
| [tmp/analysis/similarity.md](tmp/analysis/similarity.md) | Comparative analysis | Decision makers, developers |

---

## Requirements

- **Ruby** 3.0 or higher
- **Bundler** for dependency management
- **Jekyll** 4.0+ (installed via Bundler)

See [BUILD.md](config/BUILD.md) for detailed setup instructions.

---

## Development

### Local Development with Live Reload

```bash
bundle exec jekyll serve --source docs --destination docs/_site --livereload
```

Then visit `http://localhost:4000`.

### Making Changes

1. Edit YAML files in `docs/_data/`
2. For schedule changes, run: `bundle exec ruby scripts/generate_outline_grid.rb`
3. Site rebuilds automatically (with live reload)

---

## Design Philosophy

This template balances **flexibility** and **consistency**:

- **Flexible configuration**: YAML files allow easy customization without code changes
- **Consistent structure**: Reusable Liquid includes and templates
- **Progressive validation**: Generator catches errors early
- **Graceful degradation**: Site renders with TBD/partial information

The template is designed for conference organizers, not developers.

---

## License

[Specify license if applicable]

---

## Support

- **Setup questions?** → See [QUICKSTART.md](QUICKSTART.md)
- **Configuration help?** → See [CONFIG.md](config/CONFIG.md)
- **Build issues?** → See [BUILD.md](config/BUILD.md)
- **Design analysis?** → See [tmp/analysis/similarity.md](tmp/analysis/similarity.md)

---

## Credits

Refactored from the OPODIS 2023 website (opodis23.example.com) into a reusable, modular template validated against 2022, 2023, and 2025 instances.
