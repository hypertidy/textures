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
quad0 <- quad_texture(texture = tfile)
rgl::plot3d(quad0, specular = "black");
set_scene()



## this is optional, allows us to overplot in map coordinates
quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])
rgl::plot3d(quad0, specular = "black");
set_scene()
wire3d(aus_wire, add = TRUE)


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

# 3. densify the canvas prior to reproject (obviously)
# -------------------------------------------------------
## now let's subdivide the canvas
quad0 <- quad_texture(c(64, 64), texture = tfile)

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])
quad0$vb[1:2, ] <- t(reproj::reproj(t(quad0$vb[1:2, ]), target = laea,
                                    source = ga_topo$crs)[,1:2])

## back in business
rgl::plot3d(quad0, specular = "black")
wire3d(reproj::reproj(aus_wire, laea), add = T)
set_scene()



view3d(interactive = T)
# 4. break the mesh and explode a bit
# -------------------------------------------------------
bmesh <- break_mesh(quad0)
clear3d()
bmesh$vb[3, ] <- jitter(bmesh$vb[3, ])
plot3d(bmesh)

set_scene(interactive = TRUE)
aspect3d(1, 1, 0.01)

# 5. what about elevating them by average elevation, then jitter that
# -------------------------------------------------------

library(anglr)
quad0 <- break_mesh(quad0)
quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])

quad0$vb[3, ] <- raster::extract(gebco, reproj::reproj(t(quad0$vb[1:2, ]), source = ga_topo$crs,
                                                      target = "+proj=longlat")[,1:2])


quad0$vb[3, ] <- rep(colMeans(matrix(quad0$vb[3, quad0$ib], 4)), each  = 4L)  ## a bit tenuous
#quad0$vb[3, quad0$vb[3,] < -200] <- NA


plot3d(quad0)
aspect3d(1, 1, .1)

# 6. barycentric coords with Rvcg
# -----------------------------------------------------
tri <- quad0
tri$it <- anglr:::.quad2tri(tri$ib)
tri$ib <- NULL
a <- Rvcg::vcgBary(tri)
clear3d()
wire3d(tri)
points3d(a)





