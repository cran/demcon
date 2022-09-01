#' Pre-Process Chronology of Constitutional Events (CCE) Data
#'
#' @param cce A `data.frame` or `data.table` of CCE data.
#' @param cow_fix Logical to hardcode changes to CCE cowcode values for
#'   Yugoslavia/Serbia, present day Germany, and present day Yemen to match
#'   official CoW designations.
#' @param evnttype_fix Logical to hardcode (presumed) typos in `evnttype`
#'   coding.
#' @param years Numeric vector of length 2 to subset data with.
#'
#' @return A `data.frame` of pre-processed CCE data.
#'
#' @seealso [The Comparative Constitutions Project](https://comparativeconstitutionsproject.org/download-data/)
#'
#' @export
#'
#' @examples
#'
#' cce<-demcon::get_cce(del_file=TRUE, write_out = FALSE)
#'
#' cce<-demcon::prep_cce(cce, cow_fix = TRUE, evnttype_fix = TRUE)
#'
prep_cce<-function(cce, cow_fix = TRUE, evnttype_fix = TRUE,
                   years = c(min(cce$year), max(cce$year))){

  evnttype<-cowcode<-year<-NULL

  dat = data.table::as.data.table(cce)
  dat<-dat[year >= years[1] & year <= years[2]]

  if(evnttype_fix==TRUE){dat[evnttype=="samendment", evnttype:="amendment"]}

  if(cow_fix==TRUE){
    dat[cowcode==340, cowcode:=345]
    dat[cowcode==260 & year>1990, cowcode:=255]
    dat[cowcode==678 & year>1989, cowcode:=679]
  }

  data.table::setDF(dat)
  class(dat)<-c("cce", class(dat))
  dat
}
