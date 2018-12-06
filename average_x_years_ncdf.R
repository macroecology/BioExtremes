average_x_years_ncdf <- function(ftp_folder_input,
                                 year_start, year_end,
                                 ftp_folder_output, output_file){
  # Function to make the baseline based on content of ftp folder
  # for a specified year range

  #Download folder
  source("download_from_ftp.R")
  saving_folder <- paste0("data/",ftp_folder)
  download(ftp_folder_input,saving_folder)

  begin <- as.Date(paste0(year_start,"-01-01"))
  end <- as.Date(paste0(year_end,"-12-31"))
  #Read all files
  all_files <- list()
  result <- list()
  files <- dir(saving_folder)
  for(i in seq_along(files)){
    r <- stack(files[i])
    d <- as.Date(gsub("^X","",names(r)),
                 tryFormats = c("%Y-%m-%d", "%Y/%m/%d","%Y.%m.%d"))  #Can we assume date to be in one of those formats?
    r <- subset(r, which(d>=begin & d<=end))           #Get rid of dates outside range
    r <- subset(r, which(format(d,"%m.%d")!="02.29"))  #Get rid of 29th of february if any
    if(nlayers(r)>0) all_files[[i]] <- r
  }
  all_files <- all_files[sapply(all_files,length)]
  stacked <- stack(all_files)

  for(j in 1:365){
    d <- format(as.date(paste0("2015-",j),"%Y-%j"),"%m-%d") #2015 as it's a typical non-leap year
    n <- as.Date(gsub("^X","",names(r)),
                 tryFormats = c("%Y-%m-%d", "%Y/%m/%d","%Y.%m.%d"))
    s <- subset(stacked, which(format(n,"%m-%d")==d))
    result[[j]] <- calc(s, mean)
  }
  out <- stack(result)
  if(out$xmax==360) out <- rotate(out)
  writeRaster(result, paste0("data/",output_file),"netCDF")
  upload(output_file, ftp_folder_output, output_file) #where do we want to save it?
}
