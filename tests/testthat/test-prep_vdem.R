testthat::test_that("vdem hasn't changed",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  # New release?
  testthat::expect_equal(max(vdem$year), 2021)

  # Has vdem packaged data changed dimensions
  testthat::expect_equal(dim(vdem), c(27380, 4170))

  # Still multiple palestine names?
  pal_names<-c("Palestine/West Bank",
               "Palestine/Gaza",
               "Palestine/British Mandate")
  testthat::expect_equal(pal_names %in% vdem$country_name,
                         c(TRUE, TRUE, TRUE))

  # still non COW nations?
  testthat::expect_true(any(is.na(vdem$COWcode)))
})

testthat::test_that("prep vdem works",{

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)

  # metric subsetting works
  cols <- c("v2x_libdem", "v2x_polyarchy")
  vdem <- demcon::prep_vdem(vdem, metrics = cols)

  reference_names <- c("country_name", "COWcode", "histname",
                       "codingstart_contemp", "codingend_contemp",
                       "year", "v2x_libdem", "v2x_polyarchy")
  testthat::expect_setequal(names(vdem),
                            reference_names)

  # year subset working
  vdem <- demcon::prep_vdem(vdem, years = c(1995,2021))
  testthat::expect_equal(range(vdem$year), c(1995,2021))

  # drop palestine working
  vdem <- demcon::prep_vdem(vdem, drop_pal = TRUE)
  pal_names<-c("Palestine/West Bank",
               "Palestine/Gaza",
               "Palestine/British Mandate")
  testthat::expect_equal(pal_names %in% vdem$country_name,
                         c(FALSE, FALSE, FALSE))

  # test drop non COW
  vdem <- demcon::prep_vdem(vdem, drop_no_cow = TRUE)
  testthat::expect_false(any(is.na(vdem$COWcode)))

  # serbia/kosovo averaging
  # first check they're still separate
  testthat::expect_false(vdem[COWcode == 345 &
                                year == 2006, v2x_libdem] == vdem[COWcode == 347 &
                                                                    year == 2006, v2x_libdem])
  vdem <- demcon::prep_vdem(vdem, srb_kos = TRUE)
  # now test they averaged correctly
  testthat::expect_identical(vdem[COWcode==345 & (year %in% 1999:2007),v2x_libdem],
                             vdem[COWcode==347 & (year %in% 1999:2007),v2x_libdem])


  # serbia and montenegro
  # first check they're still separate
  testthat::expect_false(vdem[COWcode == 345 &
                                year == 2004, v2x_libdem] == vdem[COWcode == 341 &
                                                                    year == 2004, v2x_libdem])
  vdem <- demcon::prep_vdem(vdem, srb_mon = TRUE)
  # now test they averaged correctly
  testthat::expect_identical(vdem[COWcode==345 & (year %in% 1999:2005),v2x_libdem],
                             vdem[COWcode==341 & (year %in% 1999:2005),v2x_libdem])

  # iso3c works
  vdem <- demcon::prep_vdem(vdem, iso3 = TRUE)

  testthat::expect_true("iso3" %in% names(vdem))

  testthat::expect_equal(length(unique(vdem$iso3)), 177)

  # microstates
  vdem <- demcon::prep_vdem(vdem, micro = FALSE)

  microstates <- data.table::copy(data.table::setDT(states::cowstates))
  microstates <- microstates[microstate==TRUE,unique(cowcode)]

  testthat::expect_false(all(microstates %in% vdem$COWcode))
})
