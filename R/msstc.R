#' Get MSSTC data for a given year
#'
#' https://psl.noaa.gov/data/gridded/data.ncep.reanalysis.surfaceflux.html
#'
#' @param year (numeric|character) The year to get data for
#'
#' @return (list) A NetCDF
#' @export
get_msstc_data <- function(year) {
  url <- paste0(
    "ftp://ftp2.psl.noaa.gov/",
    "Datasets/ncep.reanalysis.dailyavgs/surface_gauss/skt.sfc.gauss.",
    year,
    ".nc"
  )

  temp_path <- tempfile()
  download.file(url, temp_path)

  ncdf4::nc_open(temp_path)
}

#' Get the index for a given latitude
#'
#' @param nc A NetCDF file
#' @param target_lat Optional. The latitude to find an index nearest to
#'
#' @return (numeric) A vector of latitude indices
get_lat_index <- function(nc, target_lat = 63.1) {
  lat <- ncdf4::ncvar_get(nc, "lat")

  # Verify units
  lat_units <- ncdf4::ncatt_get(nc, "lat", "units")
  stopifnot(lat_units$hasatt)
  stopifnot(lat_units$value == "degrees_north")

  which.min(abs(lat - target_lat))
}

#' Get the index for a given longitude
#'
#' @param nc A NetCDF file
#' @param target_lon Optional. The longitude to find an index nearest to
#'
#' @return (numeric) A vector of longitude indices
get_lon_index <- function(nc, target_lon = 165.5) {
  lon <- ncdf4::ncvar_get(nc, "lon")

  # Verify units
  lon_units <- ncdf4::ncatt_get(nc, "lon", "units")
  stopifnot(lon_units$hasatt)
  stopifnot(lon_units$value == "degrees_east")

  target_lon_eastings <- 360 - target_lon

  which.min(abs(lon - target_lon_eastings))
}

#' Get the indices for a given year
#'
#' @param nc A NetCDF file
#' @param year The year to find an indices for
#'
#' @return (numeric) A vector of time indices
get_time_indices <- function(nc, year) {
  time_origin <- "1800-01-01"
  time <- ncdf4::ncvar_get(nc, "time")

  # Verify units
  time_units <- ncdf4::ncatt_get(nc, "time", "units")
  stopifnot(time_units$hasatt)
  stopifnot(time_units$value == "hours since 1800-01-01 00:00:0.0")

  time_dates <- as.Date(time / 24, format = "%j", origin = as.Date(time_origin))

  desired_dates <- seq(
    as.Date(paste0(year, "-05-01")),
    as.Date(paste0(year, "-05-31")),
    by = "day"
  )

  which(time_dates %in% desired_dates)
}

#' Get the MSSTC value for a given year
#'
#' @param nc A NetCDF file
#' @param year The year
#' @param lat Optional. The latitude to find data nearest to
#' @param lon Optional. The longitude to find data nearest to
#'
#' @return
#' @export
get_msstc <- function(nc, year, lat = 63.1, lon = 165.5) {
  lat_index <- get_lat_index(nc, lat)
  lon_index <- get_lon_index(nc, lon)
  time_indices <- get_time_indices(nc, year)

  if (length(time_indices) == 0) {
    stop(paste0("Couldn't find data for year ", year, "."), call. = FALSE)
  }

  # Get skt var
  skt <- ncdf4::ncvar_get(nc, "skt")

  # Verify units
  skt_units <- ncdf4::ncatt_get(nc, "skt", "units")
  stopifnot(skt_units$hasatt)
  stopifnot(skt_units$value == "degK")

  # Grab and convert data
  temps <- skt[lon_index, lat_index, time_indices]

  if (length(temps) < 31) {
    warning("Got fewer than 31 temperatures, data may be incomplete.")
  }

  msstk <- mean(temps)

  msstk - 273.15
}

#' Get MSSTC for a given year
#'
#' @param year (character|numeric) The year
#'
#' @return (numeric) MSSTC
#' @export
msstc <- function(year) {
  nc <- get_msstc_data(year)
  get_msstc(nc, year)
}
