#' @export
#' @name quad
segs <- function(dimension = c(1L, 1L), extent = NULL, ydown = FALSE, ...) {
  mesh <- quad(dimension, extent, ydown)
  ib <- mesh$ib
  allseg <- cbind(ib[1:2, ], ib[2:3, ], ib[3:4, ], ib[c(4, 1), ])
  dup <- duplicated(pmax(paste(allseg[1, ], allseg[2, ], sep = "-"),
                         paste(allseg[2, ], allseg[1, ], sep = "-")))

  mesh$is <- allseg[, !dup]
  mesh$ib <- NULL
  mesh
}

