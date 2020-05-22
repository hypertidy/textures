f <- system.file("extdata/Tina_render.png", package = "textures")
library(textures)
qm <- quad(texfile = f, depth = 8)  ## in quadmesh / anglr we can get the pixels *exactly*, this is a shortcut for now using subdivision3d
  ## better to use terrainmeshr, again wrapped in anglr but need a bit of thought to apply here

library(rgl)
plot3d(qm)

im <- png::readPNG(f)
## never used LAB before, is this right (does it matter?)
col <- colorspace::RGB(as.vector(im[,,1]), as.vector(im[,,2]), as.vector(im[,,3]))
L <- matrix(col@coords[,1], dim(im)[1:2])

index <- cbind(qm$texcoords[1, ] * (dim(L)[2L]-1) + 1,
               (1-qm$texcoords[2, ]) * (dim(L)[1L]-1) + 1)  ## note the flip
qm$vb[3, ] <- 1- L[index[,2:1]]
plot3d(qm)
aspect3d(1, 1, .06)


