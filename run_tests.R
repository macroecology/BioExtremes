library(testthat) 

source("C:/Users/gfand/OneDrive/Documentos/museum_hack/BioExtremes/climate_index_function.R")

setwd("C:/Users/gfand/OneDrive/Documentos/museum_hack/BioExtremes/tests/testthat")

test_results <- test_dir(".", reporter="summary")
