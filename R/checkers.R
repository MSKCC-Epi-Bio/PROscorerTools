#' @title Argument Checkers for Custom Scoring Functions
#'
#' @description These functions are designed to used within custom scoring
#' functions to help check the arguments passed to those functions. Typically,
#' these argument checkers will be used within the body of a scoring function
#' before calling the \code{\link{scoreScale}} function to handle the bulk of
#' the work.  See Details.
#'
#' \itemize{
#'   \item \code{chk_nitems} checks if \code{dfItems} contains the correct
#'     number of items (\code{nitems}), and \code{chkstop_nitems} returns an
#'     error message if this condition is not met.
#'   \item \code{chk_values} checks if all of the item values in \code{dfItems}
#'     are in the set of possible values given to the \code{values} argument,
#'     and \code{chkstop_values} returns an error message if this condition is
#'     not met.
#' }
#'
#'
#' @details Functions with prefix \code{chk_} simply check whether their
#'   argument values meet a condition and return \code{TRUE} or \code{FALSE}.
#'   Functions with the prefix \code{chkstop_} check the arguments and, if
#'   \code{FALSE}, stop execution and display an error message to help the user
#'   pinpoint the problem.
#'
#'   The \code{\link{scoreScale}} function is a general, all-purpose tool that
#'   can be used to score a scale regardless of the number or values of items on
#'   the scale.  Because of this, however, it does not check that the user has
#'   given it the correct number of items, and it does not check that those item
#'   values are all within the range possible for that scale.  Therefore,
#'   whenever \code{\link{scoreScale}} is used to write a function to score a
#'   specific instrument (presumably with a known number of items and item
#'   values), the programmer should run some additional checks on the arguments
#'   that are not already built-in to \code{\link{scoreScale}}.
#'
#'
#' @param dfItems A data frame with only the items to be scored.
#'
#' @param nitems The number of items on the scale to be scored.
#'
#'
#' @return Functions with prefix \code{chk_} return \code{TRUE} if the arguments
#'   \strong{pass} the argument checks, or \code{FALSE} if the arguments
#'   \strong{fail} the checks. Functions with the prefix \code{chkstop_} print
#'   an error message and stop the execution of the function in which they are
#'   embedded.
#'
#' @examples
#' itemBad <- c(0, 1, 2, 3, 10)
#' itemGood <- c(0, 1, 2, 3, 0)
#' dfBad <- data.frame(itemBad, itemGood)
#' dfGood <- data.frame(itemGood, itemGood)
#' chk_nitems(dfBad, 1)
#' chk_nitems(dfGood, 2)
#' chk_values(dfBad, 0:3)
#' chk_values(dfGood, 0:3)
#'
#' @export
#' @name checkers
chk_nitems <- function(dfItems, nitems) {
  ncol(dfItems) == nitems
}

#' @export
#' @rdname checkers
chkstop_nitems <- function(dfItems, nitems) {
  if(!chk_nitems(dfItems = dfItems, nitems = nitems)) {
    stop("There are either too many or too few items in your data frame.")
  }
}


## Returns FALSE if not all dfItems in values

#' @param values A vector of all of the possible values that the items can take.
#' @export
#' @rdname checkers
chk_values <- function(dfItems, values) {
  chk_itemvalues <- function(item, values) {
    all(item %in% values)
  }
  all(unlist(lapply(dfItems, chk_itemvalues, values)))
}

#' @export
#' @rdname checkers
chkstop_values <- function(dfItems, values) {
  if(!chk_values(dfItems = dfItems, values = values)) {
    stop("At least one of your items has a value that is not allowed.")
  }
}
