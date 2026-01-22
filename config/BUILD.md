# How to build and test this site

## Preliminaries

### Install Ruby with rbenv (one-time)

```bash
brew install rbenv
rbenv init - zsh >> ~/.zshrc
source ~/.zshrc
rbenv install 3.3.4
rbenv local 3.3.4
gem install bundler
bundle install
```

### Project prep after cloning / pulling

```bash
rbenv install 3.3.4
rbenv local 3.3.4
bundle install
```

If you change `docs/_data/program.yml`, regenerate the outline grid:
```bash
bundle exec ruby scripts/validate_and_generate.rb
```
Re-run the generator after any change in `docs/_data/program.yml` (times, types, durations, labels, etc.) before building or deploying. End times resolve in order: time range → explicit `duration` → computed (papers/keynotes) → next item's start, and the generator validates overlaps/gaps. Diagnostics include paper references (404/duplicates), keynote/speaker placeholders, and time format issues. Session chairs are treated as free-form text.


## Build

### Version control tips

- Commit: `Gemfile`, `Gemfile.lock`, `.ruby-version` (pins runtime and dependencies for deterministic builds)
- Do NOT commit: `docs/_site/`, `.bundle/`, `vendor/`, `.jekyll-cache/`, `.sass-cache/` (already ignored)
- Generated but committed: `docs/_data/outline_grid.json` (the site reads this JSON; GitHub Pages will not run the Ruby generator)

### Build locally

```bash
# build the site to docs/_site
bundle exec jekyll build --source docs --destination docs/_site
# serve the site locally for preview
bundle exec jekyll serve --source docs --destination docs/_site --livereload --host 0.0.0.0 --port 4000
# then browse http://localhost:4000
```


## Deploy

### Via GitHub Pages

1) Configure GitHub Pages to serve from branch `main`, path `/docs`.
2) If program data changed, regenerate and build:
```bash
bundle exec ruby scripts/generate_outline_grid.rb
bundle exec jekyll build --source docs --destination docs/_site
```
3) Commit source changes plus updated `docs/_data/outline_grid.json` (and `docs/_site` if you publish the built site).
4) Push to `main`; GitHub Pages serves from `docs/`.

### On another server

```bash
bundle exec ruby scripts/generate_outline_grid.rb
bundle exec jekyll build --source docs --destination docs/_site
rsync -av docs/_site/ user@server:/path/to/webroot/
```
