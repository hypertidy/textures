#' Break mesh, expand vertex instances
#'
#' Break the topology of a mesh by expanding all vertices.
#'
#' Data in a mesh and in rgl is inherently _topological_, but we can have
#' primitives that independent, out of an original mesh. Expanding every vertex
#' makes primitives geometrically independent, so attributes (colours, texture
#' coordinates) can be constant per face rather than interpolated between shared
#' vertices - the *discrete* rendering of a *continuous* mesh, at the cost of
#' four times the vertices. This is the `dquadmesh` idea from quadmesh package.
#'
#' @param x mesh3d, from e.g. `quad()`
#'
#' @return mesh3d
#' @export
#' @family textures
#' @examples
#' (mesh <- quad(c(3, 3)))
#' ## same number of primitives, more vertices (every coordinate)
#' break_mesh(mesh)
break_mesh <- function(x) {
  index <- x[["ib"]]
  quad <- TRUE
  if (is.null(index)) {
    index <- x[["it"]]
    quad <- FALSE
  }
  x$vb <- x$vb[, index]
  if (!is.null(x[["texcoords"]])) {
    x$texcoords <- x$texcoords[, index]
  }
  newindex <- matrix(seq_along(x$vb[1L, ]), dim(index)[1L])
  if (quad) {
    x[["ib"]] <- newindex
  } else {
    x[["it"]] <- newindex
  }

  x
}
