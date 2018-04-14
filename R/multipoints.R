#' Make multi points
#'
#' @param pts coordinates
#' @export
multipoints_rcpp <- function(pts, group = NULL, ..., gdim = "XY") {
  UseMethod("multipoints_rcpp")
}
#' @export
multipoints_rcpp.matrix <- function(pts, group = NULL, ..., gdim = "XY") {
  coordinated_warning(pts, gdim)
  multipoints_cpp(pts, group = group, gdim = gdim)
}
#' @export
multipoints_rcpp.data.frame <- function(pts, group = NULL, ..., gdim = "XY") {
  multipoints_rcpp(as.matrix(pts), group)
}
#' @export
multipoints_rcpp.list <- function(pts, group = NULL, ..., gdim = "XY") {
  multipoints_rcpp(as.matrix(as.data.frame(pts)), group)
}

#' Make vector of multi points
#'
#' @param x coordinates of multi points
#' @export
mk_sfc_MULTIPOINT <- function(x, group, ..., crs = NA_character_) {
  UseMethod("mk_sfc_MULTIPOINT")
}
#' @export
mk_sfc_MULTIPOINT.default <- function(x, group,  ..., crs = NA_character_) {
  x <- as.matrix(x)
  xr <- range(x[,1])
  yr <- range(x[,2])
  if (anyNA(x)) warning("missing values in coordinates")

  gdim <- LETTERS[c(24, 25, 26, 13, 1:12, 14:23)][seq_len(ncol(x))]

  g <- multipoints_rcpp(x, group)
  class(g) <- c("sfc_MULTIPOINT", "sfc")
  sfc_boilerplate(g, xr, yr, crs)
}
