library(dplyr)
library(lubridate)
library(tidync)
library(readr)

# For each file, we need to make/update two products:
# 1. A single monthly average
# 2. Daily values, just to get the data out of NetCDF
in_path_base <- file.path("data", "raw", "ncep.reanalysis")
out_path_base <- file.path("data", "derived", "msstc")
dir.create(base_path, recursive = TRUE)

all_files <- dir(in_path_base, full.names = TRUE)

# These are the two derived outputs we make here
daily_path <- file.path(out_path_base, "ncep.reanalysis_may_daily.csv")
monthly_path <- file.path(out_path_base, "msstc.csv")

unlink(daily_path)
unlink(monthly_path)

process_single_file <- function(path) {
  nc <- tidync(path)

  daily_values <- nc |>
    hyper_filter(lat = dplyr::between(lat, 63, 64),
                lon = dplyr::between(lon, 194, 195)) |>
    hyper_tibble() |>
    mutate(
      skt = skt - 273.15, # kelvin -> Celsius
      time = as.POSIXct(
        time * 3600, # convert hours-since to seconds-since
        tz = "UTC",  # pretty sure time zone should be utc
        origin = "1800-01-01 00:00:0"),
      day = day(time),
      month = month(time),
      year = year(time)
    ) |>
    filter(month == 5) |>
    select(year, month, day, skt)

  write_csv(daily_values, daily_path, append = TRUE)

  average_value <- daily_values |>
    summarize(mean(skt))

  write_csv(data.frame(
    year = unique(daily_values$year),
    msstc = dplyr::pull(average_value)
  ), monthly_path, append = TRUE)
}

writeLines("year,month,day,skt", daily_path)
writeLines("year,msstc", monthly_path)
lapply(all_files, process_single_file)
