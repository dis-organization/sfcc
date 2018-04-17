
<!-- README.md is generated from README.Rmd. Please edit that file -->
sfcc
====

The goal of sfcc is to provide fast and flexible creation of `sf` simple features geometries.

For now it's really just for `sfc` vectors of `POINT`. There's some exploration with `MULTIPOINT` but it's no real improvement. This is directly motivated by the set-based idioms of [silicate](https://github.com/hypertidy/silicate), and the need to bypass the thorough checking done by the sf constructors.

Installation
------------

I wouldn't use this as-is, yet. :)

Example
-------

This example was motivated by [this issue](https://github.com/r-spatial/sf/issues/700), trying to speed up sf creation for POINTs.

The improvement is fairly modest, so there might be a better Rcpp way to do this?

``` r
N <- 1e5
x <- data.frame(a = sample(letters, N, replace = TRUE),
                 lng = runif(N, -120, -100),
                 lat = runif(N, 30, 48))
## we avoid st_sf so we can compare apples (just the sfc creation)
sf_mk_points <- function(x, coords) {
        classdim = sf:::getClassDim(rep(0, length(coords)), length(coords), dim, "POINT")
        structure( lapply(split(as.vector(t(as.matrix(x[, coords]))),
                rep(seq_len(nrow(x)), each = length(coords))),
                ## it does help to create this as a template and update in this loop
                ## but not as much as list-creation in C++
                function(vec) structure(vec, class = classdim)),
            n_empty = 0L, precision = 0, crs = NA_crs_,
            bbox = structure(
                c(xmin = min(x[[coords[1]]], na.rm = TRUE),
                ymin = min(x[[coords[2]]], na.rm = TRUE),
                xmax = max(x[[coords[1]]], na.rm = TRUE),
                ymax = max(x[[coords[2]]], na.rm = TRUE)), class = "bbox"),
            class =  c("sfc_POINT", "sfc" ))
}

m <- cbind(x$lng, x$lat)
library(rbenchmark)

library(sf)
#> Linking to GEOS 3.6.2, GDAL 2.2.4, proj.4 4.9.3
benchmark(
  sfcc_pt =  sfcc::mk_sfc_POINT(m, crs = 4326),
  sf_pt = sf_mk_points(x, coords = c("lng", "lat"))
  ,replications = 10
)
#>      test replications elapsed relative user.self sys.self user.child
#> 2   sf_pt           10  15.259   15.244    15.231    0.028          0
#> 1 sfcc_pt           10   1.001    1.000     0.977    0.024          0
#>   sys.child
#> 2         0
#> 1         0
```
