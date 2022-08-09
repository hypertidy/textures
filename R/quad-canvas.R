#' Quad canvas
#'
#' Create a simple quad mesh3d object
#'
#' Use `quad()` to create a mesh3d object with quad indexes to the vertices, this is
#' defined in the rgl package by [qmesh3d()][rgl::qmesh3d] and has elements
#' `vb` (the homogeneous coordinates 4xn) and `ib` (the quad index 4xn).
#'
#' The `meshColor` is currently hardcoded as 'vertices'.
#'
#' Use `quad_texture()` to create a mesh3d object additionally with `texcoords` and
#' `texture` properties.
#'
#' @section Deprecation note:
#'
#' Note that an early version used arguments 'depth' (to control [rgl::subdivision3d()]),
#' 'tex' to indicate that texture should be included, 'texfile' a link to the texture file path,
#' and 'unmesh' to remove topology by expanding the vertices
#' .
#' Please now use [quad_texture()] for textures, and `dimension` argument (length 1 or 2),
#' and [break_mesh()].
#'
#' @param dimension dimensions of mesh (using [matrix()] and [image()] orientation)
#' @param extent optional extent of mesh xmin, xmax, ymin, ymax
#' @param texture file path to PNG image (may not exist)
#' @param ydown should y-coordinate be counted from top (default `FALSE`)
#' @param ... used only to warn about old usage
#' @return mesh3d with quads and material texture settings as per inputs
#' @export
#' @aliases quad_texture
#' @examples
#' qm <- quad()
#' ## orientation is low to high, x then y
#' qm <- quad(dim(volcano))
#' scl <- function(x) (x - min(x, na.rm = TRUE))/diff(range(x, na.rm = TRUE))
#' qm$meshColor <- "faces"
#' qm$material$color <- hcl.colors(12, "YlOrRd", rev = TRUE)[scl(volcano) * 11 + 1]
#' rgl::plot3d(qm)
quad <- function(dimension = c(1L, 1L), extent = NULL, ydown = FALSE, ...) {
  args <- list(...)

  # if ("tex" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")
  # if ("texfile" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")
  # if ("unmesh" %in% names(args)) warning("argument 'unmesh' is deprecated, use 'break_mesh()")
  if (length(dimension) == 1L) {
   dimension <- c(dimension, dimension)
  }
  out <- quad_cpp(as.integer(dimension[1L]), as.integer(dimension[2L]), ydown = ydown, zh = TRUE)
  if (!is.null(extent)) {
    out$vb[1L, ] <- scales::rescale(out$vb[1L, ], extent[1:2])
    out$vb[2L, ] <- scales::rescale(out$vb[1L, ], extent[3:4])
  }
  out
}
#' @name quad
#' @export
quad_texture <- function(dimension = c(1L, 1L), ydown = FALSE, texture = "") {
  x <- quad(dimension, ydown = ydown)
  x$texcoords <- x$vb[1:2, ]
  if (nchar(texture) == 1L) {
    warning("no texture file given")
  }
  if (!file.exists(texture)) {
    warning("texture file given does not exist")
  }
  x$material$texture <- texture
 x
}

plot.mesh3d <- function(x) {
  ib <- x$ib
  vb <- t(x$vb)
  plot(vb, type = "n", asp = 1)
  graphics::text(vb, lab = seq_len(nrow(vb)))
}

quad_cpp <- function(nx = 1, ny = nx, ydown = FALSE, zh = TRUE) {
  xyzh <- quad_vertex_matrix_cpp(nx, ny, ydown = ydown, zh = zh)
  rgl::qmesh3d(xyzh,
               matrix(quad_index_cpp(nx, ny, ydown = ydown) + 1L, 4L), #, ydown = ydown),
               material = list(color = "#FFFFFFFF"))

}



