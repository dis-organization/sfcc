#' Make multi points
#'
#' @param pts coordinates input coordinates for points
#' @param objectindex starting index of each object (if more than one)
#' @param ... reserved
#' @param gdim the geometric dimension in `sf::dimension` terms, default is XY
#'
#' @export
multipoints_rcpp <- function(pts, objectindex = NULL, ..., gdim = "XY") {
  UseMethod("multipoints_rcpp")
}
#' @export
multipoints_rcpp.matrix <- function(pts, objectindex = NULL, ..., gdim = "XY") {
  coordinated_warning(pts, gdim)
  ## Currently a LIE, this is not Rcpp at all
  # cls <- c(gdim, "MULTIPOINT", "sfg")
  # if (is.null(objectindex)) {
  #   return(list(structure(pts, class = cls)))
  # }
  # l <- vector("list", length(objectindex) + 1)
  # scanindex <- c(1, objectindex, nrow(pts)+1)
  #
  # for (i in seq_along(l)) {
  #   l[[i]] <- structure(pts[seq(scanindex[i], scanindex[i + 1] -1 ), , drop = FALSE],
  #                           class = cls)
  # }
  # l
  stopifnot(all(objectindex > 1))
  stopifnot(all(objectindex <= nrow(pts)))
  # ## zero-based
  scanindex <- if(is.null(objectindex)) -1 else c(0L, objectindex - 1L, nrow(pts))
  multipoints_cpp(pts, scanindex, gdim = gdim)
}
#' @export
multipoints_rcpp.data.frame <- function(pts, objectindex = NULL, ..., gdim = "XY") {
  multipoints_rcpp(as.matrix(pts), objectindex)
}
#' @export
multipoints_rcpp.list <- function(pts, objectindex = NULL, ..., gdim = "XY") {
  multipoints_rcpp(as.matrix(as.data.frame(pts)), objectindex)
}

#' Make vector of multi points
#'
#' @param x coordinates of multi points
#' @param objectindex starting index of each object (if more than one)
#' @param ... reserved
#' @param crs the projection, EPSG code (integer) or proj4string
#' @export
mk_sfc_MULTIPOINT <- function(x, objectindex = NULL, ..., crs = NA_character_) {
  UseMethod("mk_sfc_MULTIPOINT")
}
#' @export
mk_sfc_MULTIPOINT.default <- function(x, objectindex = NULL,  ..., crs = NA_character_) {
  x <- as.matrix(x)
  xr <- range(x[,1])
  yr <- range(x[,2])
  gdim <- paste(LETTERS[c(24, 25, 26, 13, 1:12, 14:23)][seq_len(ncol(x))],
                collapse = "")
 coordinated_warning(x, gdim)

  g <- multipoints_rcpp(x, objectindex)
  class(g) <- c("sfc_MULTIPOINT", "sfc")
  sfc_boilerplate(g, xr, yr, crs)
}
