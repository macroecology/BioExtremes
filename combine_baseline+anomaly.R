addAnomalyToBaseline <- function(baseline_name, anomaly_file, land_or_ocean="land", output_name, ftp_directory_output){
  # Function that create the variable by combining the baseline to the anomaly
  # Name of the baseline file
  # Name of the variable file
  # Name of the file to the function to apply
  # Name of the output file

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
  base_masked <- base*l #Is it how one masks?

  ano <- raster(saving2)
  ano_masked <- ano*l

  #Add anomaly to baseline
  stack <- stack(base_masked, ano_masked)
  result <- calc(stack, sum)

  result
}
#writeRaster(result, paste0("output/",output_name),"netCDF")
#Load output on ftp server
#upload(paste0("output/",output_name), ftp_directory_output, output_name)
