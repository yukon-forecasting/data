url <- "ftp://ftp2.psl.noaa.gov/Datasets/ncep.reanalysis.dailyavgs/surface_gauss/skt.sfc.gauss.2021.nc"
out_path <- "~/tmp/skt.sfc.gauss.2021.nc"
# download.file(url, out_path)

library(ncdf4)

# load
skintemp <- nc_open(out_path)
get_msstc(skintemp, 2021)
