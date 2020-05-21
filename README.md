
<!-- README.md is generated from README.Rmd. Please edit that file -->

# textures

<!-- badges: start -->

<!-- badges: end -->

No code here yet, just ideas to flesh out. :)

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
## can't run this in rmarkdown as snapshot doesn't work
library(textures)
tfile <- tempfile()
png::writePNG(ga_topo$img/255, tfile)

quad0 <- quad(texfile = tfile)

quad0$vb[1L,] <- scales::rescale(quad0$vb[1,], to = ga_topo$extent[c("xmin", "xmax")])
quad0$vb[2L,] <- scales::rescale(quad0$vb[2L,], to = ga_topo$extent[c("ymin", "ymax")])


rgl::open3d()
rgl::plot3d(quad0, specular = "black")
set_scene()
dir.create("man/figures", showWarnings = FALSE)
rgl::rgl.bringtotop()
rgl::snapshot3d("man/figures/readme_ga000.png")
```

![texture map on a quad](man/figures/readme_ga000.png)

## Re-map projections

Create a generalized surface in arbitrary map projection and remap the
image losslessly …

TODO

-----

## Code of Conduct

Please note that the textures project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
