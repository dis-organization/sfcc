library(sf)
library(sp)

N <- 1e6
df <- data.frame(a = sample(letters, N, replace = TRUE),
                 lng = runif(N, -120, -100),
                 lat = runif(N, 30, 48))


m <- cbind(df$lng, df$lat)
library(rbenchmark)
benchmark(
  sfcc_pt =  mk_sfc_POINT(m, crs = 4326),
  sf_pt = st_as_sf(df, coords = c("lng", "lat"))
  #,replications = 2
)


oidx <- c(30, 1e4, 2e4, 5e4)

benchmark(
  sfcc_mpt =  mk_sfc_MULTIPOINT(m, oidx, crs = 4326),
  sfcc_mpt2 =  mk_sfc_MULTIPOINT(m, crs = 4326),
  sf_mpt = st_sfc(st_multipoint(m))
  ,replications = 2
)

benchmark(
  sfccp = multipoints_cpp(m, oidx),
  sfccr = multipoints_r(m, oidx)
)


#tools::package_native_routine_registration_skeleton("../sfcc", "src/init.c",character_only = FALSE)


#system.time({
#  df_sf <- st_as_sf(df, coords = c("lng", "lat"), crs = "+proj=longlat +datum=WGS84")
#})
#ptvec <- structure(c(0, 0), class = c("XY", "POINT", "sfg"))
#ptvecfun <- function(pt) {
#  ptvec[1:2] <- pt
#  ptvec
#}
#l <- split(t(cbind(df[["lng"]], df[["lat"]])), rep(seq_len(nrow(df)), each = 2))

#system.time({
#  dt <- tibble::tibble(a = df$a)
#  dt[["geometry"]] <- lapply(l, ptvecfun)
#})

