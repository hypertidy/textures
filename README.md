
<!-- README.md is generated from README.Rmd. Please edit that file -->

# textures

<!-- badges: start -->

<!-- badges: end -->

The goal of textures is to utilize texture mapping in rgl to work with
images in different coordinate systems and mapped onto arbitrary shapes.

There’s a couple of functions in the package, with ongoing work to
explore examples and align them to package functionality.

The goal is for this package to illustrate texture mapping capability in
rgl with *core techniques familiar to R users*, and with minimal *resort
to specialist code*. When specialist code is required it will be brought
out explicitly and explained in a single-step.

Very WIP

## Installation

Only for dev interest.

``` r
## install.packages("remotes")
remotes::install_github("hypertidy/textures")
```

## Example

A Mercator raster on a single quad. Zoom in and out but no translate or
pivot (it’s disabled).

Maps an image onto a quad from a PNG file.

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
