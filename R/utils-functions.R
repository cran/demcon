#' Multiple Column Subset
#'
#' @param dat A \code{data.table} to be subsetted.
#' @param key.dat A \code{data.table} containing multiple columns used
#'   to index and subset \code{dat}.
#' @param vars Character string of columns in \code{key.dat} to be used for
#'   subsetting.
#'
#' @return A \code{data.frame, data.table} subsetted by \code{key.dat}.
#' @export
#' @examples
#'
#' \donttest{
#' cow_index<-demcon::cow_index()
#' names(cow_index)[1]<-"COWcode"
#' dat <- demcon::get_vdem()
#'
#' dat <- demcon::multi_sub(dat, cow_index, vars = c("COWcode", "year"))}
#'
multi_sub <- function(dat, key.dat, vars = names(key.dat)) {

  dat_class<-class(dat)
  key_class<-class(key.dat)

  data.table::setDT(dat)
  data.table::setDT(key.dat)
  keeps = sort(dat[key.dat, on = vars, which = TRUE, nomatch = 0])
  dat <- dat[keeps]

  if(!("data.table" %in% dat_class)){
  data.table::setDF(dat)}
  if(!("data.table" %in% key_class)){
  data.table::setDF(key.dat)}
  return(dat)
}

#' Standardize a Variable to 0-1
#'
#' Standardize a vector to 0-1 using the cumulative distribution function
#' of the normal distribution.
#'
#' @param x A vector of numeric values.
#'
#' @return A standardized numeric vector scaled to 0-1.
#' @export
#'
#' @examples
#'
#' nums<-rnorm(50, 6.5, 3)
#'
#' nums<-demcon::range01(nums)
#'
range01 <- function(x){(x-min(x, na.rm=TRUE))/(max(x, na.rm=TRUE)-min(x, na.rm=TRUE))}

#' CoW States Index
#'
#' Create an annual index of valid Correlates of War Nations States.
#'
#' @return A `data.frame` of annual CoW states.
#' @export
#'
#' @examples
#'
#' cow_index<-demcon::cow_index()
#'
#' @details This function generates a dataset to be used for indexing
#'   country-year datasets against the validated CoW states membership. In
#'   short, it will permit the user to quickly drop observations from
#'   country/territory-year data that although they are commonly included in a
#'   variety of political/geographical datasets, these nations or territories
#'   may be disputed (Palestine, Kosovo pre 2008), have a parent nation (Puerto
#'   Rico), or have other peculiarities that do not align with international
#'   standards (CoW, G&W, WDI, IMF).
#'
#'   This is built off of the `states` packages, which matched the official
#'   Correlates of War record at the time of publishing.
cow_index<-function(){
  rlang::check_installed(c("lubridate", "states"), "required for cow indexing")
  start <- end <- cowcode <- cowc <- country_name <- microstate <- NULL
  cow_states<-data.table::setDT(states::cowstates)
  cow_states[,start:=lubridate::year(start)][,end:=lubridate::year(end)][end==9999,end:=2022]
  cow_states<-cow_states[,list(cowcode,cowc,country_name,year=seq(start,end), microstate),
                         by=1:nrow(cow_states)][,nrow:=NULL]

  cow_states
}
