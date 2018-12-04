mat2xyz <- function(mat, lon, lat){
  lonlat = expand.grid(lon, lat)
  sst = as.vector(mat)
  data.frame(x=lonlat[,1], y=lonlat[,2], z=sst)
}

ncdf2xyz <- function(file){
  require(ncdf4)
  require(raster)
  nc = nc_open(file)
  tos = ncvar_get(nc, "tos")
  time = ncvar_get(nc,"time")
  u = ncatt_get(nc,"time")$units
  origin = el(regmatches(u,gregexpr("[0-9-]{10}",u)))
  time = as.Date(time, origin)
  lat = ncvar_get(nc,"rlat")
  lon = ncvar_get(nc,"rlon")
  lonlat = expand.grid(lon, lat)
  sst = as.vector(tos)
  sst.mat = matrix(sst, nrow = length(lon)*length(lat), ncol = length(time))
  by_day = list()
  for(i in seq_along(time)){
    by_day[[i]] <- data.frame(cbind(lonlat,sst.mat[,i]))
    colnames(by_day[[i]]) <- letters[24:26]
  }
  by_day
}
