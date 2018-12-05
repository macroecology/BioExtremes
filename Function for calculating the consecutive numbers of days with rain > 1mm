#' Consecutive days of precipitation
#' 
#' Calcultaes the number of consecutive days of rain
#' 
#' The function calculates the number of consecutive days
#' 
#' @usage consec.precip.days(data)
#' 
#' @param data Input vector. This is a vector with the precipitation for each day in one year in one cell
#' @param data Output vector. This is a vector which reports the highest number of consecutive days of rain 
#' 
#' @example \dontrun
#' consec.precip.days(data)
#' 
#' @example \dontrun
#' precipitation <- c(0,0,0,0,0,1,2,0,0,3,3,5,6,0)
#'          
#' consec.precip.days(precipitation)

consec.precip.days <- function(precipitation){

  precip.days <- 0  
  counter <- 0
  for (i in 1: length (precipitation)){
  
    if (precipitation[[i]] > 1){
    
      counter <- counter + 1
    
    }else{
    
      counter <- 0
    
    }
  
    if (counter > precip.days){
  
      precip.days <- counter
    }
  }
  
  precip.days
}

consec.precip.days(precipitation)
