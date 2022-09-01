#' Download V-Dem (Current Version)
#'
#' Download a copy of the most recent version of V-Dem that is housed
#' in the official vdemdata GitHub package.
#'
#' @param write_out Logical to write the V-Dem dataset to your local directory.
#'
#' @return A data.frame of V-Dem data.
#' @export
#'
#' @examples
#'
#'\donttest{
#' vdem <- demcon::get_vdem(write_out = FALSE)}
#'
#' @details This function is a simple download wrapper to directly acquire
#' V-Dem's current dataset from their GitHub repo. The vdemdata package is not
#' available on CRAN or Bioconductor so it can disrupt workflows that do not
#' permit non-standard package installations. Additionally, this function
#' contains test scripts that will notify the package manager if the remote
#' dataset undergoes significant structural changes (dimensions, location, etc.)
get_vdem <- function(write_out = FALSE) {
  vdem_url <-
    "https://github.com/vdeminstitute/vdemdata/raw/master/data/vdem.RData"
  vdem <- get(load(url(vdem_url)))
  data.table::setDT(vdem)

  if (write_out == TRUE) {
    data.table::fwrite(vdem, "vdem.csv")
  }

  data.table::setDF(vdem)

  vdem
}
