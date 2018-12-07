stack2df <- function(x, coords=TRUE) {
    ## convenient wrapper for converting a raster stack to data.frame
    ## x - a raster stack
    ## coords - if true, the two first columns are the coordinates of the raster
    if (!("RasterStack" %in% class(x)))
        stop("x must be a raster stack")
    if  (coords)
        cbind(coordinates(x), as.data.frame(x))
    else
        as.data.frame(x)
}
