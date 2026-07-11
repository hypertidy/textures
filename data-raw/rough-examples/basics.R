# https://twitter.com/mdsumner/status/1293483396182638592?s=20
# Tweet stream idea ....
#
# 1)
# a -texture on a flat quad (land+sea)
# b -scale quad coords to geography
# c -densify quad (internal vertices) to carry mapping
# d -add topography (terrain!)
#
# All from scratch, easy
#
# 2)
# - polygons of region (land)
# - triangulate (internal verts) for mapping
# - unscale coords to texture
# - add topography
#
# Needs bespoke code, still easy but a bit mysterious
#
# 2/2


tfile <- tempfile("ga_topo", fileext = ".rda")
if (!file.exists(tfile)) {
 download.file("https://github.com/hypertidy/textures/raw/master/data/ga_topo.rda", tfile, mode = "wb")
}
## ga_topo is an image array with basic raster metadata $img, $extent, $crs
ga_topo <- local({
  load(tfile)
  ga_topo
})

ex <- ga_topo$extent
crs <- ga_topo$crs
world <- do.call(cbind, maps::map(plot = FALSE)[c("x", "y")])
## create a flat quad
verts <- cbind(x = c(0, 1, 1, 0),
               y = c(0, 0, 1, 1),
               z = 0,h = 1)
quad <- rgl::qmesh3d(vertices = t(verts),
                     indices = matrix(c(1L, 2L, 3L, 4)),
                     texcoords = verts,
                     material = list(texture = tfile, color = rgb(1, 1, 1, 0)))

## write out the image
quad$material$texture <-  tempfile(fileext = ".png")
png::writePNG(ga_topo$img/255, quad$material$texture)
rgl::plot3d(quad)

## 1a
rgl::plot3d(quad)
## why doesn't this work?
anglr::mesh_plot(quad)

## 1b
## scale to geography
geo_quad <- quad
geo_quad$vb[1, ] <- scales::rescale(geo_quad$vb[1, ], to = ex[c("xmin", "xmax")])
geo_quad$vb[2, ] <- scales::rescale(geo_quad$vb[2, ], to = ex[c("ymin", "ymax")])

anglr::mesh_plot(geo_quad)
points(reproj::reproj(world, source = 4326, target = crs))
rgl::plot3d(geo_quad); rgl::points3d(reproj::reproj(world, source = 4326, target = crs))

## 1c
## why doesn't mesh_plot have the image in the map?
sqr <- function(x, n = 10) seq(x[1L], x[2L], length.out = n)
## these are centres
dgeoverts <- as.matrix(expand.grid(x = sqr(ex[c("xmin", "xmax")], n = 10),
                        y = sqr(ex[c("ymin", "ymax")], n = 10)))

## function to convert matrix to corner values (it's approx, but useful)
.vxy <- function (x, ...)
{
  dm <- dim(x)
  nr <- dm[1L]
  nc <- dm[2L]
  tl <- cbind(NA_integer_, rbind(NA_integer_, x))
  tr <- cbind(NA_integer_, rbind(x, NA_integer_))
  bl <- cbind(rbind(NA_integer_, x), NA_integer_)
  br <- cbind(rbind(x, NA_integer_), NA_integer_)
  .colMeans(matrix(c(tl, tr, bl, br), 4L, byrow = TRUE), m = 4L,
            n = (nr + 1L) * (nc + 1L), na.rm = TRUE)
}


dgeo_quad <- quad
dgeo_quad$vb <- rbind(x = .vxy(matrix(dgeoverts[,1], 10, 10)),
                      y = .vxy(matrix(dgeoverts[,2], 10, 10)),
                      z = 0, h = 1)
dgeo_quad$texcoords <- cbind(x = scales::rescale(dgeo_quad$vb[1, ]),
                             y = scales::rescale(dgeo_quad$vb[2, ]))
anglr::mesh_plot(dgeo_quad)
