library(dplyr)
library(ggplot2)
library(tidyr)

master <- read.csv("data/msstc/derived/msstc.csv")
updated <- read.csv("data/derived/msstc/msstc.csv")
environment_file <- read.csv("data/environment/environment.csv")

master_modified <- master |>
  select(year, msstc_master = msstc)

updated_modified <- updated |>
  select(year, msstc_updated = msstc)

environment_file_modified <- environment_file |>
  select(year, msstc_environment_file = msstc)

together <- full_join(master_modified, updated_modified) |>
  mutate(diff_master_vs_updated = msstc_master - msstc_updated)

together <- together |>
  full_join(environment_file_modified) |>
  mutate(diff_environment_vs_updated = msstc_environment_file - msstc_updated) |>
  select(year, msstc_master, msstc_updated, msstc_environment_file)


together |>
  pivot_longer(-year) |>
  ggplot(aes(year, value, color = name, linetype = name)) +
  geom_line()
