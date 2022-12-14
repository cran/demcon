% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hci.R
\name{hci}
\alias{hci}
\title{Horizontal Constraints Index (HCI)}
\usage{
hci(vdem, append = FALSE)
}
\arguments{
\item{vdem}{A \code{data.frame} of V-Dem data containing the required variables.}

\item{append}{Logical indicating whether to return the original data.frame
with \code{hci}. If set to FALSE, the function returns a numeric vector of hci
scores.}
}
\value{
A numeric vector of the horizontal constraints index.
}
\description{
Calculate the horizontal constraints index defined by Fjelde et al. (2021).
}
\details{
\subsection{Source}{

The horizontal constraints index specified in this function
were developed by Fjelde et al. (2021) in:

Fjelde, H., Knutsen, C. H. & Nygård, H. M. 2021. Which Institutions Matter?
Re-Considering the Democratic Civil Peace. \emph{International Studies}
\emph{Quarterly} 65, 223–237, \doi{10.1093/isq/sqaa076}.
}

\subsection{The Index}{

Horizontal constraints (HCI) represent checks and balances on centralized
executive power. These include constraints put in place by executive and
judicial branches of government. Horizontal constraints mainly serve the
interests of non-governmental elites by protecting their interests against an
uncontrolled executive.
}

\subsection{Methods}{

The Horizontal Constraints Index represents a simple arithmetic mean (see of
V-Dem's legislative constraints (\code{v2xlg_legcon}) and judicial constraints
variables (\code{v2x_jucon}).
}
}
\examples{
\donttest{
vdem <- demcon::get_vdem()

vdem$hci<-demcon::hci(vdem, append = FALSE)}

}
\seealso{
\code{\link[=vci]{vci()}}, \link{vdem_vci_hci}
}
