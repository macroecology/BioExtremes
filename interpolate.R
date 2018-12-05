## Note: these functions will be similar to "interpolate" function of raster
## package but it does allow to control where interpolation is made (avoid
## no data, or ocean when interpolating land)


interpolate <- function(anomaly, grid, method=spline,...) { 
    require(tidyr)
    
    # check anomaly vector  
    if((!is.vector(anomaly))) { 
        anomaly <- as.vector(anomaly)
    }
    
    # Remove rows with NA in anomaly 
    if (!all(is.na(anomaly))) {
        message("Warning: \n Rows with NA values in anomaly were removed")
        anomaly <- drop_na(anomaly)
    }
    
    # Checks grid 
    if (!(is.matrix(grid) | is.data.frame(grid))) {
        stop("A matrix or dataframe with two colums should be supplied")
    } 
    if (length(grid) < 2){
        stop("Grid object must contain at least two colums (coordinates)")
    }
    
    # Checks interpolate method 
    method(anomaly, grid, ...)
    
} 


spline <- function(x, grid, ...) {
    # Wrapper function to interpolate with thin plate splines
    # 'x' is a data.frame with 'X,Y,Anom' values
    # 'grid' is a data frame with 'X,Y' values to interpolate
    # '...' extra arguments to pass to Tps function (lon.lat=T is useful)
    require(fields)
    grd <- x[,1:2]
    val <- x[,3]
    fit <- Tps(grd, val, ...)
    predict(fit, grid)[,1]
}
    
