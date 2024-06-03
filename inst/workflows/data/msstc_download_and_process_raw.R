library(yukonforecastingdata)
devtools::load_all()
#' Step 1: Download all the files we need
#'

out_path_base <- file.path("data", "msstc", "raw", "ncep.reanalysis")

if (!dir.exists(out_path_base)) {
  dir.create(out_path_base, recursive = TRUE)
}

paths <- msstc_generate_urls() |>
  download_all_polite(base_dir = out_path_base) |>
  msstc_check_all()


#'Step 2: Process each file and create derived outputs
#'

all_years <- msstc_process_raw_files(paths)

## create dailies for each year
daily_files <- lapply(all_years, \(tbl) {
  out_base <- file.path("data", "msstc", "derived", "daily")

  if (!dir.exists(out_base)) {
    dir.create(out_base, recursive = TRUE)
  }

  out_path <- file.path(
    out_base,
    paste0("msstc_daily_", unique(tbl$year), ".csv")
  )

  readr::write_csv(tbl, file.path(out_path))

  out_path
})

## create all-years monthly average
combined <- do.call(rbind.data.frame, all_years)
derived_data_path <- file.path("data", "msstc", "derived")

if (!dir.exists(derived_data_path)) {
  dir.create(derived_data_path, recursive = TRUE)
}

msstc <- combined |>
  dplyr::group_by(year) |>
  dplyr::summarize(msstc = mean(skt))

readr::write_csv(msstc, file.path(derived_data_path, "msstc.csv"))
