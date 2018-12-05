## Note: these functions will be similar to "interpolate" function of raster
## package but it does allow to control where interpolation is made (avoid
## no data, or ocean when interpolating land)

## Example use with decimal degrees lat an lon:
## interpolate(anom, grid, lon.lat=T)

interpolate <- function(anomaly, grid, method=spline, ...) { 
    # It receives a raster stack, interpolates and returns a matrix
    # Anomaly - raster stack with nlayers as nDays
    # grid - X,Y defining interpolation locations
    # method - Interpolation function (default is spline)

    # Check if anomaly is a raster stack
    if (!("RasterStack" %in% class(anomaly))) {
        stop("Anomaly must be a raster stack")
    }

    # Checks grid 
    if (!(is.matrix(grid) | is.data.frame(grid))) {
        stop("A matrix or dataframe with two colums should be supplied")
    } 

    anom.grid <- coordinates(anomaly)
    n <- nlayers(anomaly)

    # Matrix to store interpolation results
    intpl <- matrix(NA, nrow(grid), n+2)
    intpl[,1:2] <- as.matrix(grid)

    for (i in 1:n) {
        anom.values <- anomaly[[i]][]
        dt.mask <- !is.na(anom.values)
        x <- anom.values[dt.mask]
        x.grid <- anom.grid[dt.mask,]
        intpl[,i+2] <- method(x, x.grid, grid)
    }
    colnames(intpl) <- c(colnames(grid), names(anomaly))
    intpl    
} 


spline <- function(x, original, target, ...) {
    # Wrapper function to interpolate with thin plate splines
    # 'x' is a vector with values to interpolate
    # 'original' is a grid (X,Y) with coordinates locations of x
    # 'target' is a grid (X,Y) with locations to interpolate into
    # '...' extra arguments to pass to Tps function (lon.lat=T is useful)
    require(fields)
    fit <- Tps(original, x, ...)
    predict(fit, target)[,1]
}
    
