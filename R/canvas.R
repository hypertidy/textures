#' Quad canvas
#'
#' Create a simple quad mesh3d object
#'
#' The `depth` of subdivision is passed directly to [rgl::subdivision3d()] and
#' by default is `0` (no subdivison is done). This means the number of quads is
#' `2^depth` - so be careful!
#'
#' @param depth depth to subdivide canvas by (default is `0` which gives one quad, see Details)
#' @param tex logical, whether to create `texcoords`
#' @param texfile if `tex` is `TRUE`, an optional file name (a temporary path is created, must be PNG if supplied)
#' @param unmesh if `TRUE` all vertices are expanded to every coordinate instance (see [break_mesh()])
#'
#' @return mesh3d with quads and material texture settings as per inputs
#' @export
#'
#' @examples
#' qm <- quad()
quad <- function(depth = 0, tex = TRUE, texfile = NULL, unmesh = FALSE) {
  ## hidden feature if depth has length 2
  if (length(depth) == 2L) {
    x <- quad_(depth[1L], depth[2L])
  } else {
    x <- rgl::qmesh3d(rbind(x = c(0, 1, 0, 1),
                     y = c(0, 0, 1, 1),
                     z = c(0, 0, 0, 0),
                     h = c(1, 1, 1, 1)),
               matrix(c(1L, 2L, 4L, 3L), nrow = 4L), material = list(color = "#FFFFFFFF"))
}
 if (tex) {
    x$texcoords <- x$vb[1:2, ]
    if (is.null(texfile)) texfile <- tempfile(fileext = ".png")
    x$material$texture <- texfile

  }
  if (length(depth) == 1L) x <- rgl::subdivision3d(x, depth = depth, normalize = TRUE, deform = FALSE)
  if (unmesh) {
    x <- break_mesh(x)
  }
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

plot_qd <- function(nx = 1, ny = 1) {
  q <- quad_(nx, ny)
  plot(t(q$vb[1:2, ]), type = "n", asp = 1)
  text(t(q$vb[1:2, ]), lab = seq_len(ncol(q$vb)))
}
