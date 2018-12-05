# This script contains all the small functions neccesary to calculate the 27 climatic index

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


icing.days <- function(x){
  iceday_temp <- sum(x < 0, na.rm=TRUE)
  iceday_temp
}

#' icing.days
#' 
#' Counts the number of icing days
#' 
#' The function counts the number of days where the maximum temperature is below 0, i.e., Icing Days
#' 
#' @usage icing.days(data, ...)
#' 
#' @method icing.days(data, na.rm = TRUE)
#' 
#' @param data Input vector. This vector is the maximum temperature for each day of a year for one pixel
#' @param data Output vector. This is a vector with the number of days with maximum temperature below 0
#' 
#' @example \dontrun{
#' max_temp <- c(10,5,6,-7,10,12,20)
#'          icing.days(max_temp)
#'          }


daily.temp.range <- function(max.temp, min.temp){
  
  DTR <- (max.temp - min.temp)
  DTR
  
}

#' Daily temperature range
#' 
#' Calcultaes the daily temperature range
#' 
#' The function calculates the temperature difference between the maximum and minimum temperature for a given day
#' 
#' @usage daily.temp.range(max.temp, min.temp)
#' 
#' @param data Input vector. This is two vectors, one for the minimum temperature and one for the maximum temperature of a single day
#' @param data Output vector. This is a vector which reports the temperature range 
#' 
#' @example \dontrun{
#' daily.temp.range(data.min.temp, data.max.temp)
#'    }
#' @example \dontrun{
#' min.temp <- -6
#' max.temp <- 9
#' daily.temp.range(max.temp, min.temp)
#'     }
#'     
#'     