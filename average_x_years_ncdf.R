average_x_years_ncdf <- function(ftp_folder,
                                 year_beginning, year_end,
                                 output_file){
  source("download_from_ftp.R")
  saving_folder <- paste0("data/",ftp_folder)
  download(ftp_folder,saving_folder)

}
