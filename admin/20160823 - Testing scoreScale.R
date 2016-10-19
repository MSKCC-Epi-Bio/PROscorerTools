###  20160823 - Testing scoreScale.R

##  Goal is to systematically test each argument.
##  Eventually should build into formal TESTS using testthat package


#####  LIST OF TESTS TO IMPLEMENT:
## - Test that...
##   - error if df is a matrix
##   - error when okmiss is not length 1, numeric value between 0-1
##   - error if type is "pomp" or "100" and no minmax
##   - error if minmax is of wrong type
##   - error if minmax vs data mismatch (test various ways to fail, see chkstop_minmax)
##   - error if no minmax when revitems != FALSE
##   - error if item name given to items or revitems not in df
##   - scores when only df given are identical to when df + items given
##   - scores when revitems = FALSE are identical to 100-scores when revitems = TRUE
##   - revitems properly reverses items whether given numeric or character index
##   - error if revitems contains entry not in df and/or items (test for character and numeric input)
##   - keepNvalid returns score_N variable
##

#####  LIST OF MORE PRESSING TESTS TO EVALUATE NOW:
## - Test that...
##   - scores when only df given are identical to when df + items given
##   - scores when items is char are identical to when items is numeric
##   - revitems works when TRUE, FALSE, char, or num
##   - scores when revitems is char are identical to when items is numeric
##   - pomp scores when item range is 0:4 same as when 1:5
##
##   - scores when items is char are identical to when items is numeric
##   - error when okmiss is not length 1, numeric value between 0-1
##   - error if type is "pomp" or "100" and no minmax
##   - error if minmax is of wrong type
##   - error if minmax vs data mismatch (test various ways to fail, see chkstop_minmax)
##   - error if no minmax when revitems != FALSE
##   - error if item name given to items or revitems not in df
##   - scores when only df given are identical to when df + items given
##   - scores when revitems = FALSE are identical to 100-scores when revitems = TRUE
##   - revitems properly reverses items whether given numeric or character index
##   - error if revitems contains entry not in df and/or items (test for character and numeric input)

set.seed(20151021)
df1 <- makeFakeData(values=1:5)
set.seed(20151021)
df0 <- makeFakeData(values=0:4)

testdf <- makeFakeData(values=0:4)

makeItemNames("q",8)
## - TEST THAT all types work
scoreScale(df = df0, type = "sum")
scoreScale(df = df0, 1:8, type = "sum")
scoreScale(df = df0, items = makeItemNames("q",8),  type = "sum", revitems = TRUE,   m=c(0,4))
scoreScale(df = df0, type = "sum")
scoreScale(df = df0, type = "mean")
scoreScale(df = df0, type = "100", minmax = c(0,4))
scoreScale(df = df0, type = "pomp", minmax = c(0,4))
scoreScale(df = df0, minmax = c(0,10))


## - TEST THAT pomp scores when item range is 0:4 same as when 1:5
scoreScale(df = df0, minmax = c(0,4)) - scoreScale(df = df1, minmax = c(1,5))
scoreScale(df = df0, minmax = c(0,4), type = "100") - scoreScale(df = df1, minmax = c(1,5),  type = "100")

## - TEST THAT keepNvalid returns score_N variable
scoreScale(df = df0, minmax = c(0,4), keepNvalid = TRUE)

scoreScale(df = df0, type = "sum")
## Test items = NULL
scoreScale(df = df1,
           items = NULL,
           minmax = c(1,6),
           okmiss = .50,
           revitems = FALSE,
           type = "mean",
           scalename ="scoredScale",
           keepNvalid = FALSE)



## Test items = NULL
scoreScale(df = df1[1:8],
           # items = makeItemNames("q",8),
           # minmax = c(1,5),
           okmiss = .50,
           # revitems = c("q1", "q2", "q3"),
           revitems = F,
           # revitems = c(1,2,3),
           type = "100",
           scalename ="scoredScale",
           keepNvalid = T)


## Test items = NULL
scoreScale(df = testdf,
           items = NULL,
           minmax = c(0,4),
           okmiss = .50,
           revitems = FALSE,
           type = "sum",
           scalename ="scoredScale",
           keepNvalid = FALSE)




## Test items = NULL
scoreScale(df = testdf,
           items = NULL,
           minmax = c(0,4),
           okmiss = .50,
           revitems = FALSE,
           type = "mean",
           scalename ="scoredScale",
           keepNvalid = FALSE)


## testthat revitems = TRUE works
scoreScale(df = testdf,
           items = NULL,
           minmax = c(0,4),
           okmiss = 10.564,
           revitems = T,
           type = "100",
           scalename ="scoredScale",
           keepNvalid = FALSE)


## testthat items out of minmax range throws error
scoreScale(df = testdf,
           items = NULL,
           minmax = c(1,4),
           okmiss = .50,
           revitems = FALSE,
           type = "100",
           scalename ="scoredScale",
           keepNvalid = FALSE)

