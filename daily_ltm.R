## This function generates a long-term daily mean ("daily ltm") from a set of ncdf's over a user-defined start and end date
# start and end dates should be formatted as "YYYY-MM-DD"
# Elizabeth Sbrocco needs to document this further...

daily_vals_model = function(filename,x = "lon",y = "lat",z,start_date = NULL,end_date = NULL){
  require(ncdf4)
  require(ncdf4.helpers)
  require(PCICt)
  require(abind)
  
  nc = nc_open(filename[i])
  time = as.Date(format(nc.get.time.series(nc, v = z,time.dim.name = "time"),"%Y-%m-%d"))
  var = ncvar_get(nc,z)
  if(length(grep("02-29",time)) > 0){
    leap.indx = grep("02-29",time)
    var = var[,,-leap.indx]
    time = time[-leap.indx]
  }
  var = var[,,which(time >= as.Date(start_date) & time <= as.Date(end_date))]
  time = time[which(time >= as.Date(start_date) & time <= as.Date(end_date))]
  
  ## Get XY coords
  lon = ncvar_get(nc,x)
  lat = ncvar_get(nc,y)
  
  if(length(dim(lon)) > 1){
    xyz = data.frame(x = as.vector(lon),y = as.vector(lat))
  } else {
    xyz = as.data.frame(x = rep(lon,length(lon)*length(lat)),
                        y = sapply(lat,function(x) rep(x,length(lon))))
  }
  
  
  for(i in 1:dim(var)[3]){
    tmp.xyz = as.vector(var[,,i])
    xyz = cbind(xyz,tmp.xyz)
  }
  
  colnames(xyz) = c("x","y",paste0(z,"_day",1:365))
  nc_close(nc)
  return(xyz)
}

daily_ltm_model = function(folder_name,x = "lon",y = "lat",z,start_date = NULL,end_date = NULL){
  require(ncdf4)
  require(ncdf4.helpers)
  require(PCICt)
  require(abind)
  fn  = paste0(folder_name,"/",list.files(folder_name))
  
  xyz = NULL
  counter = 0
  for(i in 1:length(fn)){
    print(fn[i])
    nc = nc_open(fn[i])
    time = as.Date(format(nc.get.time.series(nc, v = z,time.dim.name = "time"),"%Y-%m-%d"))
    var = ncvar_get(nc,z)
    if(length(grep("02-29",time)) > 0){
      leap.indx = grep("02-29",time)
      var = var[,,-leap.indx]
      time = time[-leap.indx]
    }
    if(!(is.null(start_date)) & !(is.null(end_date))){
      var = var[,,which(time >= as.Date(start_date) & time <= as.Date(end_date))]
      time = time[which(time >= as.Date(start_date) & time <= as.Date(end_date))]
    }
    counter = counter + length(time)/365
    tmp.xyz = NULL
    for(j in 1:365){
      if(length(time)/365 > 1){
        indx = seq(j,length(time),by = 365)
        var.sum = apply(var[,,indx],c(1,2),function(x) sum(x,na.rm = FALSE))
        tmp.xyz = cbind(tmp.xyz,as.vector(var.sum))
      } else {
        tmp.xyz = cbind(tmp.xyz,as.vector(var[,,j]))
      }
    }
    if(is.null(xyz)){
      xyz = tmp.xyz
    } else {
      xyz = xyz + tmp.xyz
    }
  }
  xyz = xyz/counter
  
  ## Get XY coords
  lon = ncvar_get(nc,x)
  lat = ncvar_get(nc,y)
  
  if(length(dim(lon)) > 1){
    xy = data.frame(x = as.vector(lon),y = as.vector(lat))
  } else {
    xy = as.data.frame(x = rep(lon,length(lon)*length(lat)),
                       y = sapply(lat,function(x) rep(x,length(lon))))
  }
  
  xyz = cbind(xy,xyz)
  colnames(xyz) = c("x","y",paste0(z,"_day",1:365))
  nc_close(nc)
  return(xyz)
}

daily_ltm_baseline = function(input_folder){
  require(raster)
  fn  = paste0(input_folder,"/",list.files(input_folder))
  ltm = NULL
  for(i in 1:365){
    print(i)
    dayi = NULL
    for(j in 1:length(fn)){
      r = brick(fn[j])
      if(length(grep("02.29",names(r))) > 0){
        leap.indx = grep("02.29",names(r))
        r = r[[-leap.indx]]
      }
      if(is.null(dayi)){
        dayi = r[[i]]
      } else {
        dayi = stack(dayi,r[[i]])
      }
    }
    dayi_ltm = calc(dayi,mean)
    names(dayi_ltm) = paste0("day",i)
    
    if(is.null(ltm)){
      ltm = dayi_ltm
    } else {
      ltm = stack(ltm,dayi_ltm)
    }
  }
  return(ltm)
}


