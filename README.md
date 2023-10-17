
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/PROscorerTools)](https://cran.r-project.org/package=PROscorerTools)

[![Coverage
Status](https://img.shields.io/codecov/c/github/MSKCC-Epi-Bio/PROscorerTools/master.svg)](https://app.codecov.io/github/MSKCC-Epi-Bio/PROscorerTools?branch=master)

# PROscorerTools

## Overview

PROscorerTools provides tools to score patient-reported outcome (PRO)
measures and other quality of life (QoL) and psychometric instruments.
PROscorerTools also provides the building blocks of the functions in the
PROscorer package.

PROscorerTools contains several “helper” functions, each of which
performs a specific task that is common when scoring PRO-like
instruments (e.g., reverse coding items). But most users will find that
the `scoreScale()` function alone can address their scoring needs.

## The `scoreScale()` Function

The workhorse function in PROscorerTools is the `scoreScale()` function.
Its basic job is to take a data frame containing responses to some
items, and output a single score for those items.

The `scoreScale()` function has simple, flexible arguments that enable
it to handle nearly all scoring situations.

**Features:**

-   **Reverse Coding:** Before calculating a score, `scoreScale()` can
    reverse code all of the items, only some specific items, or none of
    the items (no reverse coding is the default).

-   **Different Types of Scores:** Some instruments need to be scored by
    summing item responses, others by taking the mean of item responses,
    and others by re-scaling the sum or mean scores to range from 0
    to 100. All 3 of these score types are available in the
    `scoreScale()` function.

-   **Calculation of Scores with Missing Items:** For most instruments,
    valid scores can be obtained despite a certain number of missing
    item responses. For example, on the EORTC QLQ-C30, a score can be
    calculated as long as at least 50% of items on a given scale are
    non-missing. The `scoreScale()` function allows the user to specify
    the proportion of missing items that is allowed, and the score is
    prorated to be comparable to scores with no missing items. If a
    respondent has more than the allowed proportion of missing items,
    then that respondent will be assigned a missing score (e.g., `NA`).

-   **Scoring Instruments with Multiple Scores:** More complex
    instruments that yield more than a single score can be scored by
    combining multiple calls to the `scoreScale()` function. In fact,
    most of the functions in the **PROscorer** package call
    `scoreScale()` multiple times.

## Installation and Basic Usage

Install the stable version from CRAN (recommended):

``` r
install.packages("PROscorerTools")
```

If you want to contribute to the development of the PROscorerTools or
PROscorer packages, then you can install the development version from
GitHub (generally NOT recommended):

``` r
devtools::install_github("MSKCC-Epi-Bio/PROscorerTools")
```

Load PROscorerTools in your R workspace:

``` r
library(PROscorerTools)
```

As an example, we will use the `makeFakeData()` function to make a data
frame of responses to 6 fake items from 20 imaginary respondents. The
created data set (named “dat”) has an “id” variable, plus responses to 6
items (named “q1”, “q2”, etc.) from 20 imaginary respondents. There are
also missing responses (“NA”) scattered throughout.

``` r
dat <- makeFakeData(n = 20, nitems = 6, values = 0:4, id = TRUE)
```

Below we use the `scoreScale` function to score the fake responses in
“dat”. We use the `items` argument to tell `scoreScale` which variables
are the items we want to score. We will score the items by summing the
responses (`type = "sum"`). We will save the scores from the fake
questionnaire in a data frame named “dat_scored”.

``` r
dat_scored <- scoreScale(df = dat, items = 2:7, type = "sum")
dat_scored
```

By default, `scoreScale` will score the items for a given respondent as
long as the respondent is missing no more than 50% of the items. This
can be changed with the `okmiss` argument. Above, `okmiss = 0.50` by
default, so a respondent could be missing 3 of the 6 items and still be
assigned a score (if missing 4 or more items, they were assigned a score
of `NA`). Below, we again score the items, but this time we allow less
than half of the items to be missing to be scored (`okmiss = 0.49`).

``` r
dat_scored <- scoreScale(df = dat, items = 2:7, type = "sum", okmiss = 0.49)
dat_scored
```

For more information on the `scoreScale` function, you can access its
“help” page by typing `?scoreScale` into R.

## Resources for More Information

-   You can access the “help” page for “PROscorerTools” package by
    typing `?PROscorerTools` into R.

-   Check out the [PROscorerTools
    vignettes](https://CRAN.R-project.org/package=PROscorerTools).

-   For examples on how to use the `scoreScale` function within a more
    complex scoring function, check out the source code for some of the
    functions in the **PROscorer** package.
