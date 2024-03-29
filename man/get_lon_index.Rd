% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msstc.R
\name{get_lon_index}
\alias{get_lon_index}
\title{Get the index for a given longitude}
\usage{
get_lon_index(nc, target_lon = 165.5)
}
\arguments{
\item{nc}{A NetCDF file}

\item{target_lon}{Optional. The longitude to find an index nearest to}
}
\value{
(numeric) A vector of longitude indices
}
\description{
Get the index for a given longitude
}
