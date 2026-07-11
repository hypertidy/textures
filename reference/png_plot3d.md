# Plot a PNG bitmap in 3D

Plot a PNG bitmap in 3D

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

## Examples

``` r
if (FALSE) { # interactive() && requireNamespace("rgl", quietly = TRUE)
file <- system.file("extdata/Rlogo.png", package = "textures")
png_plot3d(file)
}
```
