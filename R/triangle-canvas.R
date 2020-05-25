triangle <- function() {
  rgl::tmesh3d(rbind(x = c(0, 1, 0.5), y = c(0, 0, sin(pi/3)),
                     z = 0, h = 1),
               matrix(c(1L, 2L, 3L)), meshColor = "faces")
}
