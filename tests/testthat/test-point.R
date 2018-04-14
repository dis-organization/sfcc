context("test-point.R")

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
