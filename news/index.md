# Changelog

## textures 0.1.1

- Replaced deprecated dot-name arguments in structure() calls (.Dim,
  .Dimnames, .Names) with standard attribute names, per CRAN check NOTE.

## textures 0.1.0

CRAN release: 2026-07-21

- Preparing for CRAN release, textures is now the core mesh-generation
  package that quadmesh will import.

- The quad header library is vendored into
  `inst/include/textures/quad.h`, removing the GitHub-only ‘quad’
  dependency. Other packages may use it via `LinkingTo: textures`.

- Behaviour change: quads are now emitted in cell order, x fastest (the
  [`matrix()`](https://rdrr.io/r/base/matrix.html)/[`image()`](https://rdrr.io/r/graphics/image.html)
  convention, and raster cell order when `ydown = TRUE`). Previously the
  C++ path emitted quads y fastest. Vertices are unchanged; only the
  column order of `ib` (and so face-value alignment) changes.

- New core primitives
  [`quad_index()`](https://hypertidy.github.io/textures/reference/quad_index.md),
  [`quad_edges()`](https://hypertidy.github.io/textures/reference/quad_index.md),
  [`quad_vertex()`](https://hypertidy.github.io/textures/reference/quad_index.md).
  [`quad_edges()`](https://hypertidy.github.io/textures/reference/quad_index.md)
  is the unexpanded intermediate form (the grid margin coordinates).
  [`quad_index()`](https://hypertidy.github.io/textures/reference/quad_index.md)
  transparently returns double storage for grids whose vertex count or
  index length exceeds the integer maximum.

- New compact specification form
  [`quad_spec()`](https://hypertidy.github.io/textures/reference/quad_spec.md),
  a plain serializable recipe for a generatable mesh, with
  [`quad_mesh()`](https://hypertidy.github.io/textures/reference/quad_spec.md)
  to materialize it as mesh3d. With rgl installed,
  [`as.mesh3d()`](https://dmurdoch.github.io/rgl/dev/reference/as.mesh3d.default.html)
  also works on a quad_spec (delayed S3 registration).

- rgl and scales are no longer Imports: mesh3d objects are constructed
  directly, rgl (in Suggests) is only needed for 3D display.
  [`set_scene()`](https://hypertidy.github.io/textures/reference/set_scene.md)
  and
  [`png_plot3d()`](https://hypertidy.github.io/textures/reference/png_plot3d.md)
  require rgl at runtime.

- [`plot.mesh3d()`](https://hypertidy.github.io/textures/reference/plot.mesh3d.md)
  is rewritten in base graphics (previously used grid and gridBase,
  which were not declared dependencies); its triangle branch indexing
  bug is fixed.

- [`quad_texture()`](https://hypertidy.github.io/textures/reference/quad.md)
  with an empty texture path now warns ‘no texture file given’ rather
  than ‘texture file given does not exist’.

## textures 0.0.1

- Add [`segs()`](https://hypertidy.github.io/textures/reference/quad.md)
  function.

- Convert to use headers package {quad}.

- Convert to cpp11.

- Now using ‘main’ as default branch in git.

- Added ‘extent’ to
  [`quad()`](https://hypertidy.github.io/textures/reference/quad.md).

## textures 0.0.0.9020

- quad.h now provides matrix version of vertex table, with or without
  z-h.

- New function
  [`png_plot3d()`](https://hypertidy.github.io/textures/reference/png_plot3d.md)
  to directly plot from a PNG file.

- Modify R functions to leverage C++ versions of quad vertex and quad
  index constructors.

- Aligned to R’s matrix orientation as a basis for quad creation.
