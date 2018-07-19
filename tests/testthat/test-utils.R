context("utils.R")

test_that("get_from_env_or_global_env() works", {
  expect_null(get_from_env_or_global_env("HOGE"))
  # Global variable
  HOGE <- 123
  assign("HOGE", 123, envir=.GlobalEnv)
  expect_equal(get_from_env_or_global_env("HOGE"), 123)
  rm(HOGE, envir=.GlobalEnv)
  expect_null(get_from_env_or_global_env("HOGE"))
  # Environment variable
  Sys.setenv(HOGE = "ABC")
  expect_equal(get_from_env_or_global_env("HOGE"), "ABC")
  Sys.unsetenv("HOGE")
  expect_null(get_from_env_or_global_env("HOGE"))
})

test_that("calling_function_name() works", {
  f1 <- function(){calling_function_name(level=-1)}
  cf1 <- f1()
  expect_equal(cf1, "f1")
})


test_that("check_region() works", {
  # Japan
  for(region in c("", "jpn", "jp")){
    expect_equal(check_region(region), "")
  }

  # UAA
  for(region in c("usa", "us")){
    expect_equal(check_region(region), "usa")
  }

  # EURO
  for(region in c("eu", "euro")){
    expect_equal(check_region(region), "eu")
  }

  # Raise errors
  expect_error(check_region("chaina"))
  expect_error(check_region("japon"))
})
