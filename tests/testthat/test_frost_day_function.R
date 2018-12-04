test_that("frost.days with ony one day below 0ºC", {
  min_temp_try <- c(1,5,3,4,-5,6,3,8,8,10,2) # set a vector with only one value minus 0 ºC
  expect_equal(frost.days(min_temp_try), 1)
})
