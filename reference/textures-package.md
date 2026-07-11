# textures: Quad Mesh Primitives and Texture Mapping for Grids

Generate quad mesh primitives from the compact specification of a
regular grid, its dimension and extent. Provides fast generation of mesh
indexes and vertices, an unexpanded intermediate form (the grid edge
coordinates), and a compact serializable specification for meshes that
are generated on demand. Meshes are 'mesh3d' objects as used by the
'rgl' package, constructed without requiring any graphics engine, with
support for texture mapping (Heckbert (1986)
[doi:10.1109/MCG.1986.276672](https://doi.org/10.1109/MCG.1986.276672) )
where an image is draped over a mesh whose density is independent of the
image resolution. A C++ header library is installed so that other
packages may generate mesh components via 'LinkingTo'.

## See also

Useful links:

- <https://hypertidy.github.io/textures/>

- Report bugs at <https://github.com/hypertidy/textures/issues>

## Author

**Maintainer**: Michael D. Sumner <mdsumner@gmail.com>
([ORCID](https://orcid.org/0000-0002-2471-7511))

Authors:

- Michael D. Sumner <mdsumner@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-2471-7511))
