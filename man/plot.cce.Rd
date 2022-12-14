% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.cce.R
\name{plot.cce}
\alias{plot.cce}
\title{Plotting Method for CCE Object}
\usage{
\method{plot}{cce}(
  x,
  y,
  ...,
  cntry,
  lab_adj = 0.25,
  detailed_lab = TRUE,
  no_lab = FALSE,
  years = c(min(x$year), max(x$year)),
  plot_pal = c("#003f5c", "#ff6361", "#20639b", "#ffa600", "#58508d", "#bc5090"),
  text_col = "#3d3d3d"
)
}
\arguments{
\item{x}{A dataset of class \code{cce} prepared by \code{\link[=prep_cce]{prep_cce()}}.}

\item{y}{ignored}

\item{...}{Additional arguments to pass to the ggplot device.}

\item{cntry}{The country to plot. This may be a character string with the
country name or the numeric Correlates of War code. For a list of possible
values use the command \code{unique(x[, c("country", "cowcode")])}.}

\item{lab_adj}{Numeric value to buffer label positions near terminal point.}

\item{detailed_lab}{Logical to print detailed or simple labels. Detailed
labels contain event type and year, simple labs contain just the year.}

\item{no_lab}{Logical to suppress event labels. Will make plots easier to
read for countries with either long or active histories.}

\item{years}{Numeric vector of length representing the starting and ending
years to plot.}

\item{plot_pal}{Character vector of length 6 containing color hex codes for
plotting. The first element controls the line segments color, elements 2:6
control the \code{evnttype} colors.}

\item{text_col}{Character string with hex code for text labeling.}
}
\value{
A \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}} device.
}
\description{
Create timeline plots for Chronology of Constitutional Event datasets.
}
\examples{
cce<-demcon::get_cce(del_file=TRUE, write_out = FALSE)

cce<-demcon::prep_cce(cce, evnttype_fix = TRUE)

plot(cce, cntry = "France", years = c(1850, 2010))

}
\seealso{
\href{https://comparativeconstitutionsproject.org/download-data/}{The Comparative Constitutions Project}
}
