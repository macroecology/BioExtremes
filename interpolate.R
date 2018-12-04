## Note: these functions will be similar to "interpolate" function of raster
## package but it does allow to control where interpolation is made (avoid
## no data, or ocean when interpolating land)


spline <- function(x, grid, ...) {
    # Wrapper function to interpolate with thin plate splines
    # 'x' is a data.frame with 'Anom,X,Y values'
    # 'grid' is a data frame with 'X,Y' values to interpolate
    # '...' extra arguments to pass to Tps function (lon.lat=T is useful)
    require(fields)
    grd <- x[,2:3]
    val <- x[,1]
    fit <- Tps(grd, val, ...)
    predict(fit, x = grid)[,1]
}
    
