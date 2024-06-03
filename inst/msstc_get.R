library(yukonforecastingdata)

out_path_base <- file.path("data", "msstc", "raw", "ncep.reanalysis")

if (!dir.exists(out_path_base)) {
  dir.create(out_path_base, recursive = TRUE)
}

msstc_get_all_urls() |>
  msstc_make_file_infos(out_path_base = out_path_base) |>
  msstc_fetch_file_infos() |>
  check_all()
