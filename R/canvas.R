#' Quad canvas
#'
#' Create a simple quad mesh3d object
#'
#' Use `quad()` to create a mesh3d object with quad indexes to the vertices, this is
#' defined in the rgl package by [qmesh3d()][rgl::qmesh3d] and has elements
#' `vb` (the homogeneous coordinates 4xn) and `ib` (the quad index 4xn).
#'
#' Use `quad_texture()` to create a mesh3d object additionally with `texcoords` and
#' `texture` properties.
#'
#' @section Deprecation note:
#'
#' Note that an early version used arguments 'depth' (to control [rgl::subdivision3d()]),
#' 'tex' to indicate that texture should be included, and 'texfile' a link to the texture file path.
#' Please now use [quad_texture()] for textures, and `dim` argument (length 1 or 2).
#'
#' @param dim dimensions of mesh (using [matrix()] and [image()] orientation)
#' @param unmesh if `TRUE` all vertices are expanded to every coordinate instance (see [break_mesh()])
#' @param texture file path to PNG image (may not exist)
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
quad <- function(dim = 1L, unmesh = FALSE, ...) {
  args <- list(...)
  if ("depth" %in% names(args)) warning("argument 'depth' is deprecated, use 'dim = '")
  if ("tex" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")
  if ("texfile" %in% names(args)) warning("argument 'tex' is deprecated, use 'quad_texture()")

  ## hidden feature if depth has length 2
  if (length(dim) < 2L) {
    dim <- c(dim, dim)
  }
  quad_(dim[1L], dim[2L])
}
#' @name quad
#' @export
quad_texture <- function(dim = 1L, texture = "") {
  x <- quad(dim)
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
## edge-pairs
.pr <- function(x) {
  cbind(x[-length(x)], x[-1])

}
## quad index in [1:nx,1:ny] - not compatible with the version above yet
ib_index <- function(nx = 1, ny = nx) {
  nc1 <- nx + 1L
  nr1 <- ny + 1L
  aa <- t(.pr(seq_len(nc1)))
  #(ind <- matrix(rbind(aa[1L, ], aa + nc1, aa[2L, ]), 4L))
  ind <- matrix(rbind(aa, aa[2:1, , drop = FALSE] + nc1), 4L)
  (ind0 <- as.integer(as.vector(ind) +
                       rep(seq(0, length = ny, by = nc1), each = 4L * nx)))
  matrix(ind0, nrow = 4L)
}
quad_ <- function(nx = 1, ny = nx) {
  # xy <- cbind(x = rep(seq(0, 1, length.out = ny + 1L), each = nx + 1),
  #             y = seq(0, 1, length.out = nx + 1L ))

  xy <- cbind(x = seq(0, 1, length.out = nx + 1L),
              y = rep(seq(0, 1, length.out = ny + 1L ), each = nx + 1))


  rgl::qmesh3d(rbind(t(xy), z = 0, h = 1),
                    ib_index(nx, ny),
               material = list(color = "#FFFFFFFF"))

}

#' @importFrom graphics text
plot_qd <- function(nx = 1, ny = 1) {
  q <- quad_(nx, ny)
  plot(t(q$vb[1:2, ]), type = "n", asp = 1)
  graphics::text(t(q$vb[1:2, ]), lab = seq_len(ncol(q$vb)))
}
