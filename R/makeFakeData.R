#' @title Make a data frame of fake item data
#'
#' @description \code{makeFakeData} creates a data frame containing fake item
#'   data to facilitate the writing and testing of new scoring functions. It is
#'   also used to create data for examples of scoring function usage.
#'
#' @details The item responses in the first row are all the lowest possible
#'   value and never \code{NA}, and the responses on the second row are all the
#'   highest possible value and never \code{NA}.  This makes it easier to check
#'   if the scoring function is at least getting the scores correct for subjects
#'   with no missing values.  It also makes it easier in some cases to check
#'   that the scoring function is properly reversing the items according to the
#'   \code{itemsrev} argument of the scoring function.
#'
#'   Although the resulting data frame can be customized using the arguments,
#'   the default values are sufficient for most generic testing purposes (see
#'   example).
#'
#' @param n The number of respondents (rows) in the fake data.  The default is
#'   \code{20}.
#' @param nitems The number of items in the fake data.  The default is
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

