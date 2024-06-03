#' @export
download_one <- function(url, base_dir, verbose = FALSE) {
  path <- file.path(base_dir, basename(url))

  if (file.exists(path)) {
    message(paste("File", path, "already exists. Skipping."))
    return(path)
  }

  if (verbose) {
    message(paste("Downloading", url, "to", path))
  }

  curl::curl_download(url, path)

  path
}

download_all_polite <- function(urls, base_dir = file.path("."), delay = 1, verbose = FALSE) {
  stopifnot(is.numeric(delay))
  stopifnot(delay > 0)

  lapply(urls, download_one, base_dir, verbose)
}
