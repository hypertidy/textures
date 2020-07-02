










isoband_raster <- function(x, lo, hi, auto = FALSE) {
  if (auto) {
    breaks <- pretty(values(x))
    lo <- head(breaks, -1)
    hi <- tail(breaks, -1)
  }
  ## OMG: note the [[1]] to avoid the case of as.matrix(brick) which is not helpful ...
  b <- isoband::isobands(xFromCol(x), yFromRow(x), as.matrix(x[[1]]), levels_low = lo, levels_hi = hi)
  sf::st_sf(lo = lo, hi = hi, geometry  = sf::st_sfc(isoband::iso_to_sfg(b), crs = projection(x)))
}





library(anglr)
## using raster, because extract(r, xy, method = "bilinear") is easy, though of course can be done with
## a matrix and 0:ncol, 0:nrow in base R
library(raster)
r <- disaggregate(crop(gebco, extent(135, 180, -60, -10)), fact = 4, method = "bilinear")
## or use isoband see https://github.com/AustralianAntarcticDivision/SOmap/issues/16
rng <- c(cellStats(r, min), cellStats(r, max))
breaks <- c(rng[1], -3000, -2000, -1500, -1000, -500, 0, 300, 600, 900, 1200, 1400, rng[2])
cols <- c(palr::bathy_deep_pal(6), terrain.colors(6))

#s <- sf::st_as_sf(rasterToContour(r, levels = breaks))
s <- isoband_raster(r, lo = head(breaks, -1), hi = tail(breaks, -1))
plot(r, col = cols, breaks = breaks)
plot(sf::st_cast(s, "MULTILINESTRING"), add = TRUE, col = rev(cols))


## rayshader wants a matrix, and it treats it in index space
m <- t(as.matrix(r))  ## we are unpicking the raster-orientation, this is almost image() orientation

lxyz <- list(x = seq(0.5, nrow(m) -0.5), y = seq(0.5, ncol(m)-0.5), z = m[, ncol(m):1])
image(lxyz)


library(rayshader)
m %>%
  height_shade(texture = tail(palr::bathy_deep_pal(54), -5)) %>%
  plot_map()

contour(lxyz, add = TRUE)

rgl::open3d()

m %>%
  height_shade(texture = tail(palr::bathy_deep_pal(54), -5)) %>%
  plot_3d(m, zscale = 550)
library(anglr)






## we need sf coordinates in the scene coordinates (which is based on the matrix)


df <- sfheaders::sf_to_df(s, fill = TRUE)
## that space is raster 0:nrow, 0:ncol
## this would be geography (another topic)
#x_raster <- setValues(r, rep(xFromCol(r), nrow(r)))
#y_raster <- setValues(r, rep(yFromRow(r), each = ncol(r)))

# this is rayshader index space (and recentred at 0,0 for 3d, but not in 2d)
x_raster <- setValues(r, rep(lxyz$x, nrow(r)) - ncol(r) / 2)
## upside down Miss Jane
y_raster <- setValues(r, rep(lxyz$y, each = ncol(r)) - nrow(r)/2)

## so now we can update the sf xy
df$x_geog <- df$x
df$y_geog <- df$y
df$x <- extract(x_raster, cbind(df$x_geog, df$y_geog), method = "bilinear")
df$y <- extract(y_raster, cbind(df$x_geog, df$y_geog), method = "bilinear")
m %>%
  height_shade(texture = tail(palr::bathy_deep_pal(54), -5)) %>%
  plot_map(m)
#points(df$x, df$y)  ## looks promising

df$zscale <- (df$lo + 550)/550
df$z <- df$y
df$y <- df$zscale
sf_ray <- sfheaders::sf_mpoly(df, keep = TRUE)
## we can't plot in 2D now because sf_ray is in xzy
#plot(sf::st_cast(sf_ray, "MULTILINESTRING"), add = T)

rgl::clear3d()
m %>%
  height_shade(texture = tail(palr::bathy_deep_pal(54), -5)) %>%
  plot_3d(m, zscale = 550)

plot3d(SC0(sf_ray), add = TRUE)


