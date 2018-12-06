upload <- function(origin_file, destinqtion_folder, destination_file){
  library(config)
  library(RCurl)
  ftp_host <- config::get("ftp")$host
  ftp_user <- config::get("ftp")$username
  ftp_password <- config::get("ftp")$password
  options(timeout=300)
  dest <- sprintf("ftp://%s:%s@%s/%s/%s/%s",
                  ftp_user,ftp_password,
                  gsub("^s?ftp://",ftp_host),
                  ftp_user,
                  destination_folder, destination_file)
  ftpUpload(I(origin_file), dest)
}
