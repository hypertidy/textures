# Quad mesh primitives

Generate the components of a quad mesh from the compact specification of
a regular grid: the `dimension` (number of cells nx, ny) and optionally
the `extent` (xmin, xmax, ymin, ymax).

## Usage

``` r
quad_index(dimension, ydown = FALSE)

quad_edges(dimension, extent = NULL, ydown = FALSE)

quad_vertex(dimension, extent = NULL, ydown = FALSE)
```

## Arguments

- dimension:

  number of cells in the grid (nx, ny), a single value is recycled

- ydown:

  should the y coordinate be counted from the top (image/raster
  orientation), default `FALSE`

- extent:

  extent of the grid `c(xmin, xmax, ymin, ymax)`, default is the unit
  square

## Value

`quad_index()` a 4-row matrix of vertex indexes (integer, or double for
very large grids), `quad_edges()` a list with `x` and `y` edge
coordinate vectors, `quad_vertex()` a 2-column matrix of vertex
coordinates

## Details

`quad_index()` gives the index of the four corner vertices of every
cell, a 4 x (nx \* ny) matrix of 1-based vertex indexes. Quads are in
cell order, x fastest (the
[`matrix()`](https://rdrr.io/r/base/matrix.html) and
[`image()`](https://rdrr.io/r/graphics/image.html) convention, and
raster cell order when `ydown = TRUE`). Winding is counter-clockwise for
y-up grids.

`quad_edges()` gives the unexpanded form of the vertices, the x and y
coordinates of the cell edges as two vectors of length nx + 1 and
ny + 1. This is the compact intermediate: the full vertex set is their
outer expansion, and for many purposes (transform bounds, axis
coordinates, texture alignment) the margins are all that is needed.

`quad_vertex()` gives the materialized vertices, a (nx + 1) \* (ny + 1)
row matrix of x, y coordinates, x fastest, matching the index in
`quad_index()`.

For very large grids where the vertex count or index length exceeds the
integer maximum, `quad_index()` returns a matrix of doubles (exact for
integer values to 2^53), which R subsetting and 'mesh3d' usage accept
natively. Take care not to apply
[`as.integer()`](https://rdrr.io/r/base/integer.html) to such an index.

## Examples

``` r
quad_index(c(2, 3))
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> [1,]    1    2    4    5    7    8
#> [2,]    2    3    5    6    8    9
#> [3,]    5    6    8    9   11   12
#> [4,]    4    5    7    8   10   11
quad_edges(c(2, 3), extent = c(0, 10, 0, 20))
#> $x
#> [1]  0  5 10
#> 
#> $y
#> [1]  0.000000  6.666667 13.333333 20.000000
#> 
quad_vertex(c(2, 3), extent = c(0, 10, 0, 20))
#>        x         y
#>  [1,]  0  0.000000
#>  [2,]  5  0.000000
#>  [3,] 10  0.000000
#>  [4,]  0  6.666667
#>  [5,]  5  6.666667
#>  [6,] 10  6.666667
#>  [7,]  0 13.333333
#>  [8,]  5 13.333333
#>  [9,] 10 13.333333
#> [10,]  0 20.000000
#> [11,]  5 20.000000
#> [12,] 10 20.000000
```
