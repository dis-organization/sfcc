#' Make polygons
#'
#' @param xlist list of polygon matrices
#' @param gdim geometric dimension (in `sf::st_dimension` terms)
#' @param ... reserved
#' @export
polygons_rcpp <- function(xlist, gdim = "XY", ...) {
  UseMethod("polygons_rcpp")
}
#' @export
polygons_rcpp.matrix <- function(xlist, gdim = "XY", ...) {
  coordinated_warning(xlist, gdim)
  ## if there's no grouping structure, it's a simple single POLYGON
  polygons_cpp(list(xlist), gdim, ...)
}
#' @export
polygons_rcpp.data.frame <- function(xlist, gdim = "XY", ...) {
  polygons_cpp(as.matrix(xlist), ...)
}
#' @export
polygons_rcpp.list <- function(xlist, gdim = "XY", ...) {
  polygons_cpp(xlist, ...)
}

#' Make vector of polygons
#'
#' @param x coordinates of polygons
#' @param ... reserved
#' @param crs coordinate system in EPSG (integer) or proj4string
#'
#' @export
mk_sfc_POLYGON <- function(xlist, crs = NA, ...) {
  UseMethod("mk_sfc_POLYGON")
}
#' @export
mk_sfc_POLYGON.matrix <- function(xlist, crs = NA, ...) {
  mk_sfc_POLYGON(list(xlist))  ## xlist is one matrix
}
#' @export
mk_sfc_POLYGON.data.frame <- function(xlist, crs = NA, ...) {
  mk_sfc_POLYGON(list(as.matrix(xlist)))  ## xlist is one data frame
}

#' @export
mk_sfc_POLYGON.default <- function(xlist, crs = NA, ...) {
  ## not sure how to do this best, wrappers could pass this range in before
  ## splitting?
  ## or the rcpp fun below might return as attribute?
  xr <- range(unlist(lapply(xlist, function(aa) aa[,1])))
  yr <- range(unlist(lapply(xlist, function(aa) aa[,2])))

  g <- polygons_rcpp(xlist, classme = TRUE)
  class(g) <- c("sfc_POLYGON", "sfc")
  sfc_boilerplate(g, xr, yr, crs)
}
