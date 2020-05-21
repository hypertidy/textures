#' rgl defaults
#'
#' Quick defaults for rgl static plot
#'
#' This function sets the size of the window to 1024x1024, sets the view position
#' at directly vertical `phi = 0, theta = 0`, makes the view non-interactive
#' (zoom is enabled, but no pivot or pan). It turns off the lights and puts a
#' new light in front of the viewer (to avoid shiny glare), sets the aspect
#' ratio to 'iso' ("fill the box"), and attempts to 'bringtotop', but I think that
#' has to happen interactively with `rgl::rgl.bringtotop()` (especially for
#' animating or snapshotting scenes to file).
#'
#' @param interactive mouse interactive plot, default `FALSE`
#' @param zoom zoom for [rgl::view3d] default `0.5` which is closer than rgl 1
#'
#' @return nothing
#' @export
#' @importFrom rgl par3d view3d pop3d aspect3d rgl.bringtotop
#' @examples
#' ## see README and in-dev examples in rough-examples.R
#' rgl::plot3d(rnorm(10), rnorm(10), rnorm(1)); set_scene()
set_scene <- function(interactive = FALSE, zoom = 0.5) {
  rgl::par3d(windowRect = c(0, 0, 1024, 1024))
  rgl::view3d(phi = 0, interactive = interactive, zoom = zoom)
  rgl::pop3d(type = "lights")
  rgl::light3d(phi = -45)
  rgl::aspect3d("iso")
  rgl::rgl.bringtotop()
 invisible(NULL)
}
