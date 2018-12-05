#Function to get variable name and dimension names
#from a ncdf file
ncdf_names=function(ncdf){
  var=c("sst","tos")[c("sst","tos")%in%names(ncdf$var)]
  list("variable"=var,
       "dimension"=sapply(ncdf$var[[var]]$dim,function(x)x$name))
}
