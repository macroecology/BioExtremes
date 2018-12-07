addAnomalyToBaseline <- function(baseline_name, anomaly_file, land_or_ocean="land"){
  # Function that create the variable by combining the baseline to the anomaly

  #Download
  source("download_from_ftp.R")
  require(config)
  require(RCurl)
  require(raster)
  saving1 <- paste0("data/baseline/",baseline_name)
  download(baseline_name,saving1,folder=FALSE)
  saving2 <- paste0("data/variables/",anomaly_file)
  download(anomaly_file,saving2,folder=FALSE)

  #Remap baseline on regular grid
  source("masking.R")
  l <- create_mask(0.5,land_or_ocean)
  base <- raster(saving1)
  base_regrid <- resample(base, l) #Is it like that or simply base*l ?
  base_masked <- mask(base_regrid,l)

  ano <- raster(saving2)
  ano_regrid <- resample(ano, l)
  ano_masked <- mask(ano_regrid,l)

  #Add anomaly to baseline
  stack <- stack(base_masked, ano_masked)
  result <- calc(stack, sum)

  result
}
#writeRaster(result, paste0("output/",output_name),"netCDF")
#Load output on ftp server
#upload(paste0("output/",output_name), ftp_directory_output, output_name)
