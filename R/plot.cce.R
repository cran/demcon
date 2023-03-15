#' Plotting Method for CCE Object
#'
#' Create timeline plots for Chronology of Constitutional Event datasets.
#'
#' @param x A dataset of class `cce` prepared by [demcon::prep_cce()].
#' @param y ignored
#' @param ... Additional arguments to pass to the ggplot device.
#' @param cntry The country to plot. This may be a character string with the
#'   country name or the numeric Correlates of War code. For a list of possible
#'   values use the command `unique(x[, c("country", "cowcode")])`.
#' @param detailed_lab Logical to print detailed or simple labels. Detailed
#' labels contain event type and year, simple labs contain just the year.
#' @param no_lab Logical to suppress event labels. Will make plots easier to
#' read for countries with either long or active histories.
#' @param lab_adj Numeric value to buffer label positions near terminal point.
#' @param years Numeric vector of length representing the starting and ending
#'   years to plot.
#' @param plot_pal Character vector of length 6 containing color hex codes for
#'   plotting. The first element controls the line segments color, elements 2:6
#'   control the `evnttype` colors.
#' @param text_col Character string with hex code for text labeling.
#' @method plot cce
#' @seealso [The Comparative Constitutions Project](https://comparativeconstitutionsproject.org/download-data/)
#'
#' @return A [ggplot2::ggplot()] device.
#' @export
#'
#' @examples
#' cce<-demcon::get_cce(del_file=TRUE, write_out = FALSE)
#'
#' cce<-demcon::prep_cce(cce, evnttype_fix = TRUE)
#'
#' plot(cce, cntry = "France", years = c(1850, 2010))
#'
plot.cce<-function(x, y, ..., cntry,
                   lab_adj = 0.25, detailed_lab = TRUE, no_lab = FALSE,
                   years = c(min(x$year), max(x$year)),
                   plot_pal = c("#003f5c","#ff6361","#20639b","#ffa600", "#58508d","#bc5090"),
                   text_col = "#3d3d3d"){

  rlang::check_installed(c("ggplot2"), "ggplot2 required for plotting function")
  country<-cowcode<-evnttype<-position<-direction<-lab_position<-event_lab<-year<-NULL

  stopifnot(
    length(plot_pal)==6,
    length(years)==2,
    length(text_col)==1)

  if((cntry %in% x$cowcode || cntry %in% x$country)==FALSE){
    stop("Specified country name or country code not found. Please check \
       unique(cce_out[, c(\"country\", \"cowcode\")]) for available codes.")
  }

dat = data.table::as.data.table(x)

if(inherits(cntry, "character")){dat<-dat[country==cntry]} else
{dat<-dat[cowcode==cntry]}

country_lab <- dat$country[1]

dat<-dat[year >= years[1] & year <= years[2]]

if(rlang::is_installed("stringr")) {
  dat[, evnttype := stringr::str_to_title(evnttype)]
  dat[evnttype == "Non-Event", evnttype := NA]
} else {
  message("For pretty event labels, please install the stringr package.")
  dat[evnttype=="non-event", evnttype:=NA]
}

events<-dat[!is.na(evnttype), .N]
positions <- rep_len(c(0.5, -0.5, 1.5, -1.5, 1.0, -1.0, 2, -2),
                     length.out = events)
directions <- rep_len(c(1.0,-1.0),
                      length.out = events)
year_buffer<-1
year_range<-seq(min(dat$year)-year_buffer, max(dat$year)+year_buffer)

dat<-dat[!is.na(evnttype)]
dat[, position:=positions][, direction:=directions]
dat[position<0, lab_position:=position-lab_adj][position>0, lab_position:=position+lab_adj]

if(detailed_lab==TRUE){
dat[, event_lab:=paste0(evnttype, "\n (", year, ")")]}

else {dat[, event_lab:=paste0(year)]}

data.table::setDF(dat)
class(dat)<-c("cce", class(dat))

cce_plot<-
  ggplot2::ggplot(dat, ggplot2::aes(x = year, y = position, col = evnttype, label = event_lab))+
  ggplot2::labs(col="Constitutional Event: ",
                x = "",
                y = "",
                title = paste0("Timeline of ", country_lab, " Constitutional Events"),
                subtitle = "Data Generated from CCP's Chronology of Constitutional Events")+
  ggplot2::scale_color_manual(values=plot_pal[2:6])+
  ggplot2::geom_hline(yintercept=0, color = plot_pal[1], linewidth = 2)+
  ggplot2::geom_segment(data=dat,
                        ggplot2::aes(y=position,yend=0,xend=year),
                        color=plot_pal[1], linewidth = 1, alpha = 0.5)+
  ggplot2::geom_point(ggplot2::aes(y=position, col=evnttype),
                      size=3)+
  ggplot2::theme_classic()+
  ggplot2::theme(axis.line.y = ggplot2::element_blank(),
                 axis.text.y = ggplot2::element_blank(),
                 axis.title.x = ggplot2::element_blank(),
                 axis.title.y = ggplot2::element_blank(),
                 axis.ticks.y = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_blank(),
                 axis.ticks.x = ggplot2::element_blank(),
                 axis.line.x = ggplot2::element_blank(),
                 legend.position = "bottom")

if(no_lab==FALSE) {
  cce_plot <- cce_plot +
    ggplot2::geom_text(
      ggplot2::aes(y = lab_position, label = event_lab),
      size = 3,
      show.legend = FALSE,
      color = text_col
    )
}

suppressWarnings(cce_plot)
}
