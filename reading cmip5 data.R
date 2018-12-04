library(ncdf4)
library(raster)
source("masking.R")
file = "../../CMIP5_OceanData/Historical/tos_day_GFDL-CM3_historical_r1i1p1_19950101-19991231.nc"
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
by_day = apply(sst.mat, 2, function(x) as.data.frame(cbind(lonlat, x)))

colnm = c("x","y","z")
for (j in seq_along(by_day)){
  colnames(by_day[[j]]) <- colnm
}

m = mask(0.5,"ocean")
## Use resample command to regrid the data, here nearest neighbor method can also be chosen by setting method = "ngb"
#regridded = lapply(by_day_rstr, function(x) resample(x, m, method = "bilinear"))

day_one <- as.data.frame(cbind(lonlat, sst.mat[,1])) #doesn t work: Error: cannot allocate vector of size 49.2 Gb
