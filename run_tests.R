library(testthat) 

source("C:/Users/gfand/OneDrive/Documentos/museum_hack/BioExtremes/frost_days.R")

setwd("C:/Users/gfand/OneDrive/Documentos/museum_hack/BioExtremes/tests/testthat")

test_results <- test_dir(".", reporter="summary")
