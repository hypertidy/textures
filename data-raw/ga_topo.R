
library(ceramic)
library(anglr) ## remotes::install_github("hypertidy/anglr")
library(wmts) ## remotes::install_github("mdsumner/wmts")
library(rgl)
dem <- cc_elevation(raster::extent(110, 155, -45, -10),
                    max_tiles = 36)

url <- "http://gaservices.ga.gov.au/site_7/rest/services/Topographic_Base_Map_WM/MapServer/WMTS/1.0.0/WMTSCapabilities.xml"
dsn <- glue::glue("WMTS:{url},layer=Topographic_Base_Map_WM,tilematrixset=default028mm")
img <- wmts(dsn, loc = dem, max_tiles = 64)
library(raster)
ga_topo <- list(img = raster::as.array(img),
     extent = c(xmin = xmin(img), xmax = xmax(img), ymin = ymin(img), ymax = ymax(img)),
     crs = crsmeta::crs_proj(img))
download.file("http://gaservices.ga.gov.au/site_7/rest/services/Topographic_Base_Map_WM/MapServer",
              "data-raw/ga_topobasemap.html")
usethis::use_data(ga_topo, overwrite = TRUE)


# x <- DEL0(dem * 18, max_triangles = 60000)
#
# qm <- as.mesh3d(x, image_texture = img)
# qm$vb[1:3, ] <- t(reproj::reproj(t(qm$vb[1:3, ]), "+proj=geocent", source = crsmeta::crs_proj(img)))
# plot3d(qm, specular = "darkgrey"); bg3d("black")
#


