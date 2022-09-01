testthat::test_that("cow_iso_clean makes changes", {

  vdem<-demcon::get_vdem()
  data.table::setDT(vdem)
  vdem<-vdem[,.(country_name,COWcode,year)]

  testthat::expect_warning(countrycode::countrycode(vdem$COWcode, origin = "cown", destination = "iso3c"),
                           "Some values were not matched unambiguously")

  vdem$iso3<-countrycode::countrycode(vdem$COWcode, origin = "cown", destination = "iso3c")

  vdem <- demcon::cow_iso_clean(x = vdem,
                                cow.col = "COWcode",
                                year.col = "year",
                                iso3.col = "iso3")
  data.table::setDT(vdem)

  cowcode=c(260,265,315,345,345,345,347,511,678,680,816,816,817)
  iso3c=c("DEU","GDR","CSK","YUG","SCG","SRB","XKX","EAZ","YEM","YMD","VDR","VNM","VNM")

  reference<-data.table::data.table(cowcode=cowcode,
                                    iso3c=iso3c)
  cow.col = "COWcode"
  iso3.col = "iso3"

  names(reference)<-c(cow.col,iso3.col)
  reference<-reference[order(get(cow.col))]
  cols<-c(cow.col,iso3.col)
  observed<-unique(vdem[get(cow.col) %in% cowcode,..cols])
  observed<-observed[order(get(cow.col))]

  # This doesn't account for the specific years, but if this is right the
  # function is most likely working as intended; especially if "SCG" is listed.

  testthat::expect_equal(reference,observed)

  })
