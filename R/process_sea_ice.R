# https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0081.002/2024.03.24/NSIDC0081_SEAICE_PS_N25km_20240324_v2.0.nc
# https://nsidc.org/data/user-resources/help-center/guide-nsidcs-polar-stereographic-projection
# +proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449 +units=m +no_defs
# https://epsg.io/3411

library(dplyr)
library(lubridate)
library(sf)
library(tidync)

library(ncdf4)
nc_open("~/Downloads/Sea Ice Mar 23 2024.nc")
# units: days since 1970-01-01 00:00:00


# reprojection stuff
proj_string <- "+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449 +units=m +no_defs"

top_left_corner <- sf_project(
  from = "EPSG:4326",
  to = "EPSG:3411",
  pts = matrix(c(-169, 63),
               ncol = 2,
               byrow = TRUE)
)

bottom_right_corner <- sf_project(
  from = "EPSG:4326",
  to = "EPSG:3411",
  pts = matrix(c(-166, 62),
               ncol = 2,
               byrow = TRUE)
)

###

x <- tidync("~/Downloads/Sea Ice Mar 23 2024.nc")

x |>
  hyper_filter(x = dplyr::between(x, bottom_right_corner[1,1], top_left_corner[1,1]),
               y = dplyr::between(y, bottom_right_corner[1,2], top_left_corner[1,2])) |>
  hyper_tibble() |>
  mutate(
    date = as.Date(time), # time is days since UNIX epoch so this is simple
    month = month(date),
    day = day(date)
  )
