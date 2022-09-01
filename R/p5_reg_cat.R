#' Code Polity Regime Classification
#'
#' Determine qualitative regime classifications based on Goldstone et al. (2010)
#' Figure 1.
#'
#' @param exrec Executive Recruitment Concept (`exrec`) variable from raw
#'   Polity5 data.
#' @param parcomp Competitive of Participation (`parcomp`) variable from raw
#'   Polity5 data.
#' @param pretty Logical to format categories with no spaces and first letter
#' capitalized.
#' @return A character vector of ordinal categorical regime classifications
#' based on [Goldstone et al. (2010)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1531942).
#' @export
#'
#' @source
#' Methods for this function are adapted from:
#'
#' Goldstone, J. A. et al. A Global Model for Forecasting Political
#'      Instability. American Journal of Political Science 54, 190–
#'      208 (2010).
#'
#' [Website](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1531942)
#'
#' @examples
#'\donttest{
#' polity<-demcon::get_polity5(write_out = FALSE)
#'
#' polity$reg_cat<-demcon::p5_reg_cat(polity$exrec, polity$parcomp, pretty = TRUE)}
#'
p5_reg_cat <- function(exrec, parcomp, pretty = FALSE) {
  stopifnot(length(exrec) == length(parcomp),
            "are exrec and parcomp switched?" = max(parcomp) <= 5)
  regime_cat <- character(length(exrec))
  # use %in% for comparison in case there are NA's in parcomp or exrec
  regime_cat[parcomp %in% -88] <- "regime_transition"
  regime_cat[parcomp %in% -77] <- "anarchy"
  regime_cat[parcomp %in% -66] <- "foreign_occupation"
  regime_cat[parcomp %in% c(0, 1) & exrec %in% c(1:5)] <- "full_autocracy"
  regime_cat[parcomp %in% c(0, 1) & exrec %in% c(6:8)] <- "partial_autocracy"
  regime_cat[parcomp %in% c(2:5) & exrec %in% c(1:5)]   <- "partial_autocracy"
  regime_cat[parcomp %in% 2 & exrec %in% c(6:8)] <- "partial_democracy"
  regime_cat[parcomp %in% 4 & exrec %in% c(6:8)] <- "partial_democracy"
  regime_cat[parcomp %in% 5 & exrec %in% c(6, 7)] <- "partial_democracy"
  regime_cat[parcomp %in% 3 & exrec %in% c(6:8)] <- "partial_democracy_with_factionalism"
  regime_cat[parcomp %in% 5 & exrec %in% 8] <- "full_democracy"

  if(pretty==TRUE){
    rlang::check_installed("stringr", "required for pretty labels")
    regime_cat<-gsub("_", " ", regime_cat)
    regime_cat<-stringr::str_to_title(regime_cat)
  }

  regime_cat
}
