# Compact quad mesh specification

A quad mesh on a regular grid is completely determined by a tiny recipe:
the grid dimension, its extent, and the y orientation. `quad_spec()`
records that recipe as a plain, serializable list without materializing
any vertices or indexes.

## Usage

``` r
quad_spec(
  dimension = c(1L, 1L),
  extent = NULL,
  ydown = FALSE,
  crs = NULL,
  texture = NULL
)

quad_mesh(x, ...)

# S3 method for class 'quad_spec'
quad_mesh(x, ...)

# S3 method for class 'quad_spec'
as.mesh3d(x, ...)

# S3 method for class 'quad_spec'
print(x, ...)
```

## Arguments

- dimension:

  number of cells in the grid (nx, ny), a single value is recycled

- extent:

  extent of the grid `c(xmin, xmax, ymin, ymax)`, default is the unit
  square

- ydown:

  should the y coordinate be counted from the top, default `FALSE`

- crs:

  optional coordinate reference system, stored but not used by textures
  itself

- texture:

  optional file path to a PNG image to texture onto the mesh when
  materialized

- x:

  a quad_spec object

- ...:

  ignored, or passed between methods

## Value

`quad_spec()` a list with class 'quad_spec', `quad_mesh()` a mesh3d
object, the print method returns its input invisibly

## Details

`quad_mesh()` materializes the specification as a 'mesh3d' object (as
used by the 'rgl' package, but constructed without it). If the spec
carries a `texture` image file path, texture coordinates are included:
these are the extent-normalized vertex coordinates, so they remain valid
for any mesh whose vertices lie in the extent.

With the 'rgl' package installed,
[`as.mesh3d()`](https://dmurdoch.github.io/rgl/dev/reference/as.mesh3d.default.html)
works directly on a quad_spec (registered on-demand, 'rgl' is not
required).

The mesh density given by `dimension` is independent of the pixel
dimension of any `texture` image: a coarse mesh may carry a
full-resolution image, the graphics engine interpolates within each
quad.

A spec can be stored, serialized, and sent where a materialized mesh
cannot sensibly be - materialization is deferred to the consumer.

## See also

Other textures:
[`break_mesh()`](https://hypertidy.github.io/textures/reference/break_mesh.md),
[`quad()`](https://hypertidy.github.io/textures/reference/quad.md)

## Examples

``` r
spec <- quad_spec(c(20, 10), extent = c(100, 160, -60, -30))
spec
#> <quad_spec>
#>   dimension : 20 x 10 cells (231 vertices)
#>   extent    : 100, 160, -60, -30 (xmin, xmax, ymin, ymax)
#>   ydown     : FALSE
mesh <- quad_mesh(spec)
str(mesh$vb)
#>  num [1:4, 1:231] 100 -60 0 1 103 -60 0 1 106 -60 ...
```
