library(readr)
library(dplyr)

temps <- read_csv("data/msstc/raw/2021/surface_temperature-2021.csv")
stopifnot(all(range(temps$date) == c("2021-05-01", "2021-05-31")))

mean(temps$surface_temp_c)
