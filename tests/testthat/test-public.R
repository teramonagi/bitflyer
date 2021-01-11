context("public.R")

test_that("get_health()", {
  statuses <- c("NORMAL", "BUSY", "VERY BUSY", "SUPER BUSY", "STOP")
  expect_true(get_health() %in% sprintf("{\"status\":\"%s\"}", statuses))
})
