# textures: quad mesh primitives and texture mapping for grids

A quad mesh on a regular grid is completely determined by a tiny recipe:
the grid dimension, its extent, and the y orientation. textures provides
that recipe at four levels of materialization: the recipe itself
([`quad_spec()`](https://hypertidy.github.io/textures/reference/quad_spec.md)),
the unexpanded cell edge coordinates
([`quad_edges()`](https://hypertidy.github.io/textures/reference/quad_index.md)),
the materialized index and vertices
([`quad_index()`](https://hypertidy.github.io/textures/reference/quad_index.md),
[`quad_vertex()`](https://hypertidy.github.io/textures/reference/quad_index.md)),
and assembled 'mesh3d' objects
([`quad_mesh()`](https://hypertidy.github.io/textures/reference/quad_spec.md),
[`quad()`](https://hypertidy.github.io/textures/reference/quad.md),
[`quad_texture()`](https://hypertidy.github.io/textures/reference/quad.md)).

## Details

Texture mapping is the motivating use: an image draped over a mesh is
resampled by the graphics engine, not by the data pipeline, so mesh
density is independent of image resolution and coordinate transformation
is a vertex operation only. Transformation itself belongs outside this
package - the vertex matrix is the interchange.

## See also

Useful links:

- <https://hypertidy.github.io/textures/>

- <https://github.com/hypertidy/texturesBugReports:>
  <https://github.com/hypertidy/textures/issues>

## Author

**Maintainer**: Michael D. Sumner <mdsumner@gmail.com>
([ORCID](https://orcid.org/0000-0002-2471-7511))

Authors:

- Michael D. Sumner <mdsumner@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-2471-7511))
