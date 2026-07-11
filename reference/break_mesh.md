# Break mesh, expand vertex instances

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

Data in a mesh and in rgl is inherently *topological*, but we can have
primitives that independent, out of an original mesh. Expanding every
vertex makes primitives geometrically independent, so attributes
(colours, texture coordinates) can be constant per face rather than
interpolated between shared vertices - the *discrete* rendering of a
*continuous* mesh, at the cost of four times the vertices. This is the
`dquadmesh` idea from quadmesh package.

## See also

Other textures:
[`quad()`](https://hypertidy.github.io/textures/reference/quad.md),
[`quad_spec()`](https://hypertidy.github.io/textures/reference/quad_spec.md)

## Examples

``` r
(mesh <- quad(c(3, 3)))
#>  mesh3d object with 16 vertices, 9 quads.
## same number of primitives, more vertices (every coordinate)
break_mesh(mesh)
#>  mesh3d object with 36 vertices, 9 quads.
```
