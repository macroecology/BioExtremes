frost.days <- function(min_temp){
  frostday_temp <- sum(min_temp < 0, na.rm=TRUE)
  frostday_temp
}

#' frost.days
#' 
#' Counts the number of frost days
#' 
#' The function counts the number of days where the minimum temperature is below 0, i.e., Frost Days
#' 
#' @usage frost.days(data, ...)
#' 
#' @method frost.days(data, na.rm = TRUE)
#' 
#' @param data Input vector. This vector is the minimum temperature for each day of a year for one pixel
#' @param data Output vector. This is a vector with the number of days below 0
#' 
#' @example \dontrun{
#' min_temp <- c(10,5,6,-7,10,12,20)
#'          frost.days(min_temp)
#'          }
