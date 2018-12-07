malt_raster <- function(r){
  require(raster)
  x <- rowFromCell(r[[1]],1:length(r[[1]]))
  y <- colFromCell(r[[1]],1:length(r[[1]]))
  variable <- cbind(x,y)
  for(i in 1:365){
    variable <- cbind(variable,as.vector(as.array(r[[i]])))
  }
  colnames(variable)<-c("x","y",1:365)
  variable <- as.data.frame(variable)
}
