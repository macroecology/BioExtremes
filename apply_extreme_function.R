applyExtreme <- function(variable_file, function_file, output_name, ftp_directory_output){
  # Function to apply the extreme functions to the variable (last step)
  # Name of the variable file
  # Name of the file to the function to apply
  # Name of the output file

  #Download baselines
  source("upload_to_ftp.R")
  library(config)
  library(RCurl)
  library(raster)
  ftp_host <- config::get("ftp")$host
  ftp_user <- config::get("ftp")$username
  ftp_password <- config::get("ftp")$password
  options(timeout=300)
  url <- paste (ftp_host, "/ftpuser0063/", sep="")
  userpwd <- paste (ftp_user, ftp_password, sep=":")
  foldernames <- getURL(url, userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE) # downloads folder names

  foldernames <- strsplit(foldernames, '\n')
  foldernames <- unlist(foldernames)
  if(!dir.exists("data")) dir.create("data")
  filenames <- getURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/"), userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE)
  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames[!grepl("^[.]+$",filenames)]
  if(variable_file%in%filenames){
    filename <- filenames[filenames==variable_file]
  }else{
    stop("Variable file name does not exist on the FTP server")
  }
  if(!dir.exists("data/variables")) dir.create("data/variables")
  bin <- getBinaryURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/", filename), userpwd=userpwd)
  writeBin(bin, paste0("/data/variables/", filename))

  #Apply function
  e <- new.env()
  source(function_file, local=e) #We can t assume the name of the function inside,
  func <- base::get(ls(env=e),env=e) #So we do witchcraft to get it
  output <- data.frame(x=variable$x,y=variable$y)
  output$fd <- apply(variable[,-(1:2)],1,func)
  output_rl <- rasterfromXYZ(output)
  if(!dir.exists("output")) dir.create("output")
  writeRaster(output_rl, paste0("output/",output_name),"netCDF")
  #Load output on ftp server
  upload(paste0("output/",output_name), ftp_directory_output, output_name)
}
