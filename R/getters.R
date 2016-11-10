#' @title Get certain objects needed internally by other PROscorerTools functions
#'
#' @description These functions are used internally by other PROscorerTools
#'   functions, particularly \code{\link{scoreScale}}, to get interim objects
#'   needed for \code{\link{scoreScale}} to do its job.  Only developers wishing
#'   to contribute to the \code{\link{PROscorerTools}} package should use these
#'   functions.  Even developers should avoid using them for anything but
#'   experimentation.  If you use these functions, be warned that they will
#'   likely change in future versions of the package in ways that may not be
#'   compatible with your usage.  They will also be made invisible to users in
#'   future version of the \code{\link{PROscorerTools}} package. The only reason
#'   they are visible to users in these initial versions of the package is to
#'   make the internals of the package more transparent to potential developers
#'   to facilitate the development and improvement of the package.
#'
#'
#' @param df A data frame given as the argument to \code{\link{scoreScale}}
#'
#' @param minmax Minimum and maximum possible item values, given as argument to
#'   \code{\link{scoreScale}}
#'
#' @param revitems Items to reverse, given as argument to
#'   \code{\link{scoreScale}}
#'
#' @param items Item index, given as argument to \code{\link{scoreScale}}
#'
#' @param dfItems A data frame with only items, created and used by
#'   \code{\link{scoreScale}} as an interim step in scoring a scale
#'
#' @return These functions return a data frame containing only the items to be
#'   scored. In the case of \code{get_dfItemsrev}, the specified items will be
#'   reverse scored in the returned data frame.
#'
#' @keywords internal
#'
#' @export
get_dfItems <- function(df, items) {
  ##  Get dfItems, a df with only the items
  if (is.null(items)) {
    dfItems <- df
  }
  if (!is.null(items)) {
    dfItems <- df[items]
  }
  ## Maybe put this in get_dfItems?
  if (nrow(dfItems) != nrow(df)) {
    stop("Something went wrong, you may have discovered a bug in the function.
         Please contact Ray Baser with the details so he can figure out what
         caused this bug and how to squash it.  nrow(dfItems) != nrow(df)")
  }
  dfItems
}

### Maybe make get_dfItemsrev have "items" arg instead of "dfItems", and call
###   get_dfItems within it?
#' @export
#'
#' @keywords internal
#'
#' @rdname get_dfItems
get_dfItemsrev <- function(df, dfItems, revitems, minmax) {
  if (revitems != FALSE && !is.null(revitems)) {
    ##  a. If revitems = TRUE, just reverse all items in dfItems.
    if (is.logical(revitems) && revitems == TRUE) {
      dfItems[] <- lapply(dfItems[], revcode, mn = minmax[1], mx = minmax[2])
    }
    ##  b. If revitems = character, Reverse items in dfItems by names in revitems
    if (is.character(revitems)) {
      dfItems[revitems] <- lapply(dfItems[revitems], revcode,
                                  mn = minmax[1], mx = minmax[2])
    }
    ## c. If revitems = numeric,
    ##    (1) Get var names in df using indices given to revitems
    ##    (2) Reverse items in dfItems by names extracted from df.
    if (is.numeric(revitems)) {
      namesRev <- names(df[revitems])
      dfItems[namesRev] <- lapply(dfItems[namesRev], revcode,
                                  mn = minmax[1], mx = minmax[2])
    }
  }
  dfItems
}
