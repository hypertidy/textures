# Plot a PNG bitmap in 3D

This is the core idea of the textures package in minimum form: a single
quad carrying a full-resolution image, with all interpolation done by
the graphics engine.

## Usage

``` r
png_plot3d(pngfile, dim = c(1, 1))
```

## Arguments

- pngfile:

  path to a PNG format image file

- dim:

  specify dimensions of quad grid see
  [`quad()`](https://hypertidy.github.io/textures/reference/quad.md)

## Value

returns a mesh3d with 1 quad and the image file textured to it, as a
side effect creates a 3D interactive plot

## Details

Consider that the vertices on each corner can be changed by value
arbitrarily, this will affect the way this will be represented
geometrically and visually. If the internal mesh of the quad is denser,
this provides automatic image reprojection work entirely by the graphics
engine.

## Examples

``` r
if (FALSE) { # interactive() && requireNamespace("rgl", quietly = TRUE)
file <- system.file("extdata/Rlogo.png", package = "textures")
png_plot3d(file)
}
```
