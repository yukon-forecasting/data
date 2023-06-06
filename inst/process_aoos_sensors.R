library(readr)
library(dplyr)
library(ggplot2)

#' Downloaded from
#' https://researchworkspace.com/project/8150629/folder/8150641/outputs
air_temp_path <- "./data/amatc/raw/2023/nome_air_temp-2023.csv"
sst_path <- "./data/environment-raw/2023/surface_temperature-2023.csv"
pice_temp_path <- "./data/environment-raw/2023/sea_ice_concentration-2023.csv"

# Read in
air_temp_data <- read_csv(air_temp_path)
sst_data <- read_csv(sst_path)
pice_data <- read_csv(pice_temp_path)

# Plots
ggplot(air_temp_data, aes(date, air_temperature_c)) +
  geom_line() +
  geom_point()

ggplot(sst_data, aes(date, surface_temp_c)) +
  geom_line() +
  geom_point()

ggplot(pice_data, aes(date, mean_sea_ice_percent)) +
  geom_line() +
  geom_point()

# Summarize
(amatc <- mean(air_temp_data$air_temperature_c))
(msstc <- mean(sst_data$surface_temp_c))
(pice <- mean(pice_data$mean_sea_ice_percent))
