testthat::test_that("multi_sub indexes properly", {
  cce<-demcon::get_cce()
  data.table::setDT(cce)
  cce<-cce[year>1990]

  cow_index<-data.table::setDT(demcon::cow_index())
  cow_index<-cow_index[year>1990]
  nrow(unique(cow_index[,.(cowcode,year)]))

  cow_sub_out<-demcon::multi_sub(dat=cce, key.dat = cow_index,
                                 vars = c("cowcode","year"))
  cow_sub_out[,country_year:=paste(cowcode,year,sep="-")]
  cow_index[,country_year:=paste(cowcode,year,sep="-")]

  testthat::expect_true(
    all(cow_sub_out$country_year %in% cow_index$country_year))

  cce[,country_year:=paste(cowcode,year,sep="-")]
  cce_not_cow<-!(cce$country_year %in% cow_sub_out$country_year)
  cce_not_cow<-cce[cce_not_cow,country_year]

  testthat::expect_false(
    all(cce_not_cow %in% cow_index$country_year))
})
