#' @title msgWrap
#'
#' @description Helps format line-wrapping of long error and warning messages
#'
#' @details
#' This is just a shorter version of the following that makes my function code
#' easier to read:
#' \code{paste(strwrap(msg, exdent = 2, width = 70), collapse = "\n")}
#' It seems to work fine when embedded in \code{warning} or \code{stop}, but may
#' give unexpected output if called alone.
#'
#' @param msg A quoted message.
#'
#' @return It returns \code{msg} formatted wrapped nicely for the console.
#'
#' @export
#'
#' @examples
#' txt <- "If you use 'itemsrev' to indicate items that
#'         must be reverse-coded before scoring,
#'         you must provide a valid numeric range to 'minmax'.
#'         For example, if your lowest possible item response
#'         is 0 and your highest possible response is 4,
#'         you would use 'minmax = c(0, 4)'."
#'
#' warning(msgWrap(msg = txt))
msgWrap <- function(msg) {
  paste(strwrap(msg, exdent = 2, width = 70), collapse = "\n")
}


#' @title Determine the number (or proportion) of missing (or non-missing) items
#'   for each respondent
#'
#' @description This is a handy helper function that can be used in PRO scoring
#'   functions to determine the number (or proportion) of item responses that
#'   are missing (or valid) for each row in a data frame of items.  This is used
#'   by \code{\link{scoreScale}} to help determine if a respondent has answered enough
#'   items to be assigned a prorated scale score.
#'
#' @param dfItems A data frame containing only the items of interest.
#' @param what One of four quoted names indicating the value you want for each
#'   respondent (row) in \code{dfItems}: (1) \code{"pmiss"} (the default), for the
#'   proportion of items that are missing; (2) \code{"nmiss"}, for the number of items
#'   that are missing; (3) \code{"pvalid"}, for the proportion of items that are valid,
#'   non-missing; and (4) \code{"nvalid"} for the number of items that are valid,
#'   non-missing.
#'
#' @return A vector of length \code{nrow(dfItems)} that contains the quantity
#'   requested in \code{what} for each row of \code{dfItems}.
#'
#' @export
#'
#' @examples
#' set.seed(8675309)
#' #  Make data frame with 10 respondents, 10 items, and approx 30% missing data
#' (myItems <- makeFakeData(n = 10, nitems = 10, propmiss = .30))
#' #  The default is to return "pmiss", the proportion missing for each row.
#' missTally(myItems)
#' missTally(myItems, "pvalid")
#' missTally(myItems, "nmiss")
#' missTally(myItems, "nvalid")
missTally <- function(dfItems, what = c("pmiss", "nmiss", "pvalid", "nvalid")) {
  what = match.arg(what)

  valid_ind <- as.data.frame(lapply(dfItems, function(x) as.numeric(!is.na(x))))

  nitems <- ncol(valid_ind)
  nvalid <- rowSums(valid_ind)
#  pvalid <- 100*(nvalid/nitems)
  pvalid <- nvalid/nitems
  nmiss <- nitems - nvalid
#  pmiss <- 100 - pvalid
  pmiss <- 1 - pvalid

  if (what == "nvalid") {
    return(nvalid)
  }
  if (what == "pvalid") {
    return(pvalid)
  }
  if (what == "nmiss") {
    return(nmiss)
  }
  if (what == "pmiss") {
    return(pmiss)
  }
}

#' @title Reverse code an item or score.
#'
#' @description Given an item (or score) and the minimum and maximum possible
#'   values that the item can take, this helper function reverse codes the item.
#'   For example, it turns \code{c(0, 1, 2, 3, 4)} into \code{c(4, 3, 2, 1, 0)}.
#'
#' @details The user must supply the \emph{theoretically possible} minimum and
#'   maximum values to this function (using \code{mn} and \code{mx},
#'   respectively).  Some similar functions do not require users to provide the
#'   minumum and maximum values.  Instead, those functions calculate the
#'   minimum and maximum values from the data.  However, in cases where not all
#'   of the possible item values are contained in the data, this would
#'   incorrectly reverse score the items.  In the interest of scoring accuracy,
#'   these arguments are required for \code{revcode}.
#'
#' @param x A single item (or score) to reverse code.
#' @param mn The minimum possible value that \code{x} can take.
#' @param mx The maximum possible value that \code{x} can take.
#'
#' @return A vector the same length as \code{x}, but with values reverse coded.
#'
#' @export
#'
#' @examples
#' item1 <- c(0, 1, 2, 3, 4)
#' revcode(item1, 0, 4)
#' item2 <- c(0, 1, 2, 3, 0)
#' revcode(item2, 0, 4)
revcode <- function(x, mn, mx)  {
  if (min(x, na.rm = TRUE) < mn) {
    stop("x contains at least 1 value smaller than the 'mn' you provided")
  }
  if (max(x, na.rm = TRUE) > mx) {
    stop("x contains at least 1 value larger than the 'mx' you provided")
  }
  xrev <- (mn + mx) - x
  return(xrev)
}






#' @title Quickly create a vector of sequentially numbered item names
#'
#' @description Takes a prefix (e.g., "Q") and the number of items you want
#'   (e.g., 3), and returns a vector of item names (e.g., c("Q1", "Q2", "Q3")).
#'
#' @param prefix A quoted prefix that will precede the number in the item name
#'   (e.g., the "Q" in "Q1").
#'
#' @param nitems The number of items
#'
#' @return A character vector of sequentially numbered item names.
#'
#' @export
#'
#' @examples
#' makeItemNames("q", 3)
#' itemNames <- makeItemNames("item", 7)
#' itemNames
makeItemNames <- function(prefix, nitems) {
  paste0(prefix, 1:nitems)
}
