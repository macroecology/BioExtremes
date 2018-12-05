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
for (filename in filenames) {
  bin <- getBinaryURL(paste0(url, foldernames[grep("present_baseline", foldernames)], "/", filename), userpwd=userpwd)
  writeBin(bin, paste0(getwd(), "/data/baseline/", filename))
}

#Download data
filenames <- getURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/"), userpwd = userpwd, ftp.use.epsv = FALSE, dirlistonly=TRUE)
filenames <- strsplit(filenames, '\n')
filenames <- unlist(filenames)
filenames <- filenames[!grepl("^[.]+$",filenames)]
# adjust foldernames, currently set to hackthon variables
dir.create("data/variables")
for (filename in filenames) {
  bin <- getBinaryURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/", filename), userpwd=userpwd)
  writeBin(bin, paste0(getwd(), "/data/variables/", filename))
}

#Remap baseline on regular grid
datafiles = dir("data",full.names=TRUE,recursive=TRUE)
baselines = datafiles[grepl("baseline/",datafiles)]
source("masking.R")
l <- mask(0.5,"land")
base = raster(baselines[1])
base_regrid = resample(base, l)

#Mask and Interpolate data



#Add to baseline
#Apply function
#Load output on ftp server
