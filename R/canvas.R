#' Quad canvas
#'
#' Create a simple quad mesh3d object
#'
#' The `depth` of subdivision is passed directly to [rgl::subdivision3d()] and
#' by default is `0` (no subdivion is done). This means the number of quads is
#' `2^depth` - so be careful!
#' @param depth depth to subdivide canvas by (default is `0` which gives one quad, see Details)
#' @param tex logical, whether to create `texcoords`
#' @param texfile if `tex` is `TRUE`, an optional file name (a temporary path is created, must be PNG if supplied)
#'
#' @return
#' @export
#'
#' @examples
#' qm <- quad()
quad <- function(depth = 0, tex = TRUE, texfile = NULL) {
  suppressWarnings(quad0 <- anglr::as.mesh3d(matrix(0, 1))) ## to be fixed
  if (tex) {
    quad0$texcoords <- quad0$vb[1:2, ]
    if (is.null(texfile)) texfile <- tempfile(fileext = ".png")
    quad0$material$texture <- tfile

  }
  rgl::subdivision3d(quad0, depth = depth)
}
