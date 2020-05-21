library(textures)
library(rgl)
library(anglr)
laea <- "+proj=laea +lon_0=120 +lat_0=-28"
## a polygon map we can keep our bearings with
aus <- subset(simpleworld, sovereignt == "Australia")
aus_merc <- sp::spTransform(aus, ga_topo$crs)
aus_wire <- copy_down(DEL0(aus_merc), 1000)

# 1. absolutely simplest native coordinate texture
# -----------------------------------------------
tfile <- tempfile(fileext = ".png")
png::writePNG(ga_topo$img/255, tfile)
quad0 <- quad(texfile = tfile)

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])


rgl::plot3d(quad0, specular = "black");
wire3d(aus_wire, add = TRUE)
set_scene()


# 2. reproject the canvas from the single quad above
# ---------------------------------------------------
## now do the same but we reproject x,y to something non-native for the image
## (it won't work very well)

quad0$vb[1:2, ] <- t(reproj::reproj(t(quad0$vb[1:2, ]), target = laea,
                                 source = ga_topo$crs)[,1:2])

## it *looks ok* but if we overplot you'll see the problem
rgl::plot3d(quad0, specular = "black");
wire3d(reproj::reproj(aus_wire, laea), add = T)

set_scene()

# 3. densify the canvas prior to reprojection (obviously)
# -------------------------------------------------------
## now let's subdivide the canvas
quad0 <- quad(texfile = tfile, depth = 6)

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])
quad0$vb[1:2, ] <- t(reproj::reproj(t(quad0$vb[1:2, ]), target = laea,
                                    source = ga_topo$crs)[,1:2])

## back in business
rgl::plot3d(quad0, specular = "black")
wire3d(reproj::reproj(aus_wire, laea), add = T)
set_scene()


# 4. break the mesh and explode a bit
# -------------------------------------------------------
tfile <- tempfile(fileext = ".png")
png::writePNG(ga_topo$img/255, tfile)
plot3d(quad0 <- quad(texfile = tfile, depth = 7, unmesh = TRUE))

class(quad0)
jitter_mesh <- function(x, factor = 1, amount = NULL) {
  factor <- rep(factor, length.out = 3)
  amount <- rep(amount, length.out = 3)
  x$vb[1, ] <- jitter(x$vb[1, ], factor = factor[1], amount = amount[1])
  x$vb[2, ] <- jitter(x$vb[2, ], factor = factor[2], amount = amount[2])
  x$vb[3, ] <- jitter(x$vb[3, ], factor = factor[3], amount = amount[3])
x
}
clear3d()
plot3d(jitter_mesh(quad0, c(2, 2, 1)))
aspect3d(1, 1, 0.001)


# 5. what about elevating them by average elevation, then jitter that
# -------------------------------------------------------
tfile <- tempfile(fileext = ".png")
png::writePNG(ga_topo$img/255, tfile)
quad0 <- quad(texfile = tfile, depth = 8, unmesh = TRUE)

library(anglr)

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])

quad0$vb[3, ] <- raster::extract(gebco, reproj::reproj(t(quad0$vb[1:2, ]), source = ga_topo$crs,
                                                      target = "+proj=longlat")[,1:2])


quad0$vb[3, ] <- rep(colMeans(matrix(quad0$vb[3, quad0$ib], 4)), each  = 4L)  ## a bit tenuous
quad0$vb[3, quad0$vb[3,] < -200] <- NA

plot3d(jitter_mesh(quad0))
plot3d(quad0)
aspect3d(1, 1, .1)









