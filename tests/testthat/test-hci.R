testthat::test_that("hci produces missing var error",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  hci_components <- c('v2xlg_legcon',
                      'v2x_jucon')


  var_check<-c("country_name", "year", hci_components[1])
  vdem<-vdem[,..var_check]

  testthat::expect_error(hci<-demcon::hci(vdem = vdem, append = FALSE),
                         "does not contain the necessary indicators")

  testthat::expect_error(hci<-demcon::hci(vdem = vdem, append = TRUE),
                         "does not contain the necessary indicators")
})

testthat::test_that("hci produces NA warning and NA values", {

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  hci_components <- c('v2xlg_legcon', 'v2x_jucon')

  var_check<-c("country_name", "year", hci_components)

  incomplete<-!complete.cases(vdem[,..var_check])
  vdem<-vdem[incomplete,..var_check]

  testthat::expect_warning(hci<-demcon::hci(vdem = vdem, append = TRUE),
                           "Any input observations that contain NA")

  hci<-demcon::hci(vdem = vdem, append = FALSE)
  testthat::expect_true(any(is.na(hci)))

})

testthat::test_that("hci calculation is correct",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  hci_components <- data.table::data.table(
    v2xlg_legcon=c(0.8, 0.5, .8, 0.2),
    v2x_jucon=c(0.78, NA, .32, 0.05))

  test_hci<-demcon::hci(hci_components, append = TRUE)

  testthat::expect_equal(test_hci$hci,
                         c(0.790 , NA, 0.560, 0.125)
  )
})
