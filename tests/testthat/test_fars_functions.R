library(tester)
context("tester")

test_that("fars_read returns a data frame", {
  expect_true(is.data.frame(fars_read(make_filename(2015))))
})

test_that("fars_read_years returns a list", {
  expect_that(is.list(fars_read_years(c(2013, 2014, 2015))), is_true())
})

test_that("fars_summarize_years returns a data frame", {
  expect_that(is.data.frame(fars_summarize_years(c(2013, 2014, 2015))), is_true())
})
