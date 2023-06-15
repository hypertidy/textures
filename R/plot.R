#' Plot (2D) for mesh3d
#'
#'
#' @param x mesh3d object (with any or all of quads, triangles, segments)
#'
#' @return nothing, called for side effect of graphics
#' @export
#'
#' @examples
plot.mesh3d <- function(x,  ..., asp = 1, add = FALSE, axes = TRUE, border = "black", col = NA, alpha = 1, lwd = 1, lty = 1) {
  #if (!add) plot(t(x$vb[1:2, ]), type = "n", asp = asp)
  ## FIXME to get colours we'll have to grab from $material and use gridBase
  #if (!is.null(x$is))  lines(t(x$vb[1:2, rbind(x$is, NA)]))
  #if (!is.null(x$ib))  polygon(t(x$vb[1:2, rbind(x$ib, NA)]))


  if ( names(dev.cur()) == "null device" || !add) plot(t(x$vb[1:2, ]), type = "n", asp = asp, xlab = "", ylab = "", axes = axes)
  vps <- gridBase::baseViewports()
  grid::pushViewport(vps$inner, vps$figure, vps$plot)

  if (!is.null(x$ib)) {

    xx <- x$vb[1L, rbind(x$ib, x$ib[1L, ])]
    yy <- x$vb[2L, rbind(x$ib, x$ib[1L, ])]
    # if (is.na(col)) {
    #   if (!is.null(x$material$color) && x$meshColor = "faces") {
    #     col <- rep(x$material$color, (xx))[x$ib]
    #   }
    # }

  grid::grid.polygon(xx, yy, rep(seq_len(ncol(x$ib)), each = 5L), gp = grid::gpar(col = border, fill = col, alpha = alpha, lwd = lwd, lty = lty),
                     default.units = "native")
  }

  if (!is.null(x$it)) {

    xx <- x$vb[1L, rbind(x$ib, rbind(x$it, x$it[1L, ]))]
    yy <- x$vb[2L, rbind(x$ib, rbind(x$it, x$it[1L, ]))]
    # if (is.na(col)) {
    #   if (!is.null(x$material$color) && x$meshColor = "faces") {
    #     col <- rep(x$material$color, (xx))[x$ib]
    #   }
    # }

    grid::grid.polygon(xx, yy, rep(seq_len(ncol(x$it)), each = 4L), gp = grid::gpar(col = border, fill = col, alpha = alpha, lwd = lwd, lty = lty),
                       default.units = "native")
  }

  if (!is.null(x$is)) {

    xx <- x$vb[1L, x$is]
    yy <- x$vb[2L, x$is]

    if (is.null(col) || is.na(col[1L])) {
      col <- border
    }
    grid::grid.polyline(xx, yy, id = rep(seq_len(ncol(x$is)), each = 2L),  gp = grid::gpar(col = col,  alpha = alpha, lwd = lwd, lty = lty),
                       default.units = "native")
  }


  grid::popViewport(3)
  if (is.null(x$is) && is.null(x$it) && is.null(x$ib)) {
    points(t(x$vb[1:2, ]), col = col)
  }

  invisible(NULL)
}
