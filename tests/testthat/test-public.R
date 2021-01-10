context("public.R")

test_that("get_health()", {
  expect_equal(get_health(), "{\"status\":\"NORMAL\"}")
})
