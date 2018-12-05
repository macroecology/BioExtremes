setwd ("C:\\Users\\sara.varela\\Documents\\CIENCIAS\\BioExtreme")
foldername<- "anomalies_land"

download ("present_baseline", "present_baseline")

## both parameters are character

download<- function (foldername, saving_folder){

  library(config)
  ftp_host = config::get("ftp")$host
  ftp_user = config::get("ftp")$username
  ftp_password = config::get("ftp")$password

  options(timeout=300)
  library(RCurl)
  url <- paste (ftp_host, "/ftpuser0063/", sep="")
  userpwd <- paste (ftp_user, ftp_password, sep=":")

  filenames <- getURL(paste0(url, foldername, "/"),
                      userpwd = userpwd,
                      ftp.use.epsv = FALSE, dirlistonly=TRUE)

  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames [-c(1:2)]
  # adjust foldernames, currently set to hackthon variables
  dir.create (paste0(getwd(), "/data/", saving_folder))
  for (filename in filenames) {
    bin <- getBinaryURL(paste0(url, foldername, "/", filename),
                        userpwd=userpwd)
  #  if(any(grepl(".nc", dir()))){
      writeBin(bin, paste0(getwd(), "/data/", saving_folder, "/", filename))
  #  }
  }
}

upload <- function(origin_file, destination_file){
  library(config)
  library(RCurl)
  ftp_host = config::get("ftp")$host
  ftp_user = config::get("ftp")$username
  ftp_password = config::get("ftp")$password
  options(timeout=300)
  ftpUpload(I(origin_file), paste0("ftp://", userpwd, "@", gsub("^s?ftp://",ftp_host), ftp_user, "/", destination_file))
}
