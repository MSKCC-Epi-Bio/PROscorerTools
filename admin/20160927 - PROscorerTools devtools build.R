### 20160927 - PROscorerTools devtools build.R


library(devtools)
options(devtools.desc.author =
          person("Ray", "Baser", email = "ray.stats@gmail.com",
                 role = c("aut", "cre")),
        devtools.desc.license = "GPL-3",
        devtools.name = "Ray Baser")

.Options[grep('devtools', names(.Options))]


## After all functions are documented and built, add infrastructure below


## Initialize git and GitHub repo
use_github(pkg = "PROscorerTools")

## Make NEWS
use_news_md(pkg = "PROscorerTools")



## Make README
## Use _rmd for rich intermingling of text and code
use_readme_rmd(pkg = "PROscorerTools")
use_readme_md(pkg = "PROscorerTools")


## Check that all examples run OK
run_examples(pkg = "PROscorerTools")

## Create vignette
use_vignette(name = , pkg = "PROscorerTools")


## Run spell check on DESCRIPTION and manual pages
spell_check(pkg = "PROscorerTools", ignore = character())

## ? Necessary ?
build_vignettes()
