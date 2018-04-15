context("test-point.R")
library(sf)
x <- 1:10
y <- rnorm(10)

test_that("making points works", {
  expect_equal(points_rcpp(cbind(x, y)),
               ## the unname here is needed
               lapply(unname(split(t(cbind(x, y)),
                            rep(seq_along(x), each = 2))), sf::st_point))

  expect_equal(mk_sfc_POINT(cbind(x, y)),
               st_sfc(lapply(unname(split(t(cbind(x, y)),
                                   rep(seq_along(x), each = 2))), sf::st_point)
               ))
})

test_that("making multipoints works", {
  expect_equal(multipoints_rcpp(cbind(x, y)),
         list(st_multipoint(cbind(x, y))))

  ## we can't do a direct compare because sf seems to keep dimnames
  sfccmpts <- multipoints_rcpp(cbind(x, y), c(3, 8))
  sfmpts <- list(st_multipoint(cbind(x, y)[1:2, ]),
               st_multipoint(cbind(x, y)[3:7, ]),
               st_multipoint(cbind(x, y)[8:10, ]))
  expect_equal(length(sfccmpts), length(sfmpts))
  expect_equal(unique(c(unclass(sfccmpts[[1]]) - unclass(sfmpts[[1]]))),
                      0)

})


test_that("metadata is correct", {
  expect_equal(st_crs(mk_sfc_POINT(cbind(x, y), crs = 32755)),
               structure(list(epsg = NA_integer_,
                              proj4string = "+init=epsg:32755"), class = "crs"))

  expect_equal(st_crs(mk_sfc_POINT(cbind(x, y), crs = "+proj=laea")),
               structure(list(epsg = NA_integer_,
                              proj4string = "+proj=laea"), class = "crs"))

  expect_equal(st_crs(mk_sfc_MULTIPOINT(cbind(x, y), crs = 32755)),
               structure(list(epsg = NA_integer_,
                              proj4string = "+init=epsg:32755"), class = "crs"))

  expect_equal(st_crs(mk_sfc_MULTIPOINT(cbind(x, y), crs = "+proj=laea")),
               structure(list(epsg = NA_integer_,
                              proj4string = "+proj=laea"), class = "crs"))


})


