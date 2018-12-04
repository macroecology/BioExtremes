landmask <- function(mapfolder, mapfile, cellsize){ #Take a shapefile with land masses and make a landmask at the desired resolution
  require(raster)
  require(rgdal)
  gridlat <- seq(-90,90,cellsize)
  gridlon <- seq(-180,180,cellsize)
  ras <- raster(nrow=length(gridlat), ncol=length(gridlon))
  land <- readOGR(mapfolder, gsub("\\.shp$","",mapfile))
  mask <- is.na(rasterize(land,ras))
  mask[mask>0] <- 0
  mask[mask==0] <- 1
  mask
}