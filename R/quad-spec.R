#' Compact quad mesh specification
#'
#' A quad mesh on a regular grid is completely determined by a tiny
#' recipe: the grid dimension, its extent, and the y orientation.
#' `quad_spec()` records that recipe as a plain, serializable list
#' without materializing any vertices or indexes.
#'
#' `quad_mesh()` materializes the specification as a 'mesh3d' object
#' (as used by the 'rgl' package, but constructed without it). If the
#' spec carries a `texture` image file path, texture coordinates are
#' included: these are the extent-normalized vertex coordinates, so
#' they remain valid for any mesh whose vertices lie in the extent.
#'
#' With the 'rgl' package installed, `as.mesh3d()` works directly on a
#' quad_spec (registered on-demand, 'rgl' is not required).
#'
#' The mesh density given by `dimension` is independent of the pixel
#' dimension of any `texture` image: a coarse mesh may carry a
#' full-resolution image, the graphics engine interpolates within each
#' quad.
#'
#' @param dimension number of cells in the grid (nx, ny), a single value
#'  is recycled
#' @param extent extent of the grid `c(xmin, xmax, ymin, ymax)`, default
#'  is the unit square
#' @param ydown should the y coordinate be counted from the top, default
#'  `FALSE`
#' @param crs optional coordinate reference system, stored but not used
#'  by textures itself
#' @param texture optional file path to a PNG image to texture onto the
#'  mesh when materialized
#' @param x a quad_spec object
#' @param ... ignored, or passed between methods
#' @return `quad_spec()` a list with class 'quad_spec', `quad_mesh()` a
#'  mesh3d object, the print method returns its input invisibly
#' @export
#' @examples
#' spec <- quad_spec(c(20, 10), extent = c(100, 160, -60, -30))
#' spec
#' mesh <- quad_mesh(spec)
#' str(mesh$vb)
quad_spec <- function(dimension = c(1L, 1L), extent = NULL, ydown = FALSE,
                      crs = NULL, texture = NULL) {
  dimension <- .check_dimension(dimension)
  if (!is.null(extent)) {
    extent <- as.numeric(extent)
    stopifnot(length(extent) == 4L)
  }
  if (!is.null(texture)) {
    texture <- as.character(texture[1L])
    if (!file.exists(texture)) warning(sprintf("texture file '%s' does not exist", texture))
  }
  structure(list(dimension = dimension, extent = extent,
                 ydown = isTRUE(ydown), crs = crs, texture = texture),
            class = "quad_spec")
}

#' @name quad_spec
#' @export
quad_mesh <- function(x, ...) {
  UseMethod("quad_mesh")
}

#' @name quad_spec
#' @export
quad_mesh.quad_spec <- function(x, ...) {
  xy <- quad_vertex(x$dimension, extent = x$extent, ydown = x$ydown)
  vb <- rbind(t(xy), z = 0, h = 1)
  dimnames(vb) <- NULL
  ib <- quad_index(x$dimension, ydown = x$ydown)
  mesh <- .mesh3d_quads(vb, ib)
  if (!is.null(x$texture)) {
    tex <- quad_vertex(x$dimension, extent = NULL, ydown = x$ydown)
    mesh$texcoords <- t(tex)
    dimnames(mesh$texcoords) <- NULL
    mesh$material$texture <- x$texture
  }
  mesh
}

#' @name quad_spec
#' @exportS3Method rgl::as.mesh3d
as.mesh3d.quad_spec <- function(x, ...) {
  quad_mesh(x, ...)
}

#' @name quad_spec
#' @export
print.quad_spec <- function(x, ...) {
  extent <- x$extent
  if (is.null(extent)) extent <- c(0, 1, 0, 1)
  cat("<quad_spec>\n")
  cat(sprintf("  dimension : %i x %i cells (%s vertices)\n",
              x$dimension[1L], x$dimension[2L],
              format((x$dimension[1L] + 1) * (x$dimension[2L] + 1.0),
                     big.mark = ",", scientific = FALSE)))
  cat(sprintf("  extent    : %s (xmin, xmax, ymin, ymax)\n",
              paste(format(extent, trim = TRUE), collapse = ", ")))
  cat(sprintf("  ydown     : %s\n", x$ydown))
  if (!is.null(x$crs)) cat(sprintf("  crs       : %s\n", x$crs))
  if (!is.null(x$texture)) cat(sprintf("  texture   : %s\n", x$texture))
  invisible(x)
}
