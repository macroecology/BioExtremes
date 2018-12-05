summer.days <- function(max_temp){
  summerday_temp <- sum(max_temp > 25, na.rm=TRUE)
  summerday_temp
}

#' summer.days
#' 
#' Count of days when TX (daily maximum temperature) > 25ºC.
#' 
#' The function counts the number of days where the maximum temperature is over 25ºC, i.e., Number of summer days
#' 
#' @usage summer.days(data, ...)
#' 
#' @method summer.days(data, na.rm = TRUE)
#' 
#' @param data Input vector. This vector is the maximum temperature for each day of a year for one pixel
#' @param data Output vector. This is a vector with the number of days is over 25ºC
#' 
#' @example \dontrun{
#' max_temp <- runif(365, -3, 40)
#'          summer.days(max_temp)
#'          }