#' @title Change the range of an item or score
#'
#' @description
#' \itemize{
#'   \item \code{rerange} linearly rescales a numeric variable to have new
#'     minimum and maximum values of the user's choosing.
#'   \item \code{rerange100} is a simplified version of \code{rerange} that
#'     rescales a variable to range from 0 to 100.
#' }
#'
#' @details The \code{rerange} function can re-range and reverse code a variable
#'   all at once. If \code{rev = TRUE}, \code{score} will be reversed using
#'   \code{\link{revcode}} after it is re-ranged.  The same could be
#'   accomplished by keeping \code{rev = FALSE} and reversing the order of the
#'   range given to \code{new}.  For example, the following two calls to
#'   \code{rerange} will return the same values:
#' \itemize{
#'   \item \code{rerange(score, old = c(0, 10), new = c(0, 100), rev = TRUE)}
#'   \item \code{rerange(score, old = c(0, 10), new = c(100, 0), rev = FALSE)}
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
#'   \code{c(min, max)} \code{score}.  This is a required argument.
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
                    old = NULL,
                    new = c(0, 100),
                    rev = FALSE) {
  if (is.null(old)) {
    stop("Please provide a non-NULL value to the 'old' argument.
         See ?rerange for help.")
  }
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


# @param score A score to rescale to range from 0 to 100
#' @rdname rerange
#' @param mn The minimum possible value that \code{score} can take.
#' @param mx The maximum possible value that \code{score} can take.
#'
#' @return A version of \code{score} that is rescaled to range from 0 to 100.
#'
#' @export
rerange100 <- function(score, mn, mx) {
  rerange(score, old = c(mn, mx), new = c(0, 100), rev = FALSE)
}


