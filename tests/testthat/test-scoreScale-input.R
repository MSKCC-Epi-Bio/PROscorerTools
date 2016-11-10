context("scoreScale input testing")

# Add informal tests in "20160823 - Testing scoreScale.R"
#      and in "20161011 - Other Tests.R" (maybe better for PROscorer)

test_that("scoreScale: Errors if not given a df", {
  expect_error(scoreScale(df = as.matrix(mtcars), type = "sum"), "must be a data frame")
  expect_error(scoreScale(df = 1:10, type = "sum"), "must be a data frame")
  expect_error(scoreScale(df = "a", type = "sum"), "must be a data frame")
  expect_silent(scoreScale(df = mtcars, type = "sum"))
})


test_that("scoreScale: Output is a df", {
  expect_true(is.data.frame(scoreScale(df = mtcars, type = "sum")))
  expect_true(is.data.frame(scoreScale(df = mtcars, type = "sum", keepNvalid = TRUE)))
})
