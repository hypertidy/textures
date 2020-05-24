#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @useDynLib textures, .registration = TRUE
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL

#' Topographic image
#'
#' Image of Australia as a map, its extent, and map projection.
#'
#' (It's web Mercator, aka 'EPSG:3857'. We've kept the proj string because
#' it's the easiest to use atm - May 2020.)
#'
#' @section Provenance:
#'
#' Copyright Commonwealth of Australia (Geoscience Australia) 2016. Creative
#' Commons Attribution 4.0 International Licence.
#'
#' The image is named 'Australian Topographic Base Map (Web Mercator)' and is
#' from the following Geoscience Australia Web Map Tile Service (WMTS):
#' \url{http://gaservices.ga.gov.au/site_7/rest/services/Topographic_Base_Map_WM/MapServer}.
#'
#' Code to obtain the image is in 'data-raw/ga_topo.R' at {https://github.com/hypertidy/textures}
#' using the wmts package \url{https://github.com/mdsumner/wmts}.
#'
#' @name ga_topo
#' @docType data
#' @format A list with an array, a numeric vector, and a character vector:
#' \describe{
#'   \item{img}{image array with dimension 921,1025,3 - three slices Red, Green, Blue}
#'   \item{extent}{the geographic extent of the array, in metres}
#'   \item{crs}{the map projection of the geographic extent of `img`}
#' }
"ga_topo"

