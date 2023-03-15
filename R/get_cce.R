#' Retrieve Chronology of Constitutional Events Dataset
#'
#' Downloads the Chronology of Constitutional Events (CCE) Dataset to a
#' temporary directory from the Comparative Constitutions Project website.
#'
#' @param load Logical to load downloaded data into local environment.
#' @param del_file Logical to delete downloaded and unzipped files/directories
#'   after loading into the local environment.
#' @param write_out Logical to write the CCE dataset to your local directory as
#'   a `.csv` file.
#'
#' @return A data.frame of CCE country-year data.
#' @export
#'
#' @details
#' ## The CCE Dataset
#'
#' The Chronology of Constitutional Events (CCE) is a narrowly focused offering
#' containing annual country-year observations of generalized "constitutional
#' events". There are 6 unique designations:
#'
#' 1. New Constitution
#' 2. Amendment
#' 3. Interim Constitution
#' 4. Suspended Constitution
#' 5. Reinstated Constitution
#' 6. Non-Event (years without the above)
#'
#'The limited scope of the CCE lends itself more to timeline visualizations or a
#'quick reference, but could be helpful when used in conjunction with additional
#'datasets or in other applications. CCE could also be used to derive
#'quantitative metrics of constitutional stability similar to those included
#'with version 2.0 of the Institutions and Elections Project.
#'
#' ### Variables
#'
#' Version 1.3 of the CCE dataset contains 20,429 observations and 6 variables. The include:
#'
#' \describe{
#' \item{cowcode}{The numeric Correlates of War country code.}
#' \item{country}{The CCE country name.}
#' \item{year}{Year of observation.}
#' \item{systid}{CCE identification number for the constitutional system.}
#' \item{evntid}{CCE identification number for the constitutional event.}
#' \item{evnttype}{CCE event type; see above.}
#' }
#'
#' @seealso [The Comparative Constitutions Project](https://comparativeconstitutionsproject.org/download-data/)
#'
#' @examples
#'
#' cce<-get_cce(del_file=TRUE, write_out = FALSE)
#'
get_cce<-function(load=TRUE, del_file=TRUE, write_out = FALSE){

cce_url<-"https://comparativeconstitutionsproject.org/data/ccpcce_v1_3.zip"

cce_response <- httr::HEAD(cce_url)
if(cce_response$status_code!=200){stop("CCE data no longer available at given address.")}

if(!file.exists(file.path(tempdir(), "ccpcce_v1_3.zip"))) {
  utils::download.file(cce_url, file.path(tempdir(), "ccpcce_v1_3.zip"))
}

utils::unzip(zipfile = file.path(tempdir(),"ccpcce_v1_3.zip"), exdir = tempdir())

if(load==TRUE) {
  cce <-
    data.table::fread(file.path(tempdir(), "ccpcce/ccpcce_v1_3.txt"))
}

if(del_file==TRUE) {
  unlink(c(
    file.path(tempdir(), "ccpcce_v1_3.zip"),
    file.path(tempdir(), "ccpcce"),
    file.path(tempdir(), "manifest.txt")
  ), recursive = TRUE)
}

if(write_out==TRUE){
  data.table::setDT(cce)
  data.table::fwrite(cce, "cce.csv")
}

data.table::setDF(cce)
cce
}
