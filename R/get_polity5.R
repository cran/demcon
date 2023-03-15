#' Retrieve the Polity5 Dataset
#'
#' Download the Polity5 Dataset from the Center for Systemic Peace website.
#'
#' @param load Logical to load downloaded data into local environment.
#' @param del_file Logical to delete downloaded and unzipped files/directories
#'   after loading into the local environment.
#' @param excel Logical to download the `.xls` (`TRUE`) or the SAS `.sav` format
#'   (`FALSE`).
#' @param write_out Logical to write the Polity 5 dataset to your local
#'   directory as a `.csv` file.
#'
#' @return A data.frame of Polity5 country-year data.
#' @export
#'
#' @examples
#'\donttest{
#' polity <- demcon::get_polity5(excel = TRUE, del_file = TRUE, write_out = FALSE)}
#'
#' @details
#'
#' ## Polity5
#'
#' The Polity5 project continues the Polity research tradition of coding the
#' authority characteristics of states in the world system for purposes of
#' comparative, quantitative analysis. The original Polity conceptual scheme was
#' formulated and the initial Polity I data collected under the direction of Ted
#' Robert Gurr and informed by foundational, collaborative work with Harry
#' Eckstein, Patterns of Authority: A Structural Basis for Political Inquiry
#' (New York: John Wiley & Sons, 1975). The Polity project has proven its value
#' to researchers over the years, becoming the most widely used resource for
#' monitoring regime change and studying the effects of regime authority.
#'
#' ### Structure
#'
#' The Polity5 dataset contains 17,574 country-year observations and 37
#' variables. For more information regarding variable descriptions and other
#' dataset documentation, please refer to the
#' [POLITY5: Political Regime Characteristics and Transitions, 1800-2018 Dataset Users’ Manual](https://www.systemicpeace.org/inscr/p5manualv2018.pdf).
#'
get_polity5<-function(load=TRUE, del_file=TRUE, excel=TRUE, write_out = FALSE){

  if(excel==TRUE){
  rlang::check_installed("readxl", reason = "readxl required for excel=TRUE")

  if (!file.exists(file.path(tempdir(), "p5v2018.xls"))) {
    url <- "http://www.systemicpeace.org/inscr/p5v2018.xls"

    polity_response <- httr::HEAD(url)
    if(polity_response$status_code!=200){stop("Polity5 data no longer available at given address.")}

    httr::GET(url = url, httr::write_disk(file.path(tempdir(), "p5v2018.xls"), overwrite = TRUE))
  }

  if(load==TRUE){polity <- readxl::read_excel(file.path(tempdir(), "p5v2018.xls"), col_types = 'text')}
  if(del_file==TRUE){unlink(c(file.path(tempdir(), "p5v2018.xls")), recursive = TRUE)}
  }

  if(excel==FALSE){
    rlang::check_installed("haven", reason = "haven required for excel=FALSE")

    if (!file.exists(file.path(tempdir(), "p5v2018.sav"))) {
      url <- "http://www.systemicpeace.org/inscr/p5v2018.sav"

      polity_response <- httr::HEAD(url)
      if(polity_response$status_code!=200){stop("Polity5 data no longer available at given address.")}

      httr::GET(url = url, httr::write_disk(file.path(tempdir(), "p5v2018.sav"), overwrite = TRUE))
    }

    if(load==TRUE){polity <- haven::read_sav(file.path(tempdir(), "p5v2018.sav"))}
    if(del_file==TRUE){unlink(c(file.path(tempdir(), "p5v2018.sav")), recursive = TRUE)}
  }

  if(write_out==TRUE){
    data.table::setDT(polity)
    data.table::fwrite(polity, "polity5.csv")
  }

  data.table::setDF(polity)
  polity

}
