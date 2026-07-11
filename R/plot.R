#' Plot (2D) for mesh3d
#'
#' Draws the x-y geometry of a mesh in base graphics: quads (`ib`) and
#' triangles (`it`) as polygons, segments (`is`) as lines, and bare
#' vertices as points when no primitives are present.
#'
#' @param x mesh3d object (with any or all of quads, triangles, segments)
#' @param ... ignored
#' @param asp aspect ratio, default 1
#' @param add add to an existing plot, default `FALSE`
#' @param axes draw axes (when starting a new plot), default `TRUE`
#' @param border border colour for polygons, default 'black'
#' @param col fill colour for polygons (line colour for segments), default `NA`
#' @param alpha transparency in `[0, 1]`, default 1 (opaque)
#' @param lwd line width
#' @param lty line type
#' @return the input mesh, invisibly, called for the side effect of graphics
#' @export
#' @examples
#' plot(quad(c(5, 4), extent = c(0, 10, 0, 8)))
plot.mesh3d <- function(x, ..., asp = 1, add = FALSE, axes = TRUE,
                        border = "black", col = NA, alpha = 1,
                        lwd = 1, lty = 1) {
  xy <- t(x$vb[1:2, , drop = FALSE])
  if (grDevices::dev.cur() == 1L || !add) {
    plot(xy, type = "n", asp = asp, xlab = "", ylab = "", axes = axes)
  }
  if (!is.na(alpha) && alpha < 1) {
    border <- grDevices::adjustcolor(border, alpha)
    if (!all(is.na(col))) col <- grDevices::adjustcolor(col, alpha)
  }
  if (!is.null(x$ib)) {
    idx <- rbind(x$ib, NA)
    graphics::polygon(x$vb[1L, idx], x$vb[2L, idx],
                      border = border, col = col, lwd = lwd, lty = lty)
  }
  if (!is.null(x$it)) {
    idx <- rbind(x$it, NA)
    graphics::polygon(x$vb[1L, idx], x$vb[2L, idx],
                      border = border, col = col, lwd = lwd, lty = lty)
  }
  if (!is.null(x$is)) {
    linecol <- if (is.null(col) || all(is.na(col))) border else col
    graphics::segments(x$vb[1L, x$is[1L, ]], x$vb[2L, x$is[1L, ]],
                       x$vb[1L, x$is[2L, ]], x$vb[2L, x$is[2L, ]],
                       col = linecol, lwd = lwd, lty = lty)
  }
  if (is.null(x$is) && is.null(x$it) && is.null(x$ib)) {
    graphics::points(xy, col = col)
  }
  invisible(x)
}
