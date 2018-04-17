
<!-- README.md is generated from README.Rmd. Please edit that file -->
sfcc
====

The goal of sfcc is to provide fast and flexible creation of `sf` simple features geometries.

For now it's really just for `sfc` vectors of `POINT`. There's some exploration with `MULTIPOINT` but it's no real improvement. This is directly motivated by the set-based idioms of [silicate](https://github.com/hypertidy/silicate), and the need to bypass the thorough checking done by the sf constructors. Ultimately `sfcc` hopes to be or help the creation of a kind of `sfcore` that is independent of the sf giant.

Installation
------------

You can install the development version of `sfcc` with

``` r
devtools::install_github("mdsumner/sfcc")
```

Example
-------

This example was motivated by [this issue](https://github.com/r-spatial/sf/issues/700), trying to speed up sf creation for POINTs.

``` r
N <- 1e6
df <- data.frame(a = sample(letters, N, replace = TRUE),
                 lng = runif(N, -120, -100),
                 lat = runif(N, 30, 48))


m <- cbind(df$lng, df$lat)
library(rbenchmark)

library(sf)
#> Linking to GEOS 3.6.2, GDAL 2.2.4, proj.4 4.9.3
benchmark(
  sfcc_pt =  st_sf(geometry = sfcc::mk_sfc_POINT(m, crs = 4326), a = df$a),
  sf_pt = st_as_sf(df, coords = c("lng", "lat"))
  ,replications = 2
)
#>      test replications elapsed relative user.self sys.self user.child
#> 2   sf_pt            2  44.175    2.625    44.081    0.079          0
#> 1 sfcc_pt            2  16.826    1.000    16.541    0.284          0
#>   sys.child
#> 2         0
#> 1         0
```
