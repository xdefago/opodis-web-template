# How to build and test this site

## Preliminaries

### Install jekyll locally


## Build


### Build locally

To build locally, you need to install Jekyll before.
```bash
# build the site to docs/_site
bundle exec jekyll build --source docs --destination docs/_site 
# serve the site locally for preview
bundle exec jekyll serve --source docs --destination docs/_site --livereload --host 0.0.0.0 --port 4000
# wait, then access at http://localhost:4000 
```


## Deploy

### Via github pages

Initially, configure the github repository to enable github pages on branch `main` with path `/docs`.

To deploy, commit your changes to main, and then push them to origin (to github).

### On another server

* build the site locally with jekyll
* copy all files under `docs/_site/` to the web server.