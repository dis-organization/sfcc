#' Make points
#'
#' @param pts list of point vectors (assumed length 2)
#' @param gdim geometric dimension (in `sf::st_dimension` terms)
#' @param ... reserved
#' @export
points_rcpp <- function(pts, gdim = "XY", ...) {
  UseMethod("points_rcpp")
}
#' @export
points_rcpp.matrix <- function(pts, gdim = "XY", ...) {
  coordinated_warning(pts, gdim)
  points_cpp(pts, gdim)
}
#' @export
points_rcpp.data.frame <- function(pts, gdim = "XY", ...) {
  points_rcpp(as.matrix(pts))
}
#' @export
points_rcpp.list <- function(pts, gdim = "XY", ...) {
  points_rcpp(as.matrix(as.data.frame(pts)))
}

#' Make vector of points
#'
#' @param x coordinates of points
#' @param ... reserved
#' @param crs coordinate system in EPSG (integer) or proj4string
#'
#' @export
mk_sfc_POINT <- function(x, crs = NA, ...) {
  UseMethod("mk_sfc_POINT")
}
#' @export
mk_sfc_POINT.default <- function(x, crs = NA, ...) {
  x <- as.matrix(x)
  xr <- range(x[,1])
  yr <- range(x[,2])
  if (anyNA(x)) warning("missing values in coordinates")

  gdim <- LETTERS[c(24, 25, 26, 13, 1:12, 14:23)][seq_len(ncol(x))]

  g <- sfcc::points_rcpp(x)
  class(g) <- c("sfc_POINT", "sfc")
  sfc_boilerplate(g, xr, yr, crs)
}
