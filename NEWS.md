# textures 0.1.1

* Replaced deprecated dot-name arguments in structure() calls (.Dim,
  .Dimnames, .Names) with standard attribute names, per CRAN check NOTE.

# textures 0.1.0

* Preparing for CRAN release, textures is now the core mesh-generation
  package that quadmesh will import.

* The quad header library is vendored into `inst/include/textures/quad.h`,
  removing the GitHub-only 'quad' dependency. Other packages may use it via
  `LinkingTo: textures`.

* Behaviour change: quads are now emitted in cell order, x fastest (the
  `matrix()`/`image()` convention, and raster cell order when `ydown = TRUE`).
  Previously the C++ path emitted quads y fastest. Vertices are unchanged;
  only the column order of `ib` (and so face-value alignment) changes.

* New core primitives `quad_index()`, `quad_edges()`, `quad_vertex()`.
  `quad_edges()` is the unexpanded intermediate form (the grid margin
  coordinates). `quad_index()` transparently returns double storage for
  grids whose vertex count or index length exceeds the integer maximum.

* New compact specification form `quad_spec()`, a plain serializable recipe
  for a generatable mesh, with `quad_mesh()` to materialize it as mesh3d.
  With rgl installed, `as.mesh3d()` also works on a quad_spec (delayed
  S3 registration).

* rgl and scales are no longer Imports: mesh3d objects are constructed
  directly, rgl (in Suggests) is only needed for 3D display. `set_scene()`
  and `png_plot3d()` require rgl at runtime.

* `plot.mesh3d()` is rewritten in base graphics (previously used grid and
  gridBase, which were not declared dependencies); its triangle branch
  indexing bug is fixed.

* `quad_texture()` with an empty texture path now warns 'no texture file
  given' rather than 'texture file given does not exist'.

# textures 0.0.1

* Add `segs()` function. 

* Convert to use headers package {quad}. 

* Convert to cpp11. 

* Now using 'main' as default branch in git. 

* Added 'extent' to `quad()`. 

# textures 0.0.0.9020

* quad.h now provides matrix version of vertex table, with or without z-h. 

* New function `png_plot3d()` to directly plot from a PNG file. 

* Modify R functions to leverage C++ versions of quad vertex and quad index constructors. 

* Aligned to R's matrix orientation as a basis for quad creation. 
