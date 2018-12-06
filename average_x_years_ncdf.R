download <- function (foldername, saving_folder){
  require(config)
  require(RCurl)
  ftp_host <- config::get("ftp")$host
  ftp_user <- config::get("ftp")$username
  ftp_password <- config::get("ftp")$password
  options(timeout=300)
  url <- paste(ftp_host, "/ftpuser0063/", sep="")
  userpwd <- paste(ftp_user, ftp_password, sep=":")
  filenames <- getURL(sprintf("%s/%s/%s", ftp_host, ftp_user, foldername),
                      userpwd = userpwd,
                      ftp.use.epsv = FALSE, dirlistonly=TRUE)
  filenames <- strsplit(filenames, '\n')
  filenames <- unlist(filenames)
  filenames <- filenames[-c(1:2)]
  # adjust foldernames, currently set to hackthon variables
  if(!dir.exists(saving_folder)) dir.create(saving_folder)
  for (filename in filenames) {
    bin <- getBinaryURL(sprintf("%s/%s/%s/%s",
                                ftp_host, ftp_user, folder_name, filename),
                        userpwd=userpwd)
    writeBin(bin, sprintf("/%s/%s", saving_folder, filename))
  }
}

average_x_years_ncdf <- function(ftp_folder, 
                                 year_beginning, year_end,
                                 output_file){
  saving_folder <- paste0("data/",ftp_folder)
  download(ftp_folder,saving_folder)

}