library(sf)
library(sp)

N <- 1e3
df <- data.frame(a = sample(letters, N, replace = TRUE),
                 lng = runif(N, -120, -100),
                 lat = runif(N, 30, 48))



system.time({
  dcc <- mk_sfc_POINT(cbind(df$lng, df$lat), crs = 4326)
})


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

