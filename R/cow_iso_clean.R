#' Clean Up [countrycode::countrycode()] CoW > ISO3 conversion.
#'
#' Given a `data.frame` with ISO3 country codes that were derived from a
#' [countrycode::countrycode()] `cown > iso3c` formula, clean up the common
#' errors in coding respective to an additional designation for the year of the
#' observation.
#'
#' @param x A `data.frame` with CoW, ISO3, and year designations.
#' @param cow.col A character string of the column name with **numeric** CoW
#'   codes.
#' @param iso3.col A character string of the column name with ISO3 **character**
#'   codes.
#' @param year.col A character string of the column name for country-**year**
#'   observation.
#'
#' @return A `data.frame`.
#' @details [countrycode::countrycode()] can result in messy ISO3 conversions;
#'   especially when historic data is included. This cleans up some common
#'   post-WWII historical (and other current bugs present at the time of
#'   publishing) ISO3C codes that are useful but no longer part of the current
#'   slate of ISO3C. The
#'   [ISO_3166-1_alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)
#'   Wikipedia page was used as reference for this function.
#' @export
#' @examples
#' \donttest{
#' vdem<-demcon::get_vdem()
#'
#' vdem$iso3<-countrycode::countrycode(vdem$COWcode, origin = "cown", destination = "iso3c")
#'
#' vdem<-demcon::cow_iso_clean(x = vdem, cow.col = "COWcode", iso3.col = "iso3", year.col = "year")}
cow_iso_clean <- function(x, cow.col, iso3.col, year.col) {

  dat <- data.table::copy(data.table::setDT(x))

  dat[get(cow.col) == 260, eval(iso3.col) := "DEU"]
  dat[get(cow.col) == 265, eval(iso3.col) := "GDR"]
  dat[get(cow.col) == 315, eval(iso3.col) := "CSK"]
  dat[get(cow.col) == 345 & get(year.col) < 2003, eval(iso3.col) := "YUG"]
  dat[get(cow.col) == 345 & get(year.col) > 2002 & get(year.col) < 2007, eval(iso3.col) := "SCG"]
  dat[get(cow.col) == 345 & get(year.col) > 2006, eval(iso3.col) := "SRB"]
  dat[get(cow.col) == 347, eval(iso3.col) := "XKX"]
  dat[get(cow.col) == 511, eval(iso3.col) := "EAZ"]
  dat[get(cow.col) == 678, eval(iso3.col) := "YEM"]
  dat[get(cow.col) == 680, eval(iso3.col) := "YMD"]
  dat[get(cow.col) == 816 & get(year.col) < 1976, eval(iso3.col) := "VDR"]
  dat[get(cow.col) == 817, eval(iso3.col) := "VNM"]

  data.table::setDF(dat)

  dat
}
