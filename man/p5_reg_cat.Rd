% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/p5_reg_cat.R
\name{p5_reg_cat}
\alias{p5_reg_cat}
\title{Code Polity Regime Classification}
\source{
Methods for this function are adapted from:

Goldstone, J. A. et al. A Global Model for Forecasting Political
Instability. American Journal of Political Science 54, 190–
208 (2010).

\href{https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1531942}{Website}
}
\usage{
p5_reg_cat(exrec, parcomp, pretty = FALSE)
}
\arguments{
\item{exrec}{Executive Recruitment Concept (\code{exrec}) variable from raw
Polity5 data.}

\item{parcomp}{Competitive of Participation (\code{parcomp}) variable from raw
Polity5 data.}

\item{pretty}{Logical to format categories with no spaces and first letter
capitalized.}
}
\value{
A character vector of ordinal categorical regime classifications
based on \href{https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1531942}{Goldstone et al. (2010)}.
}
\description{
Determine qualitative regime classifications based on Goldstone et al. (2010)
Figure 1.
}
\examples{
\donttest{
polity<-demcon::get_polity5(write_out = FALSE)

polity$reg_cat<-demcon::p5_reg_cat(polity$exrec, polity$parcomp, pretty = TRUE)}

}
