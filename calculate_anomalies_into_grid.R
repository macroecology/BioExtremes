setwd ("C:\\Users\\sara.varela\\Documents\\CIENCIAS\\hackathon\\raw_variables")
list.files()
library (ncdf4)
lala<- nc_open( "tasmax_day_MIROC-ESM_lgm_r1i1p1_46000101-46991231.nc")
lala

library (raster)

res <- stack("tasmax_day_MIROC-ESM_lgm_r1i1p1_46000101-46991231.nc",  varname = "tasmax")
anomalies<- res [[1:365]]
anomalies

writeRaster (anomalies, "C:\\Users\\sara.varela\\Documents\\CIENCIAS\\anomalies_land.grd", format="raster")
