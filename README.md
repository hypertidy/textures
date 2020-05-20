
<!-- README.md is generated from README.Rmd. Please edit that file -->

# textures

<!-- badges: start -->

<!-- badges: end -->

The goal of textures is to utilize texture mapping in rgl to work with
images in different coordinate systems and mapped onto arbitrary shapes.

WIP

## Installation

Not yet.

## Example

Not much yet, just a Mercator raster on a single quad. Zoom in and out
but no translate (yet) or pivot (it’s disabled). This is a basi c
example which shows you how to map an image onto a quad (4 coordinates)
from a PNG file.

``` r
library(textures)


suppressWarnings(quad0 <- anglr::as.mesh3d(matrix(0, 1))) ## to be fixed
quad0$texcoords <- quad0$vb[1:2, ]
tfile <- tempfile()
png::writePNG(ga_topo$img/255, tfile)
quad0$material$texture <- tfile

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])

rgl::open3d()
#> wgl 
#>   1
rgl::plot3d(quad0, specular = "black"); rgl::view3d(phi = 0, interactive = FALSE)
dir.create("man/figures", showWarnings = FALSE)
rgl::snapshot3d("man/figures/readme_ga000.png", )
```

![texture map on aquad](man/figures/readme_ga000.png)

-----

## Code of Conduct

Please note that the textures project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
