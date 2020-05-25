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
#' Please now use [quad_texture()] for textures, and `dim` argument (length 1 or 2),
#' and [break_mesh()].
#'
#' @param dim dimensions of mesh (using [matrix()] and [image()] orientation)
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
quad <- function(dim = c(1L, 1L), ydown = FALSE, ...) {
  args <- list(...)
  if ("depth" %in% names(args)) warning("argument 'depth' is deprecated, use 'dim = '")
  if ("tex" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")
  if ("texfile" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")
  if ("unmesh" %in% names(args)) warning("argument 'unmesh' is deprecated, use 'break_mesh()")
  if (length(dim) == 1L) {
    dim <- c(dim, dim)
  }
  quad_cpp(dim[1L], dim[2L], ydown = ydown)
}
#' @name quad
#' @export
quad_texture <- function(dim = c(1L, 1L), ydown = FALSE, texture = "") {
  x <- quad(dim, ydown = ydown)
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

quad_cpp <- function(nx = 1, ny = nx, ydown = FALSE) {
  xy <- matrix(quad_vertex_cpp(nx, ny, ydown = ydown), 2L) #, ydown = ydown)
  rgl::qmesh3d(rbind(xy, z = 0, h = 1),
               matrix(quad_index_cpp(nx, ny, ydown = ydown) + 1L, 4L), #, ydown = ydown),
               material = list(color = "#FFFFFFFF"))

}



