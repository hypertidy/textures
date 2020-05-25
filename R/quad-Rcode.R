## R-versions of quad_index_cpp, quad_vertex_cpp
#' @importFrom graphics text
plot_qd <- function(dim = c(1, 1), ydown = FALSE) {
  q <- quad_(dim[1], dim[2], ydown = ydown)
  plot(t(q$vb[1:2, ]), type = "n", asp = 1)
  graphics::text(t(q$vb[1:2, ]), lab = seq_len(ncol(q$vb)))
}




## edge-pairs
.pr <- function(x) {
  cbind(x[-length(x)], x[-1])

}
ib_index <- function(nx = 1, ny = nx, ydown = FALSE) {
  nc1 <- nx + 1L
  nr1 <- ny + 1L
  aa <- t(.pr(seq_len(nc1)))
  #(ind <- matrix(rbind(aa[1L, ], aa + nc1, aa[2L, ]), 4L))
  ind <- matrix(rbind(aa, aa[2:1, , drop = FALSE] + nc1), 4L)
  (ind0 <- as.integer(as.vector(ind) +
                        rep(seq(0, length = ny, by = nc1), each = 4L * nx)))
  out <- matrix(ind0, nrow = 4L)
  if (ydown) {
    ## we have to reverse the order so they are anti-clockwise
    ## can vis this with material3d(back = "lines")
    out <- out[4:1, , drop = FALSE]
  }
  out
}
vb_vertex <- function(nx = 1L, ny = nx, ydown = FALSE) {
  ## here we could reverse y and be raster-aligned?
  ymin <- 0
  ymax <- 1
  if (ydown) {
    ymax <- 0; ymin <- 1
  }
  cbind(x = seq(0, 1, length.out = nx + 1L),
        y = rep(seq(ymin, ymax, length.out = ny + 1L ), each = nx + 1))

}
quad_ <- function(nx = 1, ny = nx, ydown = FALSE) {
  xy <- vb_vertex(nx, ny, ydown = ydown)
  rgl::qmesh3d(rbind(t(xy), z = 0, h = 1),
               ib_index(nx, ny, ydown = ydown),
               material = list(color = "#FFFFFFFF"))
}

