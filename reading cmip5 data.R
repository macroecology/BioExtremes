library(ncdf4)
file = "CMIP5_OceanData/Historical/tos_day_GFDL-CM3_historical_r1i1p1_19950101-19991231.nc"
nc = nc_open(file)
tos = ncvar_get(nc, "tos")
time = ncvar_get(nc,"time")
u = ncatt_get(nc,"time")$units
origin = el(regmatches(u,gregexpr("[0-9-]{10}",u)))
time = as.Date(time, origin)
lat = ncvar_get(nc,"rlat")
lon = ncvar_get(nc,"rlon")
