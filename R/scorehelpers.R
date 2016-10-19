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
#' #  Make data frame with 10 respondents, 10 items, and approx 20% missing data
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
#'   minumum and maximum values, and, instead, those functions calculate the
#'   minimum and maximum values from the data.  However, in cases where not all
#'   of the possible item values are contained in the data, this would
#'   incorrectly reverse score the items.  In the interest of scoring accuracy,
#'   these arguments are required for \code{revcode}.
#'
#' @param x A single item (or score) to reverse code.
#' @param mn The minimum possible value that \code{x} can take.
#' @param mx The maximum possible value that \code{x} can take.
#'
#' @return A vector of length \code{nrow(dfItems)} that contains the quantity
#'   requested in \code{what} for each row of dfItems.
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



#' @title Change the range of an item or score
#'
#' @description
#' \itemize{
#'   \item \code{rerange} linearly rescales a numeric variable to have new
#'     minimum and maximum values of the users choosing.
#'   \item \code{rerange100} is a simplified version of \code{rerange} that
#'     rescales a variable to range from 0 to 100.
#' }
#'
#' @details The \code{rerange} function can rerange and reverse code a variable
#'   all at once. If \code{rev = TRUE}, \code{score} will be reversed using
#'   \code{\link{revcode}} after it is re-ranged.  The same could be
#'   accomplished by keeping \code{rev = FALSE} and reversing the order of the
#'   range given to \code{new}.  For example, the following two calls to
#'   \code{rerange} will return the same values:
#' \itemize{
#'   \item \code{rerange(score, old = c(0,10), new = c(0, 100), rev = TRUE)}
#'   \item \code{rerange(score, old = c(0,10), new = c(100, 0), rev = FALSE)}
#' }
#'
#'  The \code{rerange100} function is a short-cut for \code{rerange} with the
#'  arguments set to the values typically used when scoring a PRO measure.
#'  Specifically, \code{rerange100} is defined as:
#' \itemize{
#'   \item \code{rerange(score, old = c(mn, mx), new = c(0, 100), rev = FALSE)}
#' }
#'
#'  These functions can produce verbose warning messages.  If you are using this
#'  function within another function, you can suppress these messages by
#'  wrapping your call to \code{rerange} in \code{suppressWarnings()}.
#'
#' @param score The variable to be re-ranged.
#' @param old A numeric vector of length 2 indicating the old range (e.g.,
#'   \code{c(min, max)} \code{score}.  If omitted, the old range will be
#'   calculated from \code{score}.  Omitting \code{old} is \strong{NOT}
#'   recommended since it is possible that not all of the theoretically possible
#'   values of \code{score} will be in \code{score}.
#' @param new A numeric vector of length 2 indicating the new range you want for
#'   \code{score}.  The default value is \code{c(0, 100)}.
#' @param rev Logical, if \code{TRUE} \code{score} will will not only be
#'   re-ranged, but it will also be reversed (see Details for more information).
#'   The default is \code{FALSE}.
#'
#' @return A re-ranged vector.
#' @export
#'
#' @examples
#' qol_score <- c(0:4)
#'
#' # Default is to rerange to c(0, 100)
#' rerange(qol_score, old = c(0, 4))
#' # Below gives same result as above
#' rerange100(qol_score, 0, 4)
#'
#' # These two lines are different ways to rerange and reverse code at same time
#' rerange(qol_score, old = c(0, 4), new = c(0, 100), rev = TRUE)
#' rerange(qol_score, old = c(0, 4), new = c(100, 0))
rerange <- function(score,
                    old = range(score,  na.rm = TRUE),
                    new = c(0, 100),
                    rev = FALSE) {
  ## Check that
  if (old[1] > min(score, na.rm = TRUE)) {
    stop("score contains at least 1 value smaller than the low end
         of the 'old' range you provided")
  }
  if (old[2] < max(score, na.rm = TRUE)) {
    stop("score contains at least 1 value greater than the upper end
         of the 'old' range you provided")
  }
  if ( old[1] < min(score, na.rm = TRUE) ) {
    warning(paste(strwrap(
      "The lower bound of the 'old' range you provided is smaller than the
      minimum value observed in the data you provided to 'score'.
      Please double-check that you gave the correct range to the 'old' argument
      (it should be the range of values your data can theoretically take),
      and that the values of 'score' are coded correctly.  If both are correct,
      you can ignore this warning.", exdent = 2),
      collapse = "\n"))
  }
  if (old[2] > max(score, na.rm = TRUE) ) {
    warning(paste(strwrap(
      "The upper bound of the 'old' range you provided is larger than the
      maximum value observed in the data you provided to 'score'.
      Please double-check that you gave the correct range to the 'old' argument
      (it should be the range of values your data can theoretically take),
      and that the values of 'score' are coded correctly.  If both are correct,
      you can ignore this warning.", exdent = 2),
      collapse = "\n"))
  }
  oldmin <- old[1]
  oldmax <- old[2]
  oldDiff <- oldmax - oldmin
  newmin <- new[1]
  newmax <- new[2]
  newDiff <- newmax - newmin
  xchg <- (newDiff * (score - oldmin)/oldDiff) + newmin
  if (rev) {
    xchg <- revcode(xchg, mn = newmin, mx = newmax)
  }
  return(xchg)
}




#' @rdname rerange
#' @param score A score to rescale to range from 0 to 100
#' @param mn The minimum possible value that \code{score} can take.
#' @param mx The maximum possible value that \code{score} can take.
#'
#' @return A version of \code{score} that is rescaled to range from 0 to 100.
#'
#' @export
rerange100 <- function(score, mn, mx) {
  rerange(score, old = c(mn, mx), new = c(0, 100), rev = FALSE)
}





#' @title Make a data frame of fake item data
#'
#' @description \code{makeFakeData} creates a data frame containing fake item
#'   data to facilitate the writing and testing of scoring functions. It is also
#'   used to create data for examples of scoring function usage.
#'
#' @details The item responses in the first row are all the lowest possible
#'   value and never \code{NA}, and the responses on the 2nd row are all the
#'   highest possible value and never \code{NA}.  This makes it easier to check
#'   if the scoring function is at least getting the scores correct for subjects
#'   with no missing values.  It also makes it easier in some cases to check
#'   that the scoring function is properly reversing the items according to the
#'   \code{itemsrev} argument of the scoring functionl.
#'
#'   Although the resulting data frame can be cutomized using the arguments, the
#'   default values are sufficient for most generic testing purposes (see
#'   example).
#'
#' @param n The number of respondents (rows) in the fake data.  The default is
#'   \code{20}.
#' @param nitems The numnber of items in the fake data.  The default is
#'   \code{9}.
#' @param values A vector of all possible values the items can take.  The
#'   default is \code{0:4}, or equivalently \code{c(0, 1, 2, 3, 4)}.
#' @param propmiss The proportion of responses that will be randomly assigned to
#'   be missing.  The default is \code{.20}.
#' @param prefix A quoted character that will be used to prefix the item
#'   numbers.  The default is \code{"q"}.
#' @param id Logical, if \code{TRUE} the first variable in the data frame will
#'   be a unique row \code{"ID"}.  The default is \code{FALSE}, and the
#'   \code{"ID"} variable is omitted.
#'
#' @return A data frame with \code{n} rows, \code{nitems} items, and possibly
#'   with some missing values randomly inserted.
#'
#' @export
#'
#' @examples
#' makeFakeData()
makeFakeData <- function(n = 20, nitems = 9, values = 0:4, propmiss = .20,
                         prefix = "q", id = FALSE) {
  nvals <- length(values)
  p <- (1 - propmiss)/nvals
  probs <- c(propmiss, rep(p, nvals))

  datavec <- sample(x = c(NA, values), size = nitems*n, replace = TRUE,
                    prob = probs)
  datadf <- data.frame(matrix(datavec, nrow=n))
  ID <- paste0("ID", 1:n)
  names(datadf) <- paste0(prefix, 1:nitems)
  ## Making 1st row have all lowest item scores, 2nd row all highest item scores
  datadf[1, ] <- min(values)
  datadf[2, ] <- max(values)
  datadf <- data.frame(ID, datadf)
  if (!id) {
    datadf$ID <- NULL
  }
  datadf
}

