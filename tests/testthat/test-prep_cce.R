testthat::test_that("prep cce completes prep",{

  cce<-demcon::get_cce()
  cce<-demcon::prep_cce(cce, cow_fix = TRUE, evnttype_fix = TRUE)

  testthat::expect_s3_class(cce, "cce")

  data.table::setDT(cce)

  testthat::expect_setequal(unique(cce$evnttype),
                            c("new", "non-event",
                              "amendment", "interim",
                              "reinstated", "suspension"))

  testthat::expect_equal(nrow(cce[cowcode==260 & year > 1990]),0)
  testthat::expect_equal(nrow(cce[cowcode==678 & year > 1989]),0)
  testthat::expect_equal(nrow(cce[cowcode==340]),0)

})
