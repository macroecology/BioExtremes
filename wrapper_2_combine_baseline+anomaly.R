addAnomalyToBaseline <- function(baseline_name, anomaly_file, land_or_ocean="land", output_name){
  # Name of the baseline file
  # Name of the variable file
  # Name of the file to the function to apply
  # Name of the output file

  #Download baselines
  library(config)
  library(RCurl)
  library(raster)
  ftp_host = config::get("ftp")$host
  ftp_user = config::get("ftp")$username
  ftp_password = config::get("ftp")$password
  options(timeout=300)
  url <- paste (ftp_host, "/ftpuser0063/", sep="")
  userpwd <- paste (ftp_user, ftp_password, sep=":")
  foldernames <- getURL(url, userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE) # downloads folder names

  foldernames <- strsplit(foldernames, '\n')
  foldernames <- unlist(foldernames)
  filenames <- getURL(paste0(url, foldernames[grep("present_baseline", foldernames)], "/"), userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE)
  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames[!grepl("^[.]+$",filenames)]
  # adjust foldernames, currently set to hackthon variables
  dir.create("data")
  dir.create("data/baseline")
  if(baseline_name%in%filenames){
    filename = filenames[filenames==baseline_name]
  }else{
    stop("Variable file name does not exist on the FTP server")
  }
  bin = getBinaryURL(paste0(url, foldernames[grep("present_baseline", foldernames)], "/", filename), userpwd=userpwd)
  writeBin(bin, paste0("/data/baseline/", filename))

  #Download data
  filenames <- getURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/"), userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE)
  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames[!grepl("^[.]+$",filenames)]
  if(anomaly_file%in%filenames){
    filename = filenames[filenames==anomaly_file]
  }else{
    stop("Anomaly file name does not exist on the FTP server")
  }
  dir.create("data/variables")
  bin <- getBinaryURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/", filename), userpwd=userpwd)
  writeBin(bin, paste0("/data/variables/", filename))

  #Remap baseline on regular grid
  datafiles = dir("data",full.names=TRUE,recursive=TRUE)
  baseline = datafiles[grepl(baseline_file,datafiles)]
  source("masking.R")
  l <- mask(0.5,land_or_ocean)
  base = raster(baseline)
  base_regrid = resample(base, l)
  base_masked = raster::mask(base_regrid)

  anomaly = datafiles[grepl(anomaly_file,datafiles)]
  ano = raster(baseline)
  ano_regrid = resample(ano, l)
  ano_masked = raster::mask(ano_regrid)

  #Add anomaly to baseline
  stack = stack(base_masked, ano_masked)
  result = calc(stack, sum)

  #sAVE THE FILE
  writeRaster(result, paste0("output/",output_name),"netCDF")
  #Load output on ftp server
  ftpUpload(I("output/frost_days.nc"), paste0("ftp://", userpwd, "@", gsub("^s?ftp://",ftp_host), ftp_user, "/", foldernames[grep("hackathon", foldernames)], "/", filename))

}
