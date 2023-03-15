#' Mapping cshapes Multiples
#'
#' Create a sequence of cshapes maps highlighting changes in nation-state
#' independence.
#'
#' @param dates A vector of dates indicating time-steps of interest. Each
#'   element must be formatted with `as.Date(YYYY-M-D)`.
#' @param cowcodes A vector, or list, of Correlates of War numeric country codes
#'   to highlight at each corresponding timestep specified in `date`. The length
#'   of `dates` and `cowcodes` must be equal. Multiple countries can be
#'   highlighted at a given timestep by using a list.
#' @param bb A bounding box to crop the the global cshapes map. Must be a named
#'   vector of the form `c(xmin=long, ymin=lat, xmax=long, ymax=lat)`.
#' @param jitter_labs Logical to toggle country label jittering with
#'   `ggrepel::geom_text_repel()`.
#' @param highlight Hex color value for country highlighting.
#' @param lat_grat Numeric value for latitudinal graticule spacing.
#' @param long_grat Numeric value for longitudinal graticule spacing.
#' @param lab_size Numeric value for country label text size.
#'
#' @return A list of `ggplot2` plotting devices. Each element corresponds to an
#'   element of `dates`.
#' @details The `chsp_mult` and `plot.chsp_mult` functions are currently
#'   experimental functions that are slated for future improvements to the
#'   interface, automated ease of use, and stability. Despite the testing
#'   procedures in place, they may produce odd results with certain combinations
#'   of `dates`, countries (`cow_codes`), and bounding boxes (`bb`).
#' @export
#'
#' @examples
#' \donttest{
#' if(requireNamespace("cshapes")){
#' dates = c(
#' as.Date("1989-1-1"),
#' as.Date("1992-5-1"),
#' as.Date("1993-5-1"),
#' as.Date("2006-7-1"),
#' as.Date("2008-3-1")
#' )
#' cow_codes = list(345,
#'                  c(344, 346, 349),
#'                  343,
#'                  341,
#'                  347)
#'
#' bb<-c(xmin=13,ymin=40,xmax=24,ymax=47)
#'
#' balkans<-cshp_mult(dates = dates, cowcodes = cow_codes, bb = bb,jitter_labs = FALSE)}}
cshp_mult <-
  function(dates,
           cowcodes,
           bb,
           jitter_labs = TRUE,
           highlight = "#00dada",
           lat_grat = round(as.numeric(abs(bb[2]-bb[4])/4)),
           long_grat = round(as.numeric(abs(bb[1]-bb[3])/4)),
           lab_size = 3) {

  rlang::check_installed(c("ggplot2", "sf", "ggrepel"), "required for plotting function")

  country_name <- X <- Y <- NULL

  if(length(dates)!=length(cowcodes)){stop("The dates and cowcodes arguments must be of equal length.")}

  cshp_list<-list()

  for(i in 1:length(dates)){

    cshp <- suppressWarnings(cshapes::cshp(date = dates[i], useGW = FALSE))
    cshp <- suppressWarnings(sf::st_make_valid(cshp))

  cshp<-suppressWarnings(sf::st_crop(cshp, bb))
  labels <-
    suppressWarnings(data.table::data.table(country_name = as.character(cshp$country_name),
                             sf::st_coordinates(sf::st_point_on_surface(cshp))))

  new_shps<-cshp[cshp$cowcode %in% cowcodes[[i]],]
  cshp<-cshp[!(cshp$cowcode %in% cowcodes[[i]]),]
  bbox<-sf::st_bbox(cshp)

  cshp_list[[as.character(dates[[i]])]] <-

    ggplot2::ggplot() +
    ggplot2::geom_sf(data = cshp, fill = "#F5F5F5") +
    ggplot2::geom_sf(data = new_shps, fill = highlight)+
    ggplot2::coord_sf(xlim = c(bb[1], bb[3]),
                      ylim = c(bb[2], bb[4]),
                      expand = FALSE)+
    ggplot2::scale_x_continuous(breaks = seq(bb[1], bb[3], by = long_grat)) +
    ggplot2::scale_y_continuous(breaks = seq(bb[2], bb[4], by = lat_grat)) +
    ggplot2::labs(x = "",
                  y = "",
                  title = as.character(lubridate::year(dates[i])))+
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5),
      panel.grid.major = ggplot2::element_line(
        color = "#808080",
        linetype = "dashed",
        linewidth = 0.5),
      panel.background = ggplot2::element_rect(fill = "aliceblue"))

  if(jitter_labs==TRUE){

    cshp_list[[as.character(dates[[i]])]] <-
      cshp_list[[as.character(dates[[i]])]]+
      suppressWarnings(ggrepel::geom_text_repel(
      data = labels,
      ggplot2::aes(X, Y, label = country_name),
      min.segment.length = 5,
      force = 1,
      force_pull = 3,
      size = lab_size,
      xlim = c(NA, Inf),
      ylim = c(-Inf, Inf)))}

  if(jitter_labs==FALSE){

    cshp_list[[as.character(dates[[i]])]] <-
      cshp_list[[as.character(dates[[i]])]]+
    ggplot2::geom_text(
    data = labels,
    size = lab_size,
    ggplot2::aes(X, Y, label = country_name))}

  }

  class(cshp_list) <- c("cshp_mult", class(cshp_list))
  cshp_list

}
