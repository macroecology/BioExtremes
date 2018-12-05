library(config)
ftp_host = config::get("ftp")$host
ftp_user = config::get("ftp")$username
ftp_password = config::get("ftp")$password


## 2 tickets: 
## A: download a set of climatic layers stored in the FTP
## B: save a file in a defined folder in the FTP

options(timeout=300)
library(RCurl)
url <- paste (ftp_host, "/ftpuser0063/", sep="")

userpwd <- paste (ftp_user, ftp_password, sep=":")


foldernames <- getURL(url, userpwd = userpwd,
                    ftp.use.epsv = FALSE, dirlistonly=TRUE) # downloads folder names

foldernames <- strsplit(foldernames, '\n')
foldernames <- unlist(foldernames)

filenames <- getURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/"),
                    userpwd = userpwd,
                    ftp.use.epsv = FALSE, dirlistonly=TRUE) 
filenames <- strsplit(filenames, '\n')
filenames <- unlist(filenames)


# adjust foldernames, currently set to hackthon variables
for (filename in filenames) {
  bin <- getBinaryURL(paste0(url, foldernames[grep("hackathon", foldernames)], "/", filename),
                      userpwd=userpwd) 
#  if(any(grepl(".nc", dir()))){
    writeBin(bin, paste0(getwd(), "/", filename))
#  }
}


#create dummy file for test upload
upload.file <- "dummy"
write(upload.file, file="test_clim_dat.txt")
write(upload.file, file="test_clim_dat2.txt")

# adjust regex to unique filename characters
upload.files <- dir()[grep("clim_dat", dir())]

for (filename in upload.files) {
  ftpUpload(I(filename), 
            paste0("ftp://", userpwd, "@", "ftp.naturkundemuseum-berlin.de/",
                   ftp_user, "/", foldernames[grep("hackathon", foldernames)], "/", filename))
}
