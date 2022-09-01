testthat::test_that("vci produces missing var error",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  frefair_components <-
    c('v2elembaut',
    #  'v2elembcap',
    #  'v2elrgstry',
      'v2elvotbuy',
      'v2elirreg',
      'v2elfrfair')

  vci_components <-
    c('v2x_suffr',
      'v2x_elecoff',
      'v2x_frassoc_thick',
      'v2x_freexp_altinf')

  var_check<-c("country_name", "year", frefair_components,vci_components)
  vdem<-vdem[,..var_check]

  testthat::expect_error(vci<-demcon::vci(vdem = vdem, append = FALSE),
                         "does not contain the necessary indicators")

  testthat::expect_error(vci<-demcon::vci(vdem = vdem, append = TRUE),
                         "does not contain the necessary indicators")
})

testthat::test_that("vci produces NA warning and NA values", {

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  frefair_components <-
    c('v2elembaut',
      'v2elembcap',
      'v2elrgstry',
      'v2elvotbuy',
      'v2elirreg',
      'v2elfrfair')

  vci_components <-
    c('v2x_suffr',
      'v2x_elecoff',
      'v2x_frassoc_thick',
      'v2x_freexp_altinf')

  var_check<-c("country_name", "year", frefair_components,vci_components)

  incomplete<-!complete.cases(vdem[,..var_check])
  vdem<-vdem[incomplete,..var_check]

  testthat::expect_warning(vci<-demcon::vci(vdem = vdem, append = TRUE),
                         "The input dataframe contains NAs for some of the 10")

  vci<-demcon::vci(vdem = vdem, append = FALSE)
  testthat::expect_true(any(is.na(vci)))

})

testthat::test_that("vci calculation is correct",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  vci_components <- data.table::data.table(
      v2elembaut=c(2.6, 1.2, 3.5, 2.1),
      v2elembcap=c(-0.78, NA, 3.2, 0.05),
      v2elrgstry=c(1, 1.6, -0.45, -0.2),
      v2elvotbuy=c(0.1, -0.04, 1.3, 1.1),
      v2elirreg=c(0.26, -1.05, 0.683, 0.2),
      v2elfrfair=c(1.6, -2.6, 0.04, 0.3),
      v2x_suffr=c(1,1,0.994, 1),
      v2x_elecoff=c(0.5,1,0.88, 0.6),
      v2x_frassoc_thick=c(0.232,0.9,0.88, 0.7),
      v2x_freexp_altinf=c(0.012,0.7,0.98, 0.9))

  test_vci<-demcon::vci(vci_components, append = TRUE)

  testthat::expect_equal(round(test_vci$vci, 6),
                        c(0.000363 , NA, 0.754359, 0)
)
})
