test_that("class filter works", {
  library(sf)
  x = prep_landuse(corine_18)
  expect_equal(unique(x$CLC18),c("111","112"))
})
