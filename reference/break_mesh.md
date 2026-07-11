# un mesh

Break the topology of a mesh by expanding all vertices.

## Usage

``` r
break_mesh(x)
```

## Arguments

- x:

  mesh3d, from e.g.
  [`quad()`](https://hypertidy.github.io/textures/reference/quad.md)

## Value

mesh3d

## Details

Details ... rgl is inherently *topological*, but we can have primitives
that are geometrically independent. (One day I'll find a way to talk
about this that's not garble.)

## Examples

``` r
(mesh <- quad(c(3, 3)))
#>  mesh3d object with 16 vertices, 9 quads.
## same number of primitives, more vertices (every coordinate)
break_mesh(mesh)
#>  mesh3d object with 36 vertices, 9 quads.
```
