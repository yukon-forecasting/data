% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msstc_old.R
\name{get_lat_index}
\alias{get_lat_index}
\title{Get the index for a given latitude}
\usage{
get_lat_index(nc, target_lat = 63.1)
}
\arguments{
\item{nc}{A NetCDF file}

\item{target_lat}{Optional. The latitude to find an index nearest to}
}
\value{
(numeric) A vector of latitude indices
}
\description{
Get the index for a given latitude
}
