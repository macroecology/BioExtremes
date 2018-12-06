applyExtreme <- function(variable_file, function_file, output_name, ftp_directory_output){
  # Function to apply the extreme functions to the variable (last step)
  # Name of the variable file
  # Name of the file to the function to apply
  # Name of the output file
  mat2xyz <- function(mat, lon, lat){
    #Takes a variable matrix and 2 dimensions vectors and output a XYZ dataframe
    lonlat = expand.grid(lon, lat)
    sst = as.vector(mat)
    data.frame(x=lonlat[,1], y=lonlat[,2], z=sst)
  }
  #Download baselines
  require(raster)
  source("upload_to_ftp.R")
  download(variable_file,"/data/variables/")

  r <- stack(paste0("/data/variables/",variable_file)
  x <- rowFromCell(r[[1]],1:length(r[[1]]))
  y <- colFromCell(r[[1]],1:length(r[[1]]))
  variable <- cbind(x,y)
  for(i in 1:365){
    variable <- cbind(variable,as.vector(as.array(r[[i]])))
  }
  colnames(variable)<-c("x","y",1:365)
  variable <- as.data.frame(variable)
  #Apply function
  e <- new.env()
  source(function_file, local=e) #We can t assume the name of the function inside,
  func <- base::get(ls(env=e),env=e) #So we do witchcraft to get it
  output <- data.frame(x=variable$x,y=variable$y)
  output$fd <- apply(variable[,-(1:2)],1,func)
  output_rl <- rasterfromXYZ(output)
  if(!dir.exists("output")) dir.create("output")
  writeRaster(output_rl, paste0("output/",output_name),"netCDF")
  #Load output on ftp server
  upload(paste0("output/",output_name), ftp_directory_output, output_name)
}
