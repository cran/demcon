testthat::test_that("polity5 source files are still available and download", {
  # The XLS Version
  polity_xls_url <-
    "http://www.systemicpeace.org/inscr/p5v2018.xls"
  polity_xls_url_response <- httr::HEAD(polity_xls_url)
  polity5_xls <- demcon::get_polity5(excel = TRUE, del_file = FALSE)
  on.exit(unlink(c(file.path(tempdir(), "p5v2018.xls")), recursive = TRUE))

  testthat::expect_equal(polity_xls_url_response$status_code, 200)

  testthat::expect_true(file.exists(file.path(tempdir(), "p5v2018.xls")))

  # The SAS Version
  polity_sas_url <-
    "http://www.systemicpeace.org/inscr/p5v2018.sav"
  polity_sas_url_response <- httr::HEAD(polity_sas_url)
  polity5_sas <- demcon::get_polity5(excel = FALSE, del_file = FALSE)
  on.exit(unlink(c(file.path(tempdir(), "p5v2018.sav")), recursive = TRUE), add = TRUE)

  testthat::expect_equal(polity_sas_url_response$status_code, 200)

  testthat::expect_true(file.exists(file.path(tempdir(), "p5v2018.sav")))
  })


testthat::test_that("polity structure(s) are the same", {

  polity5_xls <- demcon::get_polity5(excel = TRUE, del_file = FALSE)
  polity5_sas <- demcon::get_polity5(excel = FALSE, del_file = FALSE)
  on.exit(unlink(c(
    file.path(tempdir(), "p5v2018.sav"),
    file.path(tempdir(), "p5v2018.xls")
  ), recursive = TRUE))

  testthat::expect_equal(dim(polity5_xls), c(17574, 37))
  testthat::expect_equal(dim(polity5_sas), c(17574, 37))

  polity_names<-
    c("p5", "cyear", "ccode", "scode", "country", "year", "flag",
      "fragment", "democ", "autoc", "polity", "polity2", "durable",
      "xrreg", "xrcomp", "xropen", "xconst", "parreg", "parcomp", "exrec",
      "exconst", "polcomp", "prior", "emonth", "eday", "eyear", "eprec",
      "interim", "bmonth", "bday", "byear", "bprec", "post", "change",
      "d5", "sf", "regtrans")

  testthat::expect_setequal(names(polity5_xls),
                            polity_names)
  testthat::expect_setequal(names(polity5_sas),
                            polity_names)
})
