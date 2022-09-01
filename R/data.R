#' Vertical and Horizontal Constraints Indices
#'
#' A dataset of country-year vertical and horizontal constraints as calculated
#' by Fjelde et al. 2021.
#'
#' @format A data frame with 15040 rows and 6 variables:
#' \describe{
#'   \item{country_name}{The common country name.}
#'   \item{gwno}{The Gleditsch and Ward numeric country code.}
#'   \item{cowcode}{The Correlates of War numeric country code.}
#'   \item{year}{The year of valid CoW observations.}
#'   \item{hci}{The horizontal constraint index.}
#'   \item{vci}{The vertical constrain index.}
#'   ...
#' }
#' @details
#' ## Data Source
#'
#' The horizontal and vertical constraints metrics  in this dataset were
#' developed by Fjelde et al. (2021) in:
#'
#' Fjelde, H., Knutsen, C. H. & Nygård, H. M. Which Institutions Matter?
#' Re-Considering the Democratic Civil Peace. *International Studies*
#' *Quarterly* 65, 223–237 (2021), \doi{10.1093/isq/sqaa076}.
#'
#' Dataset is available in the supplementary materials [Replication Package](https://academic.oup.com/isq/article/65/1/223/5990223)
#'
#' ## The Indices
#'
#' Horizontal constraints (HCI) represent checks and balances on centralized
#' executive power. These include constraints put in place by executive and
#' judicial branches of government. Horizontal constraints mainly serve the
#' interests of non-governmental elites by protecting their interests against an
#' uncontrolled executive.
#'
#' This is in contrast to vertical constraints (VCI), which represent civil
#' liberties attributed to the general populace that constrain executive
#' actions. These include suffrage, the presence of elections that appoint
#' executive officials, freedom of association, freedom of expression, and the
#' presence of clean and fair elections.
#'
#' ## Methods
#'
#' Both indices were developed from existing variables in the greater V-Dem
#' data. Although HCI represents a simple arithmetic mean (see
#' [demcon::hci()]) of V-Dem's legislative constraints (`v2xlg_legcon`) and
#' judicial constraints variables (`v2x_jucon`), the methods behind the VCI are
#' more complicated.
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
#'
#' @source \doi{10.1093/isq/sqaa076}
#' @seealso [demcon::hci()], [demcon::vci()]
"vdem_vci_hci"

#' Adjusted Institutions and Elections Project Data (V2.0)
#'
#' A pre-processed and amended subset of the Institutions and Elections Project
#' Data (V2.0) dataset.
#'
#' @format An 8 column, 10648 row, \code{data.table} where each row is a
#'  country-year:
#'  \describe{
#'  \item{cname}{Country name.}
#'  \item{cowcode}{The numeric Correlates of War country code.}
#'  \item{iso3}{The International Organization for Standardization (ISO) 3
#'  character country code.}
#'  \item{year}{Numeric year.}
#'  \item{formalconstit}{Binary indicator if constitution exists.}
#'  \item{ineffect}{Binary indicator if constitution was in effect on January 1
#'  of the specified year.}
#'  \item{timeineffect}{Numeric value specifying number of years the current
#'  constitution has been in effect as of January 1.}
#'  \item{timeineffect2}{Numeric value specifying number of consecutive years a
#'  constitution has been in effect without interruptions as of January 1.}
#'  }
#'
#' @details
#'
#'  ## About
#'
#'  This dataset was constructed after detecting numerous and egregious
#'  inconsistencies in the official dataset. We discovered several
#'  errors for the coding of constitutions and constitutional ages in the
#'  original dataset. This subset contains manual fixes using multiple sources
#'  for constitutional data.These corrections were carried out by Lisa Emmer
#'  under guidance from Joshua Brinks and Thomas Parris. For additional
#'  information regarding the official IAEP (V2) dataset refer to the
#'  \href{https://havardhegre.files.wordpress.com/2015/06/users_manual_iaep.pdf}{user
#'  manual.}
#'
#'  If you are hesitant to use our adjusted dataset, you might consider using
#'  Constitutes' Chronology of Constitutional Events (CCE). You could construct
#'  a constitutional stability counter with CCE data using counter functions
#'  like Base R's [rle()] or [data.table]'s [data.table::rleid()].
#'
#'  ## Amendment References
#'
#'   Edits to the original IAEP (V2.0) dataset were determined by reviewing
#'   several constitutional databases and news articles. Some are not listed
#'   below, because the websites are no longer available, but the currently
#'   available sources include:
#'
#'   \itemize{
#'   \item \href{https://constitutionnet.org/}{Constitution Net}
#'   \item \href{http://countrystudies.us/}{Country Studies}
#'   \item \href{https://law.stanford.edu/}{Stanford Law}
#'   \item \href{https://exit.al/}{Exit News}
#'   \item \href{https://en.wikipedia.org/wiki/Main_Page}{Wikipedia}
#'   \item \href{https://www.constituteproject.org}{Constitute}
#'   \item \href{https://www.cia.gov/the-world-factbook/}{CIA World Factbook}
#'   \item \href{https://gulfmigration.org/}{Gulf Labor Markets and Migration}
#'   \item \href{https://uca.edu/politicalscience/dadm-project/}{Dynamic Analysis of Dispute Management (DADM) Project}
#'   \item \href{https://home.heinonline.org/content/world-constitutions-illustrated/}{World Constitutions Illustrated}
#'   \item \href{https://www.kas.de/de/home}{Konrad Adenauer Stiftung}
#'   \item \href{https://www.nytimes.com}{The New York Times}
#'   \item \href{https://china.usc.edu/}{The USC USA-China Institute}
#'   \item \href{https://www.globalsecurity.org/}{Global Security}
#'   \item \href{https://www.egypttoday.com}{Egypt Today}
#'   \item \href{http://www.scielo.org.za}{SciElo South Africa}
#'   \item \href{https://www.gambia.dk/}{Nijii}
#'   \item \href{https://www.lawhubgambia.com/}{Law Hub Gambia}
#'   \item \href{https://www.artsrn.ualberta.ca/amcdouga/Hist247/winter_2017/resources/}{University of Alberta}
#'   \item \href{https://pdba.georgetown.edu}{Political Database of the Americas}
#'   \item \href{https://www.loc.gov}{Library of Congress}
#'   \item \href{https://www.servat.unibe.ch/icl/}{International Constitutional Law Countries}
#'   \item \href{https://e-history.kz/en/}{Kazakhstan History Portal}
#'   \item \href{https://www.cambridge.org}{Cambridge University Press}
#'   \item \href{https://malawilii.org/}{Malawi Legal Information Institute}
#'   \item \href{https://www.wipo.int/portal/en/index.html}{World Intellectual Property Organization}
#'   \item \href{https://digitalcommons.law.uw.edu/}{University of Washington Law: Digital Commons}
#'   \item \href{https://himalaya.socanth.cam.ac.uk}{Digital Himalaya}
#'   \item \href{https://www.hathitrust.org/}{Hathi Trust Digital Library}
#'   \item \href{https://www.ilo.org}{International Labour Organization}
#'   \item \href{https://www.ifes.org/}{International Foundation for Electoral Systems}
#'   \item \href{https://www.congreso.gob.pe/}{Congreso de la Republica}
#'   \item \href{https://www.officialgazette.gov.ph/}{Official Gazette of the Republic of the Philippines}
#'   \item \href{https://www.usaid.gov/}{U.S. Agency for International Aid}
#'   \item \href{http://vietnamproject.archives.msu.edu/}{Michigan State University Vietnam Group Archives}
#'   \item \href{https://www.marxists.org}{Marxist Internet Archive}
#'   \item \href{http://www.sierra-leone.org}{Sierra Leone Web}
#'   \item \href{https://www.gov.za/}{Government of South Africa}
#'   \item \href{https://pkp.sfu.ca/ojs/}{Open Journal Systems}
#'   \item \href{https://www.legislation.gov.uk}{UK Legislation}
#'   \item \href{https://www.mfa.gov.tm/en}{Ministry of Foreign Affairs of Turkmenistan}
#'   \item \href{https://www.statehouse.go.ug}{State House Uganda}
#'   \item \href{https://u.ae/en/}{The United Arab Emirates' Government Portal}
#'   \item \href{https://constitution.uz/en}{Constitution of the Republic of Uzbekistan}
#'   \item \href{https://vietnamlawmagazine.vn}{Vietnam Law and Legal Forum}
#'   \item \href{https://vietnamembassy-usa.org}{Embassy of the Socialist Republic of Vietnam}
#'   }
#'
#' @seealso The original dataset release was accompanied by a peer reviewed manuscript:
#'
#' Wig, T., Hegre, H., & Regan, P. M. (2015). Updated data on institutions and elections
#'      1960–2012: Presenting the IAEP dataset version 2.0. Research & Politics, 2(2).
#'      \doi{10.1177/2053168015579120}.
'iaepv2_adj'
