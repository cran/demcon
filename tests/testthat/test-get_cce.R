testthat::test_that("cce source is still there and downloads", {
  cce_url <-
    "https://comparativeconstitutionsproject.org/data/ccpcce_v1_3.zip"
  cce_response <- httr::HEAD(cce_url)
  cce <- demcon::get_cce(del_file = FALSE)
  on.exit(unlink(c(file.path(tempdir(), "ccpcce_v1_3.zip"),
                   file.path(tempdir(), "ccpcce"),
                   file.path(tempdir(), "manifest.txt")), recursive = TRUE))

  testthat::expect_equal(cce_response$status_code, 200)

  testthat::expect_true(file.exists(file.path(tempdir(), "ccpcce_v1_3.zip")))
})

testthat::test_that("cce structure is the same", {

  cce <- demcon::get_cce(del_file = FALSE)
  on.exit(unlink(c(file.path(tempdir(), "ccpcce_v1_3.zip"),
                   file.path(tempdir(), "ccpcce"),
                   file.path(tempdir(), "manifest.txt")), recursive = TRUE))
  testthat::expect_equal(dim(cce), c(20429, 6))

  testthat::expect_setequal(names(cce),
                            c("cowcode",
                              "country",
                              "year",
                              "systid",
                              "evntid",
                              "evnttype"))
})
