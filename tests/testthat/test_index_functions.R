test_that("frost.days, number of days with minimum temperature below 0ºC", {
  min_temp_try <- c(1,5,3,4,-5,6,3,8,8,10,2) # set a vector with only one value minus 0 ºC
  expect_equal(frost.days(min_temp_try), 1)
})


test_that("summer.days, number of days with maximum temperature over 25ºC", {
  max_temp_try <- c(1,5,3,4,-5,6,3,30,23,15,2) # set a vector with one value over 25 ºC
  expect_equal(summer.days(max_temp_try), 1)
})

test_that("icing.days, number of days with maximum temperature below 0ºC", {
  max_temp_try <- c(1,5,3,4,-5,6,3,30,23,15,2) # set a vector with one value below 0 ºC
  expect_equal(icing.days(max_temp_try), 1)
})

test_that("daily.temp.range, difference between the maximum and minimum temperture in a day", {
  min.temp <- -6
  max.temp <- 9
  expect_equal(daily.temp.range(max.temp, min.temp), 15)
})
