library(config)
ftp_host = config::get("ftp")$host
ftp_user = config::get("ftp")$username
ftp_password = config::get("ftp")$password


## 2 tickets: 
## A: download a set of climatic layers stored in the FTP
## B: save a file in a defined folder in the FTP


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
