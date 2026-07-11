## does the index for this grid need double storage?
.needs_double_index <- function(dimension) {
  nx <- as.double(dimension[1L])
  ny <- as.double(dimension[2L])
  nverts <- (nx + 1) * (ny + 1)
  nindex <- nx * ny * 4
  nverts > .Machine$integer.max || nindex > .Machine$integer.max
}

.check_dimension <- function(dimension) {
  dimension <- rep(as.integer(round(dimension)), length.out = 2L)
  if (anyNA(dimension)) stop("missing 'dimension' value")
  if (any(dimension < 1L)) stop("'dimension' values must be >= 1")
  dimension
}

## construct a mesh3d list without requiring rgl
## (element order matches rgl::qmesh3d output)
.mesh3d_quads <- function(vb, ib, material = list(color = "#FFFFFFFF")) {
  structure(list(vb = vb, material = material, normals = NULL,
                 texcoords = NULL, meshColor = "vertices", ib = ib),
            class = c("mesh3d", "shape3d"))
}

## linear rescale of x to range 'to' (replaces scales::rescale)
.rescale <- function(x, to) {
  from <- range(x, na.rm = TRUE)
  if (!all(is.finite(from))) stop("cannot rescale non-finite range")
  if (diff(from) == 0) return(rep(mean(to), length(x)))
  (x - from[1L]) / diff(from) * diff(to) + to[1L]
}

#' Quad mesh primitives
#'
#' Generate the components of a quad mesh from the compact specification of
#' a regular grid: the `dimension` (number of cells nx, ny) and optionally
#' the `extent` (xmin, xmax, ymin, ymax).
#'
#' `quad_index()` gives the index of the four corner vertices of every
#' cell, a 4 x (nx * ny) matrix of 1-based vertex indexes. Quads are in
#' cell order, x fastest (the [matrix()] and [image()] convention, and
#' raster cell order when `ydown = TRUE`). Winding is counter-clockwise
#' for y-up grids.
#'
#' `quad_edges()` gives the unexpanded form of the vertices, the x and y
#' coordinates of the cell edges as two vectors of length nx + 1 and
#' ny + 1. This is the compact intermediate: the full vertex set is their
#' outer expansion, and for many purposes (transform bounds, axis
#' coordinates, texture alignment) the margins are all that is needed.
#'
#' `quad_vertex()` gives the materialized vertices, a (nx + 1) * (ny + 1)
#' row matrix of x, y coordinates, x fastest, matching the index in
#' `quad_index()`.
#'
#' For very large grids where the vertex count or index length exceeds
#' the integer maximum, `quad_index()` returns a matrix of doubles
#' (exact for integer values to 2^53), which R subsetting and 'mesh3d'
#' usage accept natively. Take care not to apply [as.integer()] to such
#' an index.
#'
#' @param dimension number of cells in the grid (nx, ny), a single value
#'  is recycled
#' @param extent extent of the grid `c(xmin, xmax, ymin, ymax)`, default
#'  is the unit square
#' @param ydown should the y coordinate be counted from the top (image/raster
#'  orientation), default `FALSE`
#' @return `quad_index()` a 4-row matrix of vertex indexes (integer, or
#'  double for very large grids), `quad_edges()` a list with `x` and `y`
#'  edge coordinate vectors, `quad_vertex()` a 2-column matrix of vertex
#'  coordinates
#'  @family textures
#' @export
#' @examples
#' quad_index(c(2, 3))
#' quad_edges(c(2, 3), extent = c(0, 10, 0, 20))
#' quad_vertex(c(2, 3), extent = c(0, 10, 0, 20))
quad_index <- function(dimension, ydown = FALSE) {
  dimension <- .check_dimension(dimension)
  ydown <- isTRUE(ydown)
  if (.needs_double_index(dimension)) {
    idx <- quad_index_dbl_cpp(as.double(dimension[1L]),
                              as.double(dimension[2L]), ydown) + 1
  } else {
    idx <- quad_index_cpp(dimension[1L], dimension[2L], ydown) + 1L
  }
  dim(idx) <- c(4, length(idx) / 4)
  idx
}

#' @name quad_index
#' @export
quad_edges <- function(dimension, extent = NULL, ydown = FALSE) {
  dimension <- .check_dimension(dimension)
  if (is.null(extent)) extent <- c(0, 1, 0, 1)
  x <- seq(extent[1L], extent[2L], length.out = dimension[1L] + 1L)
  y <- seq(extent[3L], extent[4L], length.out = dimension[2L] + 1L)
  if (isTRUE(ydown)) y <- rev(y)
  list(x = x, y = y)
}

#' @name quad_index
#' @export
quad_vertex <- function(dimension, extent = NULL, ydown = FALSE) {
  edges <- quad_edges(dimension, extent = extent, ydown = ydown)
  cbind(x = rep(edges$x, times = length(edges$y)),
        y = rep(edges$y, each = length(edges$x)))
}
