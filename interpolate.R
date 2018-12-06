## Note: these functions will be similar to "interpolate" function of raster
## package but it does allow to control where interpolation is made (avoid
## no data, or ocean when interpolating land)

## Example use with decimal degrees lat an lon:
## interpolate(anom, grid)

clim.interpolate <- function(anomaly, grid, imethod=spline, use.direction=TRUE, ...) { 
    # It receives a raster stack, interpolates and returns a matrix
    # Anomaly - raster stack with nlayers as nDays
    # grid - X,Y defining interpolation locations
    # imethod - Interpolation function (default is spline)
    # use.direction - use cosine directions instead of true coordinates (spherical)

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
    colnames(intpl) <- c(colnames(grid), names(anomaly))

    if (use.direction) {
        anom.grid <- dircos(anom.grid) * 6371 # earth radius km
        grid <- dircos(grid) * 6371  
    }

    for (i in 1:n) {
        anom.values <- anomaly[[i]][]
        dt.mask <- !is.na(anom.values)
        x <- anom.values[dt.mask]
        x.grid <- anom.grid[dt.mask,]
        intpl[,i+2] <- imethod(x, x.grid, grid, ...)
    }
    intpl    
} 

dircos <- function(x1) {
    # Calculates the directions of the coordinate vectors to approximate
    # great circle distances (adapted from Tps package)
    # x1 - is a table with (lon,lat) coordinates.
    coslat1 <- cos((x1[, 2] * pi)/180)
    sinlat1 <- sin((x1[, 2] * pi)/180)
    coslon1 <- cos((x1[, 1] * pi)/180)
    sinlon1 <- sin((x1[, 1] * pi)/180)
    data.frame(a=coslon1*coslat1, b=sinlon1*coslat1, c=sinlat1)
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
    


inv.dist.w <- function(x, original, target, ...) {
    # Wrapper function to interpolate with inverse distance weights
    # 'x' is a vector with values to interpolate
    # 'original' is a grid (X,Y) with coordinates locations of x
    # 'target' is a grid (X,Y) with locations to interpolate into
    # '...' extra arguments to pass to idw function (nmax or maxdist)
    require(gstat)
    x <- data.frame(x)
    coordinates(x) <- original
    target <- SpatialPoints(target)
    pred <- idw(x~1, x, target, ...)
    pred$var1.pred
}
