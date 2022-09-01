testthat::test_that("vdem source is still there and the same", {
  vdem_url <-
    "https://github.com/vdeminstitute/vdemdata/raw/master/data/vdem.RData"
  vdem_response <- httr::HEAD(vdem_url)
  vdem <- demcon::get_vdem()

  testthat::expect_equal(vdem_response$status_code, 200)

  testthat::expect_equal(dim(vdem), c(27380, 4170))

  # Check that all the VCI and HCI variables are still in w/ same names
  hci_components <- c('v2xlg_legcon', 'v2x_jucon')

  frefair_components <- c('v2elembaut','v2elembcap','v2elrgstry','v2elvotbuy',
      'v2elirreg', 'v2elfrfair')

  vci_components <- c('v2x_suffr','v2x_elecoff','v2x_frassoc_thick',
      'v2x_freexp_altinf')

  hci_vci_vars<-c(hci_components, frefair_components, vci_components)

  testthat::expect_true(all(hci_vci_vars %in% names(vdem)))
})
