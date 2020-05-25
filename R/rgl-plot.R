#' Plot a PNG bitmap in 3D
#'
#' @param pngfile path to a PNG format image file
#' @param dim specify dimensions of quad grid see [quad()]
#'
#' @return returns a mesh3d with 1 quad and the image file textured to it,
#'  as a side effect creates a 3D interactive plot
#' @export
#'
#' @examples
#' file <- system.file("extdata/Rlogo.png", package = "textures")
#' png_plot3d(file)
png_plot3d <- function(pngfile, dim = c(1, 1), height = FALSE) {
  if (!file.exists(pngfile)) stop(sprintf("file '%s' does not exists", pngfile))
  v <- 0
  if (height) {
#    m <- .rgb_grey(png::readPNG(pngfile))
    m <- apply(png::readPNG(pngfile), 1:2, mean)
    m <- t(m[nrow(m):1, ])
    v <- .matrix_vxy(m)
    dim <- dim(m)
  }
  qm <- quad_texture(dim, texture = pngfile)
  qm$vb[3L, ] <- v
  rgl::plot3d(qm, axes = FALSE, xlab = "", ylab = "", zlab = "", back = "lines")
  set_scene(interactive = TRUE)
  invisible(qm)
}

.rgb_grey <- function(x) {
  v <- c(0.30, 0.59, 0.11 )
  x[,,1L] * v[1L] + x[,,2L] * v[2L] + x[,,3L] * v[3L]
}
## anglr:::vxy
.matrix_vxy <- function(x, ...) {
  dm <- dim(x)
  nr <- dm[1L]
  nc <- dm[2L]
  ## top left
  tl <- cbind(NA_integer_, rbind(NA_integer_, x))
  ## top right
  tr <- cbind(NA_integer_, rbind(x, NA_integer_))
  ## bottom left
  bl <- cbind(rbind(NA_integer_, x), NA_integer_)
  ## bottom right
  br <- cbind(rbind(x, NA_integer_), NA_integer_)

  .colMeans(matrix(c(tl, tr, bl, br), 4L, byrow = TRUE),
            m = 4L, n = (nr + 1L) * (nc + 1L),
            na.rm = TRUE)
}
