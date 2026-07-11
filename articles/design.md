# design - textures package

## Design

A quad mesh on a regular grid is completely determined by a tiny recipe:
the grid `dimension` (nx, ny cells), the `extent` (xmin, xmax, ymin,
ymax), and the y orientation (`ydown`). Everything in textures is a view
of that recipe at some level of materialization:

- [`quad_spec()`](https://hypertidy.github.io/textures/reference/quad_spec.md) -
  the recipe itself, a plain serializable list, nothing materialized
- [`quad_edges()`](https://hypertidy.github.io/textures/reference/quad_index.md) -
  the unexpanded intermediate, the x and y coordinates of the cell edges
  as two short vectors (nx + 1 and ny + 1 values)
- [`quad_index()`](https://hypertidy.github.io/textures/reference/quad_index.md),
  [`quad_vertex()`](https://hypertidy.github.io/textures/reference/quad_index.md) -
  the materialized components, the 4 x (nx \* ny) vertex index and the
  expanded vertex coordinates
- [`quad_mesh()`](https://hypertidy.github.io/textures/reference/quad_spec.md),
  [`quad()`](https://hypertidy.github.io/textures/reference/quad.md),
  [`quad_texture()`](https://hypertidy.github.io/textures/reference/quad.md) -
  assembled ‘mesh3d’ objects

‘mesh3d’ objects are constructed directly (rgl is not required, it lives
in Suggests). With rgl installed they plot with
[`plot3d()`](https://dmurdoch.github.io/rgl/dev/reference/plot3d.html),
[`shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html),
[`persp3d()`](https://dmurdoch.github.io/rgl/dev/reference/persp3d.html),
[`wire3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html),
or
[`dot3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html),
and
[`as.mesh3d()`](https://dmurdoch.github.io/rgl/dev/reference/as.mesh3d.default.html)
works on a quad_spec via delayed S3 registration. A 2D base graphics
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) method is
included.

### Conventions

- Default extent is the unit square, “y-up” (y begins at 0).
- Quads are emitted in cell order, x fastest - the
  [`matrix()`](https://rdrr.io/r/base/matrix.html)/[`image()`](https://rdrr.io/r/graphics/image.html)
  convention, and raster cell order when `ydown = TRUE`. Face-indexed
  values (colours, `na.rm`) align with grid cell order.
- Quad vertex winding is counter-clockwise, as required by rgl (see
  `material3d` `back` argument).
- `ydown` flips the orientation so y coordinates begin at the top and
  count down, and rotates the index cycle so winding remains correct.
- Texture coordinates are the extent-normalized vertex coordinates, so
  they remain valid for any mesh whose vertices lie in the extent. Mesh
  density (`dimension`) is independent of the pixel dimension of a
  texture image: a coarse mesh may carry a full-resolution image, the
  graphics engine interpolates within each quad.
- Coordinate transformation belongs outside the core: the mesh vertex
  matrix is the interchange, transform it (e.g. with reproj) and the
  texture drapes unchanged.

### Large grids

[`quad_index()`](https://hypertidy.github.io/textures/reference/quad_index.md)
returns integer storage where it fits, and transparently promotes to
double storage (exact for integer values to 2^53) when the vertex count
or index length exceeds the integer maximum. R subsetting and ‘mesh3d’
use accept double indexes natively; take care not to apply
[`as.integer()`](https://rdrr.io/r/base/integer.html) to such an index.
The compact spec and the edges intermediate are the escape hatch when
full materialization is not wanted at all.

### Compiled code

Registered via cpp11 in `src/quad-build.cpp`, callable from R as
internal functions:

``` c++
cpp11::integers quad_index_cpp(int nx, int ny, bool ydown)
cpp11::doubles  quad_index_dbl_cpp(double nx, double ny, bool ydown)
cpp11::doubles  quad_vertex_cpp(int nx, int ny, bool ydown, bool zh)
cpp11::writable::doubles_matrix<> quad_vertex_matrix_cpp(int nx, int ny, bool ydown, bool zh)
```

### Headers

`inst/include/textures/quad.h`, namespace `quad`, installed so that
other packages may generate mesh components via `LinkingTo: textures`:

``` c++
cpp11::writable::integers quad_ib(int nx, int ny, bool ydown)
cpp11::writable::doubles  quad_ib_dbl(double nx, double ny, bool ydown)
cpp11::writable::doubles  quad_vb(int nx, int ny, bool ydown, bool zh)
cpp11::writable::doubles_matrix<> quad_matrix_vb(int nx, int ny, bool ydown, bool zh)
```

`quad_ib` and `quad_vb` return flat vectors (4 values per quad, and
interleaved x, y with optional constant z and homogeneous h),
`quad_matrix_vb` returns the matrix form.

### R reference implementations

`ib_index()` and `vb_vertex()` in `R/quad-Rcode.R` are pure-R versions
of the index and vertex generators, kept as the executable
specification - the tests pin the compiled path to them.
