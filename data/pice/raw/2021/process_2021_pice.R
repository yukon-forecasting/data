library(readr)
library(dplyr)
library(lubridate)
library(tidyr)

ice_raw <- read_csv("data/pice/raw/2021/sea_ice_concentration-2021.csv")

ice_raw %>%
  mutate(date = lubridate::date(date)) %>%
  filter(date %in% seq(as.Date("2021-03-20"), as.Date("2021-05-31"), by = "day")) -> ice


stopifnot(all(range(ice$date) == c("2021-03-20", "2021-05-31")))

mean(ice$mean_sea_ice_percent)
