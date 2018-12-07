download <- function (foldername, saving_folder){
  #foldername is the path to the folder to download on the ftp
  #saving_folder is the path of where to save the download, relative to the current path
  require(config)
  require(RCurl)
  ftp_host <- config::get("ftp")$host
  ftp_user <- config::get("ftp")$username
  ftp_password <- config::get("ftp")$password
  options(timeout=300)
  userpwd <- sprintf("%s:%s",ftp_user, ftp_password)
  filenames <- getURL(sprintf("%s/%s/%s/", ftp_host, ftp_user, foldername),
                      userpwd = userpwd,
                      ftp.use.epsv = FALSE, dirlistonly=TRUE)
  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames[!grepl("^[.]+$",filenames)]
  # adjust foldernames, currently set to hackthon variables
  if(!dir.exists(saving_folder)) dir.create(saving_folder,recursive=TRUE)
  for (filename in filenames) {
    bin <- getBinaryURL(sprintf("%s/%s/%s/%s",
                                ftp_host, ftp_user, foldername, filename),
                        userpwd=userpwd)
    writeBin(bin, sprintf("./%s/%s", saving_folder, filename))
  }
}
