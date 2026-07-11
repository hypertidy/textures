# rgl defaults

Quick defaults for rgl static plot

## Usage

``` r
set_scene(
  interactive = FALSE,
  zoom = 0.5,
  phi = 0,
  theta = 0,
  light_phi = -45,
  light_theta = 0
)
```

## Arguments

- interactive:

  mouse interactive plot, default `FALSE`

- zoom:

  zoom for
  [rgl::view3d](https://dmurdoch.github.io/rgl/dev/reference/viewpoint.html)
  default `0.5` which is closer than rgl 1

- phi, theta:

  polar coordinates, passed to
  [`rgl::view3d()`](https://dmurdoch.github.io/rgl/dev/reference/viewpoint.html)

- light_phi, light_theta:

  polar coordinates, passed to
  [`rgl::light3d()`](https://dmurdoch.github.io/rgl/dev/reference/light.html)
  as `phi` and `theta` respectively

## Value

nothing

## Details

This function sets the size of the window to 1024x1024, sets the view
position at directly vertical `phi = 0, theta = 0`, makes the view
non-interactive (zoom is enabled, but no pivot or pan). It turns off the
lights and puts a new light in front of the viewer (to avoid shiny
glare), sets the aspect ratio to 'iso' ("fill the box"), and attempts to
'bringtotop', but I think that has to happen interactively with
[`rgl::rgl.bringtotop()`](https://dmurdoch.github.io/rgl/dev/reference/rgl.bringtotop.html)
(especially for animating or snapshotting scenes to file).

`phi` and `theta` use `0` and `0` respectively, phi is different from
rgl's default in order to look straight down on the quad (along the z
axis)

`light_phi` and `light_theta` use `-45` and `0` respectively, phi is
different from rg's default to put the light source forwards (y+) from
the viewer when looking straight down

## Examples

``` r
if (FALSE) { # interactive() && requireNamespace("rgl", quietly = TRUE)
## see README and in-dev examples in rough-examples.R
rgl::plot3d(rnorm(10), rnorm(10), rnorm(1)); set_scene()
}
```
