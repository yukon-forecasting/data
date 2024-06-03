#' @export
msstc_make_download_filename <- function(year) {
  glue::glue("skt.sfc.gauss.{year}.nc")
}

#' @export
msstc_make_download_url <- function(year) {
  glue::glue("https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Dailies/surface_gauss/{msstc_make_download_filename(year)}")
}

#' @export
msstc_generate_urls <- function() {
  start_year <- 1961
  current_year <- as.numeric(format(Sys.Date(), "%Y"))
  stopifnot(current_year > start_year)
  years <- start_year:current_year

  vapply(years, msstc_make_download_url, "")
}

#' @export
msstc_check_all <- function(paths) {
  stopifnot(all(unlist(lapply(paths, function(path) {
    file.exists(path)
  }))))

  stopifnot(all(unlist(lapply(paths, function(path) {
    file.size(path) > 0
  }))))

  paths
}
