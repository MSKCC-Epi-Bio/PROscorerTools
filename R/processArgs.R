#' @title Argument Processors for \code{\link{scoreScale}} Function
#'
#' @description Functions that are used internally within other
#'   \code{\link{PROscorerTools}} functions, namely \code{\link{scoreScale}}, to
#'   process the arguments passed to them.  Only developers wishing to
#'   contribute to the \code{\link{PROscorerTools}} package should use these
#'   functions. Even developers should avoid using them for anything but
#'   experimentation.  If you use these functions, be warned that they will
#'   likely change in future versions of the package in ways that may not be
#'   compatible with your usage. They will also be made invisible to users in
#'   future version of the \code{\link{PROscorerTools}} package.  The only
#'   reason they are visible to users in these initial versions of the package
#'   is to make the internals of the package more transparent to potential
#'   developers to facilitate the development and improvement of the package.
#'
#' @details Functions with prefix \code{chk_} simply check the argument and
#'   return \code{TRUE} or \code{FALSE}.  Functions with the prefix
#'   \code{chkstop_} check the argument and, if \code{FALSE}, stop execution and
#'   display an error message to help the user pinpoint the problem.
#'
#' @param df A data frame, such as the one given \code{\link{scoreScale}}
#'
#' @param okmiss Proportion of missing items allows, given as argument to
#'   \code{\link{scoreScale}}
#'
#' @param type Score type, given as argument to \code{\link{scoreScale}}
#'
#' @param minmax Minimum and maximum possible item values, given as argument to
#'   \code{\link{scoreScale}}
#'
#' @param imin Minimum possible item value
#'
#' @param imax Maximum possible item value
#'
#' @param revitems Items to reverse, given as argument to \code{\link{scoreScale}}
#'
#' @param items Item index, given as argument to \code{\link{scoreScale}}
#'
#' @param dfItems A data frame with only items, created and used by
#'   \code{\link{scoreScale}} as an interim step in scoring a scale
#'
#' @return Functions with prefix \code{chk_} return \code{TRUE} or \code{FALSE}.
#'   Functions with the prefix \code{chkstop_} print an error message and stop
#'   the execution of the function in which they are embedded.
#'
#' @export
#' @name processArgs
chkstop_df <- function(df) {
  if (!is.data.frame(df)) {
    stop("Give me a data frame!  The first argument, df, must be a data frame
         for this to work.")
  }
}

## Check that the object given to the \code{df} argument is a data frame.  Stop
## with an error message if not.




## Check that okmiss is a proportion between 0 and 1

#' @export
#' @keywords internal
#' @rdname processArgs
chkstop_okmiss <- function(okmiss) {
  if (length(okmiss) != 1 || !is.numeric(okmiss)) {
    stop(paste(strwrap("The value of 'okmiss' must be a single
                       proportion between 0 and 1.",
                       exdent = 2, width = 67), collapse = "\n"))
  }
  if (okmiss < 0 || okmiss > 1 || is.null(okmiss)) {
    stop(paste(strwrap(
      sprintf("The value of 'okmiss' must be a single proportion
              between 0 and 1.  You gave a value of %s.", okmiss),
      exdent = 2, width = 67), collapse = "\n"))
  }
}

##XX CHECK that type has a valid value
##XX   - Not needed because match.arg() already checks this
## chkstop_type <-function(type, minmax) {
##   if (!(type %in% c("pomp", "100", "sum", "mean"))) {
##     stop(paste(strwrap(
##         "The value you gave to the 'type' argument is invalid.
##          The 'type' argument should be one of
##          'pomp', '100', 'sum', or 'mean'.  If 'type' is omitted,
##          the default value of 'pomp' will be used.",
##          exdent = 2, width = 60), collapse = "\n"))
##   }
## }

## Check that type dependencies are met.
## Specifically, if \code{type} is \code{"pomp"} or \code{"100"}, then
## \code{minmax} must be given a valid value.

#' @export
#' @keywords internal
#' @rdname processArgs
chkstop_type <-function(type, minmax) {
  if (type == "pomp" || type == "100") {
    if (is.null(minmax)) {
      stop("'minmax' is a required argument if 'type' is
           either 'pomp' (the default) or '100'.")
    }
    if (length(minmax) != 2 || !is.numeric(minmax)) {
      stop(paste(strwrap(
        "If 'type' is either 'pomp' (the default) or '100'
        you must provide a valid numeric range to the 'minmax' argument.
        For example, if your lowest possible item response is 0 and your
        highest possible response is 4, you would use 'minmax = c(0, 4)'.",
        exdent = 2, width = 65), collapse = "\n"))
    }
  }
}




## If (revitems != FALSE && !is.null(revitems)),
## is used in scoreScale to check values given to revitems.
## It is to be run after dfItems has been created from df and (possibly) items.
## It also checks that a numeric vector of length 2 was provided to the
## \code{minmax} argument.  See \code{chkstop_minmax} for more validity checks
## of values given to \code{minmax} against the values in the data.

#' @export
#' @keywords internal
#' @rdname processArgs
chkstop_revitems <- function(df, dfItems, revitems, items, minmax) {
  # Checking minmax
  if (is.null(minmax) || length(minmax) != 2 || !is.numeric(minmax)) {
    stop(paste(strwrap(
      "If you use 'revitems' to indicate items that must be reverse-coded
        before scoring, you must provide a valid numeric range to 'minmax'.
        For example, if your lowest possible item response is 0 and your
        highest possible response is 4, you would use 'minmax = c(0, 4)'.",
      exdent = 2, width = 65), collapse = "\n"))
  }
  # Checking if revitems values are in dfItems
  # If character, are all revitems values in dfItems?
  if (is.character(revitems) && !all(revitems %in% names(dfItems))) {
    if (!is.null(items)) {
      stop("All variables given to 'revitems' must also be given to 'items'.")
    }
    if (is.null(items)) {
      stop("All item names supplied to 'revitems' must be in names(df).")
    }
  }
  # If is.numeric(revitems), test that revitems %in% 1:length(df)
  if (is.numeric(revitems) && !all(revitems %in% 1:length(df))) {
    stop("The numeric item indexes supplied to 'revitems' is not possible,
         given the number of variables in df.")
  }
  if (is.numeric(revitems) && !is.null(items) &&
      !all(names(df[revitems]) %in% names(dfItems))) {
    stop(paste(strwrap(
      "The numeric item indexes supplied to 'revitems' selected some
      items from 'df' that were NOT given to the 'items' argument.
      All of the items in 'revitems' should also be in 'items'.",
      exdent = 2, width = 60), collapse = "\n"))
  }
}



#' @export
#' @keywords internal
#' @rdname processArgs
chk_imin <- function(dfItems, imin) {
  (min(dfItems, na.rm = TRUE) < imin)
}

#' @export
#' @keywords internal
#' @rdname processArgs
chk_imax <- function(dfItems, imax) {
  (max(dfItems, na.rm = TRUE) > imax)
}


#' @export
#' @rdname processArgs
chkstop_minmax <- function(dfItems, minmax) {
  if (length(minmax) != 2 || !is.numeric(minmax)) {
    stop(paste(strwrap(
      "Please provide a valid numeric range to 'minmax'.
      For example, if your lowest possible item response is 0 and your
      highest possible response is 4, you would use 'minmax = c(0, 4)'.",
      exdent = 2, width = 65), collapse = "\n"))
  }
  imin <- minmax[1]
  imax <- minmax[2]
  if (imax <= imin) {
    stop("'minmax' should be c(min, max).
           Your max is not greater than your min.")
  }
  if (chk_imin(dfItems, imin = imin)) {
    stop(sprintf("The minimum value you gave for the items in 'minmax' is %s,
         but you have at least one value lower than this.", imin))
  }
  if (chk_imax(dfItems, imax = imax)) {
    stop(sprintf("The maximum value you gave for the items in 'minmax' is %s,
         but you have at least one value higher than this.", imax))
  }


  if (imin < min(dfItems, na.rm = TRUE) ) {
    warning(paste(strwrap(sprintf(
      "The lower bound you gave to 'minmax', %s, is smaller than the
      minimum item response observed in the data you provided to 'df'.
      Please double-check that you gave the correct lower bound to 'minmax'
      (it should be the value of the lowest possible item response),
      and that the item responses are coded correctly in your data.
      If both are correct, you can ignore this warning.", imin),
      exdent = 2),
      collapse = "\n"))
  }
  if (imax > max(dfItems, na.rm = TRUE) ) {
    warning(paste(strwrap(sprintf(
      "The upper bound you gave to 'minmax', %s, is larger than the
      largest item response observed in the data you provided to 'df'.
      Please double-check that you gave the correct upper bound to 'minmax'
      (it should be the value of the highest possible item response),
      and that the item responses are coded correctly in your data.
      If both are correct, you can ignore this warning.", imax),
      exdent = 2),
      collapse = "\n"))
  }
}



