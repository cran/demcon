#' Prepare V-Dem Data
#'
#' Given a raw data.frame of vdem data, enact further
#' automated pre-processing.
#'
#' @param vdem A `data.frame` or `data.table` of raw vdem observations.
#' @param years A numeric vector of length 2 with start and end years to subset
#'   by.
#' @param metrics Character vector of vdem metrics of interest to subset
#'   against. These will be combined with country-year id variables by default.
#' @param drop_no_cow Logical to drop observations without Correlates of War
#'   country codes.
#' @param cow_index Logical to index vdem against valid Correlates of War
#'   country-years.
#' @param drop_pal Logical to remove all Palestine related observations.
#' @param srb_kos Logical to average metrics Serbia/Yugoslavia with Kosovo for
#'   all years < 2008.
#' @param srb_mon Logical to calculate values for the State Union of Serbia and
#'   Montenegro (2003-2006) using the average of Serbia's and Montenegro's
#'   scores. To include Kosovo, specify `srb_kos = TRUE`.
#' @param micro Logical to keep (TRUE) or drop (FALSE) microstates.
#' @param iso3 Logical to generate ISO3C country codes.
#'
#' @return A `data.frame` of post-processed vdem data.
#' @export
#'
#' @examples
#' \donttest{
#' vdem<-demcon::get_vdem(write_out = FALSE)
#'
#' vdem<-prep_vdem(vdem, years = c(2010, 2020), cow_index = TRUE, micro = FALSE)}
#'
prep_vdem<-function(
  vdem,
  years = NULL,
  metrics = NULL,
  drop_no_cow = FALSE,
  cow_index = FALSE,
  drop_pal = FALSE,
  srb_kos = FALSE,
  srb_mon = FALSE,
  micro = TRUE,
  iso3 = FALSE

){
  country_name<-COWcode<-microstate<-cowcode<-year<-NULL

  class_dt<-FALSE
  if("data.table" %in% class(vdem)){class_dt<-TRUE}
  dat<-data.table::copy(data.table::setDT(vdem))

  id.vars<-c('country_name', 'COWcode', 'histname','codingstart_contemp', 'codingend_contemp', 'year')

  if(!is.null(metrics)){
    vars<-c(id.vars, metrics)
    dat<-dat[, .SD, .SDcols = vars]}

  if(!is.null(years)){dat<-dat[year>=years[1] & year<=years[2]]}

  if(drop_pal==TRUE){

    pal_names<-c("Palestine/West Bank",
                 "Palestine/Gaza",
                 "Palestine/British Mandate")

    dat<-dat[!(country_name %in% pal_names)]
  }

  if(drop_no_cow==TRUE){

    nocow_names<-unique(dat[is.na(COWcode),country_name])
    dat<-dat[!is.na(COWcode)]}


  cols<-names(vdem)
  metrics<-!(cols %in% id.vars)
  metrics<- cols[metrics]
  metrics_num<-sapply(vdem[,.SD, .SDcols = metrics], class)
  metrics<-metrics[metrics_num=="numeric"]

  if (srb_kos == TRUE) {
    for (i in min(dat$year):2007)
      dat[COWcode %in% c(345, 347) & year == i,
          (metrics) := lapply(.SD, mean, na.rm = TRUE), .SDcols = metrics]
  }

  if (srb_mon == TRUE) {
    for (i in 1999:2005)
      dat[COWcode %in% c(345, 341) & year == i,
          (metrics) := lapply(.SD, mean, na.rm = TRUE), .SDcols = metrics]
  }

  if(cow_index==TRUE){

    cow_index<-demcon::cow_index()
    names(cow_index)[1]<-"COWcode"
    dat<-demcon::multi_sub(dat, cow_index, vars = c("COWcode", "year"))

  }

  if(iso3==TRUE){

    dat[, iso3:=countrycode::countrycode(COWcode,
                                         origin = "cown",
                                         destination = "iso3c")]

    dat<-demcon::cow_iso_clean(x = dat,
                               cow.col = "COWcode",
                               iso3.col = "iso3",
                               year.col = "year")

  }

  if(micro==FALSE){
  rlang::check_installed("states", reason = "states is required for micro==FALSE")
  microstates <- data.table::copy(data.table::setDT(states::cowstates))
  microstates <- microstates[microstate==TRUE,unique(cowcode)]
  dat<-dat[!(COWcode %in% microstates)]
  }

  if(class_dt==TRUE){data.table::setDT(dat)} else {data.table::setDF(dat)}
  dat
}
