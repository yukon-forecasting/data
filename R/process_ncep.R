library(curl)
library(dplyr)
library(glue)
library(lubridate)
library(ncdf4)
library(tidync)

make_download_filename <- function(year) {
  glue::glue("skt.sfc.gauss.{year}.nc")
}

make_download_url <- function(year) {
  glue::glue("https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Dailies/surface_gauss/{make_download_filename(year)}")
}

save_dir <- tempdir()
input_file_path <- file.path(save_dir, make_download_filename(2024))
curl::curl_download(make_download_url(2024), input_file_path)

ncdf4::nc_open(input_file_path)
# => units: hours since 1800-01-01 00:00:0.0

x <- tidync(input_file_path)

daily_values <- x |> 
  hyper_filter(lat = dplyr::between(lat, 63, 64),
               lon = dplyr::between(lon, 194, 195)) |>
  hyper_tibble() |> 
  mutate(
    skt = skt - 273.15, # kelvin -> Celsius
    time = as.POSIXct(
      time * 3600, # convert hours-since to seconds-since
      tz = "UTC",  # pretty sure time zone should be utc
      origin = "1800-01-01 00:00:0"),
    month = month(time)
  ) |> 
  filter(month == 5)

(average_value <- daily_values |> 
  summarize(mean(skt)))
