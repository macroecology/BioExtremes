## download data from ftp 
## rm (list=ls())
## read .nc
setwd ("C:\\Users\\sara.varela\\Documents\\CIENCIAS\\hackathon\\Baseline_Present_CPC_Global_dialy_temperature")
## read all raw data from present data, average 20 years
library (raster)

res <- stack("tmax.1986.nc",  varname = "tmax")
if (dim (res)[3]==366){
  res<- res[[-60]]
}
anos<- c(1987:2005)
for (i in 1: length (anos)){
  r <- stack(paste ("tmax.", anos [i], ".nc", sep=""),  varname = "tmax")
  if (dim (r)[3]==366){
    r<- r[[-60]]
  }
  res<- res + r              
}

res2<- res/20
res2 <- rotate(res)

mascara<- mask (0.5, "land")
final<- res2*mascara
plot (final[[1]])

writeRaster(final,"C:\\Users\\sara.varela\\Documents\\CIENCIAS\\hackathon\\land_baseline_96_05.grd",
            format="raster", overwrite=T)

### interpolation + baseline
### raster to xyz
xyz_baseline<- rasterToPoints(final)
dim (xyz_baseline)

our_variable<- xzy_baseline + interpolated_predictions



xyzbaseline 

