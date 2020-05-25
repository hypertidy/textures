#' Plot a PNG bitmap in 3D
#'
#' @param pngfile path to a PNG format image file
#' @param dim specify dimensions of quad grid see [quad()]
#'
#' @return returns a mesh3d with 1 quad and the image file textured to it,
#'  as a side effect creates a 3D interactive plot
#' @export
#'
#' @examples
#' file <- system.file("extdata/Rlogo.png", package = "textures")
#' png_plot3d(file)
png_plot3d <- function(pngfile, dim = c(1, 1)) {
  if (!file.exists(pngfile)) stop(sprintf("file '%s' does not exists", pngfile))
  qm <- quad_texture(dim, texture = pngfile)
  rgl::plot3d(qm, axes = FALSE, xlab = "", ylab = "", zlab = "", back = "lines")
  set_scene(interactive = TRUE)
  invisible(qm)
}
