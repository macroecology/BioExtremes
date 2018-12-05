wrapper <- function(baseline_name, variable_file, function_file, output_name){
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
  if(variable_file%in%filenames){
    filename = filenames[filenames==variable_file]
  }else{
    stop("Variable file name does not exist on the FTP server")
  }
  dir.create("data/variables")
  for (filename in filenames) {
    bin <- getBinaryURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/", filename), userpwd=userpwd)
    writeBin(bin, paste0("/data/variables/", filename))
  }

  #Remap baseline on regular grid
  datafiles = dir("data",full.names=TRUE,recursive=TRUE)
  baseline = datafiles[grepl(baseline_file,datafiles)]
  source("masking.R")
  l <- mask(0.5,"land")
  base = raster(baseline)
  base_regrid = resample(base, l)
  base_masked = raster::mask(base_regrid)

  #Mask and Interpolate data



  #Add to baseline
  #(at this point let's say the XY365t output is called variable)

  #Apply function
  e=new.env()
  source(function_file, local=e) #We can t assume the name of the function inside
  func=base::get(ls(env=e),env=e) #So we do witchcraft to get it
  output = data.frame(x=variable$x,y=variable$y)
  output$fd = apply(variable[,-(1:2)],1,func)
  output_rl = rasterfromXYZ(output)
  dir.create("output")
  writeRaster(output_rl, paste0("output/",output_name),"netCDF")
  #Load output on ftp server
  ftpUpload(I("output/frost_days.nc"), paste0("ftp://", userpwd, "@", "ftp.naturkundemuseum-berlin.de/", ftp_user, "/", foldernames[grep("hackathon", foldernames)], "/", filename))

}
