#' Horizontal Constraints Index (HCI)
#'
#' Calculate the horizontal constraints index defined by Fjelde et al. (2021).
#'
#' @param vdem A `data.frame` of V-Dem data containing the required variables.
#' @param append Logical indicating whether to return the original data.frame
#'   with `hci`. If set to FALSE, the function returns a numeric vector of hci
#'   scores.
#'
#' @return A numeric vector of the horizontal constraints index.
#' @export
#'
#' @seealso [demcon::vci()], [demcon::vdem_vci_hci]
#'
#' @details
#'
#' ## Source
#'
#' The horizontal constraints index specified in this function
#' were developed by Fjelde et al. (2021) in:
#'
#' Fjelde, H., Knutsen, C. H. & Nygård, H. M. 2021. Which Institutions Matter?
#' Re-Considering the Democratic Civil Peace. *International Studies*
#' *Quarterly* 65, 223–237, \doi{10.1093/isq/sqaa076}.
#'
#' ## The Index
#'
#' Horizontal constraints (HCI) represent checks and balances on centralized
#' executive power. These include constraints put in place by executive and
#' judicial branches of government. Horizontal constraints mainly serve the
#' interests of non-governmental elites by protecting their interests against an
#' uncontrolled executive.
#'
#' ## Methods
#'
#' The Horizontal Constraints Index represents a simple arithmetic mean (see of
#' V-Dem's legislative constraints (`v2xlg_legcon`) and judicial constraints
#' variables (`v2x_jucon`).
#'
#' @examples
#' \donttest{
#' vdem <- demcon::get_vdem()
#'
#' vdem$hci<-demcon::hci(vdem, append = FALSE)}
#'
hci<-function(vdem, append = FALSE){

  hci_components<-NULL

  # if it was already a data.table
  dat<-data.table::copy(vdem)
  # if it wasn't
  dat<-data.table::setDT(dat)

  hci_components <- c('v2xlg_legcon', 'v2x_jucon')

  if(any(!(hci_components %in% names(dat)))){
    missing<-!(hci_components %in% names(dat))
    missing<-hci_components[missing]

    stop(paste0("Supplied data frame does not contain the necessary indicators to calculate the HCI. Missing: ", paste(missing, collapse = ", "), "\n"), call. = FALSE)
  }

  if (any(is.na(dat[, .SD, .SDcols = hci_components]))) {
    warning("Any input observations that contain NA for \n either v2xlg_legcon or v2x_jucon will return an NA for the calculated HCI. \n")
  }

  hci<-dat[, .SD, .SDcols = hci_components]
  hci<-apply(hci, 1, mean)

  if(append==TRUE){
    dat[, hci := hci]

    data.table::setDF(dat)
    return(dat)
  }

  if(append==FALSE){
    return(hci)
  }

}
