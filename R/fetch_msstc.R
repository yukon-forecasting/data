library(curl)

make_download_filename <- function(year) {
  glue::glue("skt.sfc.gauss.{year}.nc")
}

make_download_url <- function(year) {
  glue::glue("https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Dailies/surface_gauss/{make_download_filename(year)}")
}

get_all_urls <- function() {
  start_year <- 1961
  current_year <- as.numeric(format(Sys.Date(), "%Y"))
  stopifnot(current_year > start_year)
  years <- start_year:current_year

  vapply(years, make_download_url, "")
}

make_file_infos <- function(urls, out_path_base) {
  lapply(urls, function(url) {
    list(url = url, out_path = file.path(out_path_base, basename(url)))
  })
}

fetch_one <- function(file_info, delay = 1) {
  print(file_info$url)

  if (file.exists(file_info$out_path)) {
    cat(file_info$out_path, "exists. Skipping.", "\n")
    return(file_info)
  }

  curl::curl_download(file_info$url, file_info$out_path)

  Sys.sleep(delay)

  file_info
}

fetch_file_infos <- function(file_infos, delay = 1) {
  lapply(
    file_infos,
    function(file_info) {
      fetch_one(file_info, delay = delay)
    }
  )
}

check_all <- function(file_infos) {
  stopifnot(all(unlist(lapply(file_infos, function(file_info) { file.exists(file_info$out_path)}))))
  stopifnot(all(unlist(lapply(file_infos, function(file_info) { file.size(file_info$out_path) > 0}))))

  invisible(TRUE)
}

out_path_base <- file.path("data", "raw", "ncep.reanalysis")

if (!dir.exists(out_path_base)) {
  dir.create(out_path_base, recursive = TRUE)
}

get_all_urls() |>
  make_file_infos(out_path_base = out_path_base) |>
  fetch_file_infos() |>
  check_all()
