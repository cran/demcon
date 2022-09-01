#' Vertical Constraints Index (VCI)
#'
#' Calculate an the vertical constraints index defined by Fjelde et al. (2021).
#'
#' @param vdem A `data.frame` of V-Dem data containing the required variables.
#' @param append Logical indicating whether to return the original data.frame
#' with `vci` and modified modified `v2xel_frefair` index (`v2xel_frefair_adj`).
#' If set to FALSE, the function returns a numeric vector of VCI scores.
#'
#' @return A data.frame with a modified `v2xel_frefair` index
#'   (`v2xel_frefair_adj`) and the calculated VCI (`vci`).
#'
#' @seealso [demcon::hci()], [demcon::vdem_vci_hci]
#' @export
#' @details
#'
#' ## Source
#'
#' The vertical constraints metrics specified in this function were developed by
#' Fjelde et al. (2021) in:
#'
#' Fjelde, H., Knutsen, C. H. & Nygård, H. M. 2021. Which Institutions Matter?
#' Re-Considering the Democratic Civil Peace. *International Studies*
#' *Quarterly* 65, 223–237, \doi{10.1093/isq/sqaa076}.
#'
#' ## The Index
#'
#' The Vertical constraints index (VCI) represent civil liberties
#' attributed to the general populace the constrain executive actions. These
#' include suffrage, the presence of elections that appoint executive officials,
#' freedom of association, freedom of expression, and the presence of clean and
#' fair elections.
#'
#' ## Methods
#'
#' At it's core, VCI is a multiplicative aggregation of 5 V-Dem variables
#' designed to measure suffrage, elected officials, freedom of association,
#' freedom of expression and clean elections, (`v2x_suffr`, `v2x_accex`,
#' `v2x_frassoc_thick`, `v2x_freexp_thick`, `v2xel_frefair`). However, the final
#' component (`v2xel_frefair`) is a composite index developed with a Bayesian
#' factor analysis of 8 other V-Dem indicators (`v2elembaut`, `v2elembcap`,
#' `v2elrgstry`, `v2elvotbuy`, `v2elirreg`, `v2elintim`, `v2elpeace`,
#' `v2elfrfair`), of which, the authors adapted by purging 2 of the components
#' representing government intimidation or violent actions (`v2elintim`,
#' `v2elpeace`) to prevent potential endogeneity in their regressions for the
#' onset of conflict; i.e. you don't want to predict the onset of conflict with
#' and independent variable that is, in-part, composed of measures of conflict.
#'
#' Although the original `v2xel_frefair` composite index was developed using
#' V-Dem's [Bayesian Factor Measurement Model](https://v-dem.net/static/website/files/wp/wp_21_5th.pdf),
#' the VCI adapted for this study took a simpler approach. In footnote 12,
#' the authors state that the modified composite index was created by averaging
#' the 6 non-violent indicators of `v2xel_frefair` (`v2elembaut`, `v2elembcap`,
#' `v2elrgstry`, `v2elvotbuy`, `v2elirreg`, `v2elfrfair`). Although not
#' explicitly stated, it's presumed that the average for these 6 indicators was
#' converted to a 0-1 scale using "...the cumulative distribution function
#' of the normal distribution". This is the standard V-Dem procedure for their 0-1
#' interval indices as stated on page 7 of the [V-Dem V11.1 Methodology](https://www.v-dem.net/static/website/img/refs/methodologyv111.pdf)
#' handbook.
#'
#' Lastly, the VCI constructed for this manuscript was carried out using the
#' V-Dem 7.1 dataset. Since that time (current version is V11.1), 2 of the
#' indicators used in the VCI calculation have been renamed and slightly
#' altered:
#'
#' 1. `v2x_freexp_thick` was converted to `v2x_freexp_altinf` starting with
#' version 11. The sub-components of this composite index were altered slightly,
#' but they still encompass the same concepts of censorship in media.
#'
#' 2. `v2x_accex` was renamed `v2x_elecoff` starting with version 8. This was
#' due to changes in the aggregation method for calculating the composite index.
#' Although the conceptual design for the composite indicator has not changed,
#' the aggregation formula is more complex and consists of 20 indicators
#' (opposed to 10 for the original `v2x_accex`).
#'
#' @examples
#' \donttest{
#' vdem <- demcon::get_vdem()
#'
#' # Appended to the input dataset
#'
#' vdem.dat<-demcon::vci(vdem, append = TRUE)
#'
#' # Just return the numeric vector
#'
#' vci<-demcon::vci(vdem = vdem, append = FALSE)}
#'
vci<-function(vdem, append = TRUE){

  var_check<-frefair_components<-vci_components<-NULL

  class_dt<-FALSE
  if("data.table" %in% class(vdem)){class_dt<-TRUE}
  dat<-data.table::copy(data.table::setDT(vdem))

  frefair_components <-
    c('v2elembaut',
      'v2elembcap',
      'v2elrgstry',
      'v2elvotbuy',
      'v2elirreg',
      'v2elfrfair')

  vci_components <-
    c('v2x_suffr',
      'v2x_elecoff',
      'v2x_frassoc_thick',
      'v2x_freexp_altinf')

  var_check<-c(frefair_components,vci_components)

  if (any(!(var_check %in% names(dat)))) {
    missing <- !(var_check %in% names(dat))
    missing <- var_check[missing]
    stop(
      paste0(
        "Supplied data frame does not contain the necessary indicators to calculate the VCI. Missing: ",
        paste(missing, collapse = ", "),
        "\n"
      ),
      call. = FALSE
    )
  }

  if (nrow(stats::na.omit(dat[, .SD, .SDcols = var_check])) < nrow(dat[, .SD, .SDcols = var_check])) {
    warning("The input dataframe contains NAs for some of the 10 required inputs; these observations will return NA for the calculated VCI. \n")
  }

  frefair <- dat[, .SD, .SDcols = frefair_components]
  v2xel_frefair_adj<-apply(frefair, 1, mean)
  v2xel_frefair_adj<-demcon::range01(v2xel_frefair_adj)

  vci <- cbind(dat[, .SD, .SDcols = vci_components], v2xel_frefair_adj)
  vci<-apply(vci, 1, prod)

  if (append == TRUE) {
    dat[, v2xel_frefair_adj := v2xel_frefair_adj]
    dat[, vci := vci]
    if(class_dt==TRUE){data.table::setDT(dat)} else {data.table::setDF(dat)}
    return(dat)

    } else{return(vci)}

}
