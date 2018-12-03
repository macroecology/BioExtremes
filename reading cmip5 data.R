library(ncdf4)
file = "CMIP5_OceanData/Historical/tos_day_GFDL-CM3_historical_r1i1p1_19950101-19991231.nc"
nc = nc_open(file)
tos = ncvar_get(nc, "tos")
time = ncvar_get(nc,"time")
time = as.Date(time, origin="1860-01-01")
lat = ncvar_get(nc,"rlat")
lon = ncvar_get(nc,"rlon")
