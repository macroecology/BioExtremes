## how to run the functions in parallel
## https://nceas.github.io/oss-lessons/parallel-computing-in-r/parallel-computing-in-r.html

library(parallel)
library(MASS)

starts <- rep(100, 40)
fx <- function(nstart) kmeans(Boston, 4, nstart=nstart)
numCores <- detectCores()
numCores

system.time(
  results <- lapply(starts, fx)
)
##    user  system elapsed 
##   1.346   0.024   1.372
system.time(
  results <- mclapply(starts, fx, mc.cores = numCores)
)
##    user  system elapsed 
##   0.801   0.178   0.367
### Now let’s demonstrate with our bootstrap example:
  
  x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- seq(1, 10000)
boot_fx <- function(trial) {
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}

### not in windows! 

system.time({
  results <- mclapply(trials, boot_fx, mc.cores = numCores)
})
##    user  system elapsed 
##  25.672   1.343   5.003


