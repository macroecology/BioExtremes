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
#sst.df = data.frame(cbind(lonlat, sst.mat))
sst.df = data.frame(cbind(lonlat, sst.mat[,1]))
#by_day = apply(sst_df[,-(1:2)], 2, function(x) cbind(lonlat, x))

colnm = c("x","y","z")
#for (j in seq_along(by_day)){
#  colnames(by_day[[j]]) <- colnm
#}
colnames(sst.df)<-colnm

#by_day_rstr = lapply(by_day, function(x) rasterFromXYZ(x))
by_day_rstr = rasterize(sst.df,m)
m = mask(0.5,"ocean")
## Use resample command to regrid the data, here nearest neighbor method can also be chosen by setting method = "ngb"
regridded = lapply(by_day_rstr, function(x) resample(x, m, method = "bilinear"))
