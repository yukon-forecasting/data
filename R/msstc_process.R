#' Process a single MSSTC raw file (daily values) and generate daily and monthly
#' derived files from it.
#'
#' @export
msstc_process_single_file <- function(path) {
  stopifnot(file.exists(path))

  nc <- tidync::tidync(path)

  daily_values <- nc |>
    tidync::hyper_filter(lat = dplyr::between(lat, 63, 64),
                lon = dplyr::between(lon, 194, 195)) |>
    tidync::hyper_tibble() |>
    dplyr::mutate(
      skt = skt - 273.15, # kelvin -> Celsius
      time = as.POSIXct(
        time * 3600, # convert hours-since to seconds-since
        tz = "UTC",  # pretty sure time zone should be utc
        origin = "1800-01-01 00:00:0"),
      day = lubridate::day(time),
      month = lubridate::month(time),
      year = lubridate::year(time)
    ) |>
    dplyr::filter(month == 5) |>
    dplyr::select(year, month, day, skt)

  daily_values
}

msstc_process_raw_files <- function(file_infos) {
  lapply(file_infos, msstc_process_single_file)
}
