# Topographic image

Image of Australia as a map, its extent, and map projection.

## Usage

``` r
ga_topo
```

## Format

A list with an array, a numeric vector, and a character vector:

- img:

  image array with dimension 921,1025,3 - three slices Red, Green, Blue

- extent:

  the geographic extent of the array, in metres

- crs:

  the map projection of the geographic extent of `img`

## Details

This dataset exists to demonstrate the full pattern: write `img` to PNG,
texture it with `[quad_texture()]` using extent, and transform the mesh
vertices with the crs - the image itself is never resampled.

(The image is web Mercator, aka 'EPSG:3857'. We've kept the proj string
because it's the easiest way to modify a projection.)

## Provenance

Copyright Commonwealth of Australia (Geoscience Australia) 2016.
Creative Commons Attribution 4.0 International Licence.

The image is named 'Australian Topographic Base Map (Web Mercator)' and
is from the following Geoscience Australia Web Map Tile Service (WMTS):
<https://services.ga.gov.au/gis/rest/services/Topographic_Base_Map/MapServer>.

Code to obtain the image is in 'data-raw/ga_topo.R' at
<https://github.com/hypertidy/textures> using the wmts package
<https://github.com/mdsumner/wmts>.
