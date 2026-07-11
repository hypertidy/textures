# Quad canvas

Create a simple quad mesh3d object

## Usage

``` r
quad(dimension = c(1L, 1L), extent = NULL, ydown = FALSE, ...)

quad_texture(dimension = c(1L, 1L), extent = NULL, ydown = FALSE, texture = "")

segs(dimension = c(1L, 1L), extent = NULL, ydown = FALSE, ...)
```

## Arguments

- dimension:

  dimensions of mesh (using
  [`matrix()`](https://rdrr.io/r/base/matrix.html) and
  [`image()`](https://rdrr.io/r/graphics/image.html) orientation)

- extent:

  optional extent of mesh xmin, xmax, ymin, ymax

- ydown:

  should y-coordinate be counted from top (default `FALSE`)

- ...:

  used only to warn about old usage

- texture:

  file path to PNG image (may not exist)

## Value

mesh3d with quads and material texture settings as per inputs

## Details

Use `quad()` to create a mesh3d object with quad indexes to the
vertices, this is defined in the rgl package by
[qmesh3d()](https://dmurdoch.github.io/rgl/dev/reference/mesh3d.html)
and has elements `vb` (the homogeneous coordinates 4xn) and `ib` (the
quad index 4xn).

Use `seg()` to create a mesh3d object with segment indexes, exactly
analogous to the mesh created by `quad()` just only containing the quad
edges/segments - note that segments are unique.

The `meshColor` is currently hardcoded as 'vertices'.

Use `quad_texture()` to create a mesh3d object additionally with
`texcoords` and `texture` properties.

## Deprecation note

Note that an early version used arguments 'depth' (to control
[`rgl::subdivision3d()`](https://dmurdoch.github.io/rgl/dev/reference/subdivision3d.html)),
'tex' to indicate that texture should be included, 'texfile' a link to
the texture file path, and 'unmesh' to remove topology by expanding the
vertices . Please now use `quad_texture()` for textures, and `dimension`
argument (length 1 or 2), and
[`break_mesh()`](https://hypertidy.github.io/textures/reference/break_mesh.md).

## Examples

``` r
qm <- quad()
## orientation is low to high, x then y
qm <- quad(dim(volcano))
scl <- function(x) (x - min(x, na.rm = TRUE))/diff(range(x, na.rm = TRUE))
qm$meshColor <- "faces"
qm$material$color <- hcl.colors(12, "YlOrRd", rev = TRUE)[scl(volcano) * 11 + 1]
```
