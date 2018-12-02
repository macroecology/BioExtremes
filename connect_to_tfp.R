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
filenames <- getURL(url, userpwd = userpwd,
                    ftp.use.epsv = FALSE,dirlistonly = TRUE) 

filenames <- strsplit(filenames, '\n') ## 

filenames = unlist(filenames)

for (filename in filenames) {
  download.file(paste(url, filename, sep = ""), paste(getwd(), "/", filename,
                                                      sep = ""))
}