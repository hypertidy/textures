#' rgl defaults
#'
#' Quick defaults for rgl static plot
#'
#' @param interactive mouse interactive plot, default `FALSE`
#' @param zoom zoom for [rgl::view3d] default `0.5` which is closer than rgl 1
#'
#' @return nothing
#' @export
#'
#' @examples
#' ## see README and in-dev examples
#' plot3d(rnorm(10), rnorm(10), rnorm(1)); set_scene()
set_scene <- function(interactive = FALSE, zoom = 0.5) {
  rgl::par3d(windowRect = c(0, 0, 1024, 1024))

  rgl::view3d(phi = 0, interactive = interactive, zoom = zoom)
  rgl.pop(type = "lights")
  light3d(phi = -45)
  aspect3d("iso")
  rgl::rgl.bringtotop()

}
