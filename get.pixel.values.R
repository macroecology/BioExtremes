get.pixel.values <- function(rstack, pixel) {
    # This function accepts a raster stack and extracts a vector per day
    # it is basically a wrapper for raster subsetting
    if (!(nlayers(rstack) %in% 365:366)) {
        warning("Raster stack does not have 365 or 366 layers (days in year)")
    rstack[pixel]
}




