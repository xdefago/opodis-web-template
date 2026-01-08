# OPODIS Conference Template

**Create a new OPODIS conference website in 15 minutes.** This template provides everything you need to set up a professional conference website with schedule management, paper listings, and registration.

## For New Conference Organizers

### 1. Create Your Repository

Click the green **"Use this template"** button at the top of this page:
1. Select **"Create a new repository"**
2. Name it: `opodis-YYYY` (e.g., `opodis-2025`)
3. Choose **Public** visibility
4. Click **"Create repository"**

### 2. Quick Setup

```bash
# Clone your new repository
git clone https://github.com/YOUR_USERNAME/opodis-YYYY.git
cd opodis-YYYY

# Install Ruby 3.1.4 (using rbenv)
brew install rbenv ruby-build
rbenv install 3.1.4
rbenv local 3.1.4

# Install dependencies
gem install bundler
bundle install
```

### 3. Configure Your Conference

Edit files in `docs/_data/` with your conference details:

**Essential files** (update immediately):
- `conference.yml` - Year, city, dates, contacts
- `dates.yml` - Submission and registration deadlines
- `venue.yml` - Conference location

**As planning progresses**:
- `keynotes.yml` - Invited speakers (use "TBA" initially)
- `program.yml` - Schedule and sessions
- `committees.yml` - Organizing and program committees
- `papers.yml` - Accepted papers (after review)
- `registration.yml` - Fees and deadlines
- `cfp.yml` - Call for papers text
- `travel.yml` - Travel information
- `sponsors.yml` - Sponsors and supporters

### 4. Build and Preview

```bash
# Generate schedule grid (run after editing program.yml)
bundle exec ruby scripts/generate_outline_grid.rb

# Preview locally with live reload
bundle exec jekyll serve --source docs --destination docs/_site --livereload
```

Visit `http://localhost:4000` to see your site.

### 5. Deploy to GitHub Pages

1. Go to **Settings** → **Pages**
2. Set source to **main** branch, `/docs` folder
3. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Configure OPODIS YYYY"
   git push origin main
   ```
4. Your site will be live at: `https://YOUR_USERNAME.github.io/opodis-YYYY/`

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)** – Guided 15-minute setup workflow
- **[config/CONFIG.md](config/CONFIG.md)** – Comprehensive configuration reference
- **[config/BUILD.md](config/BUILD.md)** – Build system and deployment guide
- **[config/CHANGES.md](config/CHANGES.md)** – Recent template improvements

## Reference Example

See the `sample-opodis23` branch for a complete working example (OPODIS 2023):

```bash
git checkout sample-opodis23
```

## Key Features

- **Configuration-driven**: All content in YAML files
- **Automated schedule**: Smart time calculation with validation
- **Progressive disclosure**: Use "TBD" for incomplete information
- **Responsive design**: Bootstrap-based mobile-friendly layout
- **Draft support**: TBA badges for unconfirmed speakers/content

## Directory Structure

```
docs/_data/          # Edit these YAML files for your conference
  ├── conference.yml  # Core info (year, city, dates)
  ├── dates.yml       # Important deadlines
  ├── program.yml     # Schedule definition
  ├── papers.yml      # Accepted papers
  └── ...            # Other configuration

docs/_includes/     # Reusable template components
docs/img/           # Add your logos and photos here
scripts/            # Helper scripts (schedule generator)
```

## Support

- **Issues**: [Report bugs or request features](../../issues)
- **Questions**: See [config/CONFIG.md](config/CONFIG.md)
- **OPODIS**: Visit [opodis.net](https://www.opodis.net)

---

**Ready to start?** Follow the 5-step guide above or read [QUICKSTART.md](QUICKSTART.md) for detailed instructions.

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
2. For schedule changes, run: `bundle exec ruby scripts/validate_and_generate.rb`
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
