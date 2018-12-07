stack2df <- function(x, coords=TRUE) {
    ## convenient wrapper for converting a raster stack to data.frame
    ## x - a raster stack
    ## coords - if true, the two first columns are the coordinates of the raster
    if (!("RasterStack" %in% class(x)))
        stop("x must be a raster stack")
    if  (coords)
        data.frame(coordinates(st), as.data.frame(st))
    else
        as.data.frame(st)
}
