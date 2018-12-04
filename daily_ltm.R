## This function generates a long-term daily mean ("daily ltm") from a set of ncdf's over a user-defined start and end date
# start and end dates should be formatted as "YYYY-MM-DD"

daily_ltm = function(folder_name = ".",variable,start_date,end_date){
  require(ncdf4)
  require(ncdf4.helpers)
  require(PCICt)
  fn  = paste0(folder_name,"/",list.files(folder_name))

  var = NULL
  time = NULL
  for(i in 1:length(fn)){
    print(fn[i])
    tmp.nc = nc_open(fn[i])
    tmp.var = ncvar_get(tmp.nc,variable)
    var = abind(var,tmp.var)
    tmp.time = format(nc.get.time.series(tmp.nc, v = variable,time.dim.name = "time"),"%Y-%m-%d")
    time = c(time,tmp.time)
  }
  if(dim(var)[3] != length(time)){
    stop('Error! Time dimensions do not reconcile!')
  }
  start_date_indx = which(time == start_date)
  end_date_indx = which(time == end_date)
  var.sub = var[,,start_date_indx:end_date_indx]

  var.clim = apply(var.sub,c(1,2),mean)
  
  ## Get XY coords
  lon = ncvar_get(tmp.nc,"lon")
  lat = ncvar_get(tmp.nc,"lat")
  
  # output xyz data
  xyz = data.frame(x = as.vector(lon),y = as.vector(lat),z = as.vector(var.clim))
  colnames(xyz)[3] = variable
  return(xyz)
}


