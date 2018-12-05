#This function creates a mask. 
#Possible arguments for "which" are "land", "ocean" or "landocean" depending on whether
#one wants to produce a landmask (land=1, ocean=NA), an ocean mask (land=NA, ocean=1) 
#or a land/ocean differentiation (land=1, ocean=0).
#It uses NaturalEarth basemap (public domain, 1:110m resolution).
#It outputs a raster layer with the requested resolution ("cellsize").
mask <- function(cellsize, which){
  require(maptools)
  require(sp)
  require(raster)
  require(rgdal)
  download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip","ne_110m_land.zip")
  unzip("ne_110m_land.zip")
  map <- readOGR(".","ne_110m_land")
  unlink(dir(".",pattern="ne_110m"))
  gridlat <- seq(-90,90,cellsize)
  gridlon <- seq(-180,180,cellsize)
  ras <- raster(nrow=length(gridlat), ncol=length(gridlon), resolution=c(cellsize, cellsize))
  mask <- !is.na(rasterize(map,ras))
  if(which=="land"){
    mask <- !is.na(rasterize(map,ras))
    mask[mask==0]<-NA
  }else if(which=="ocean"){
    mask <- !!is.na(rasterize(map,ras))
    mask[mask==0]<-NA
  }else if(which=="landocean"){
    mask <- !is.na(rasterize(map,ras))
  }
  mask
}
