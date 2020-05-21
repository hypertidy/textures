#' Quad canvas
#'
#' Create a simple quad mesh3d object
#'
#' The `depth` of subdivision is passed directly to [rgl::subdivision3d()] and
#' by default is `0` (no subdivison is done). This means the number of quads is
#' `2^depth` - so be careful!
#'
#' @param depth depth to subdivide canvas by (default is `0` which gives one quad, see Details)
#' @param tex logical, whether to create `texcoords`
#' @param texfile if `tex` is `TRUE`, an optional file name (a temporary path is created, must be PNG if supplied)
#' @param unmesh if `TRUE` all vertices are expanded to every coordinate instance (see [break_mesh()])
#'
#' @return mesh3d with quads and material texture settings as per inputs
#' @export
#'
#' @examples
#' qm <- quad()
quad <- function(depth = 0, tex = TRUE, texfile = NULL, unmesh = FALSE) {
  x <- rgl::qmesh3d(rbind(x = c(0, 1, 0, 1),
                     y = c(0, 0, 1, 1),
                     z = c(0, 0, 0, 0),
                     h = c(1, 1, 1, 1)),
               matrix(c(1L, 2L, 4L, 3L), nrow = 4L), material = list(color = "#FFFFFFFF"))

 if (tex) {
    x$texcoords <- x$vb[1:2, ]
    if (is.null(texfile)) texfile <- tempfile(fileext = ".png")
    x$material$texture <- texfile

  }
  x <- rgl::subdivision3d(x, depth = depth, normalize = TRUE, deform = FALSE)
  if (unmesh) {
    x <- break_mesh(x)
  }
  x
}
