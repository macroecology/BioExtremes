library(maptools)
library(sp)
library(raster)
library(rgdal)
download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip","ne_110m_land.zip")
unzip("ne_110m_land.zip")
land <- readOGR(".","ne_110m_land")

landmask <- function(map, cellsize){ 
  #Take a shapefile with land masses and make a landmask at the desired resolution
  #Here land is 1 and ocean NA
  require(raster)
  require(rgdal)
  gridlat <- seq(-90,90,cellsize)
  gridlon <- seq(-180,180,cellsize)
  ras <- raster(nrow=length(gridlat), ncol=length(gridlon), resolution=c(cellsize, cellsize))
  mask <- !is.na(rasterize(map,ras))
  mask[mask==0]<-NA
  mask
}

oceanmask <- function(map, cellsize){ 
  #Here ocean is 1 and land NA
  require(raster)
  require(rgdal)
  gridlat <- seq(-90,90,cellsize)
  gridlon <- seq(-180,180,cellsize)
  ras <- raster(nrow=length(gridlat), ncol=length(gridlon), resolution=c(cellsize, cellsize))
  mask <- !!is.na(rasterize(map,ras))
  mask[mask==0]<-NA 
  mask
}

l <- landmask(land,0.5)
o <- oceanmask(land,0.5)
