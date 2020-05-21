#' un mesh
#'
#' Break the topology of a mesh by expanding all vertices.
#'
#' Details ... rgl is inherently _topological_, but we can have primitives
#' that are geometrically independent. (One day I'll find a way to talk
#' about this that's not garble.)
#' @param x mesh3d, from e.g. `quad()`
#'
#' @return mesh3d
#' @export
#'
#' @examples
#' (mesh <- quad(depth = 3))
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
