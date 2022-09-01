## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE--------------------------------------------------------
library(demcon)

col1<-"#11d5ff"
col2<-"#0b3d91"
col3<-"#f1bd57"
col4<-"#fc7f20"
grey<-"#666666"

## -----------------------------------------------------------------------------
hci.vci<-demcon::vdem_vci_hci

head(hci.vci)

## ----message=FALSE, warning=FALSE, eval=FALSE---------------------------------
#  
#  rep_url<-"https://oup.silverchair-cdn.com/oup/backfile/Content_public/Journal/isq/65/1/10.1093_isq_sqaa076/1/sqaa076_replication.zip?Expires=1654268815&Signature=4ZvswA2nYP2nPWE-wx0T~oFTqwMB2O6n~1Z2qgdhrpz7fE4OFpkdbwVhk5bMQMx9dM12TX0U3N663k2DC1NnkTyrsdDJV9P8jR1fo8xTgGvXNsico2EXgRTNJ034y-oFqAY2PmGzpe4B1ZrQpPKgAqWjlxoBTjb3RbSuKu4dJxQjiRKF4~2BzSbIkTm25DBk9TVsmVcMHnAs6nzklMx2L7Mfq4k17OKEAapwXAZz6tyTgzhVoLdNDjY1sPYCnTHWsyMBwt4MqntiAP~uFVvYs0r6weGocpMZBJ1PFK35XinYaRw~hiwnWa7sl7HxqLQUvBa1Q8wMFVq02zWSUvZCsA__&Key-Pair-Id=APKAIE5G5CRDK6RD3PGA"
#  
#  if(!file.exists("institutions.csv")) {
#    httr::GET(url = rep_url,
#              httr::write_disk("sqaa076_replication.zip", overwrite = TRUE))
#  
#    utils::unzip(zipfile = "sqaa076_replication.zip",
#                 files = "ReplicationPackage/Data/institutions.csv")
#  }

## -----------------------------------------------------------------------------

full_rep_data<-data.table::fread("institutions.csv")


## ----echo=FALSE, fig.width=7.5, fig.height=5, fig.cap="Horizontal and Vertical Constraint indices for the year 2015. Numeric codes represent Gledistch and Ward numeric codes. Adapted from figure A-1 of the supplementary materials."----
knitr::include_graphics("figure-a-1.png")

## ----echo=FALSE, fig.width=7.5, fig.height=5, fig.cap="Horizontal and Vertical Constraint indices for the year 2015 created from the replication package data."----
 ggplot2::ggplot(full_rep_data[year==2015],
                 ggplot2::aes(x = horizontal_constraint, 
                              y = free_fair_elections))+
   ggplot2::geom_point(size = 2, color = col2)+
   ggplot2::geom_text(label=full_rep_data[year==2015,gwno],
                      nudge_x = 0.02, nudge_y = 0.01)+
   ggplot2::labs(x = "HCI", y ="VCI")+
   ggplot2::theme_minimal()


## ----echo = FALSE, fig.width=7.5, fig.height=5, fig.cap = "Horizontal and Vertical Constraint indices over time for select countries created using the replication data."----
data.table::setDT(hci.vci)
plot_hci_vci<-data.table::melt(hci.vci, id.vars = c("cowcode", "country_name","year"), measure.vars = c("vci", "hci"), value = "value", variable = "constraint")
countries<-c("France", "Chad", "Nigeria", "Argentina", "Mexico", "China")

plot_hci_vci<-plot_hci_vci[country_name %in% countries][constraint=="vci", constraint:="VCI"][constraint=="hci", constraint:="HCI"]

 ggplot2::ggplot(plot_hci_vci,
                 ggplot2::aes(x = year, 
                              y = value,
                              color = constraint))+
   ggplot2::geom_line(size = 1.5)+
   ggplot2::labs(x = "", y ="", color = "Constraint")+
   ggplot2::facet_wrap(~country_name)+
   ggplot2::scale_color_manual(values = c(col2,col1))+
   ggplot2::theme_minimal()+
   ggplot2::theme(legend.position = "bottom")

## ----eval=FALSE---------------------------------------------------------------
#  devtools::install_github("vdeminstitute/vdemdata")

## -----------------------------------------------------------------------------
# vdem_raw<-vdemdata::vdem

vdem_raw<-demcon::get_vdem(write_out = FALSE)
data.table::setDT(vdem_raw)

  id_vars <- c("country_text_id", "COWcode", "year")

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
  
  hci_components <- c('v2xlg_legcon', 'v2x_jucon')

keeps<-c(id_vars, frefair_components, vci_components, hci_components)
  
vdem_sub<-vdem_raw[year>=1970, ..keeps]

## ----include=FALSE------------------------------------------------------------
rm(vdem_raw)
gc()

## -----------------------------------------------------------------------------
hci<-demcon::hci(vdem_sub, append = FALSE)

## ----echo=FALSE, fig.height=5, fig.width=7.5, message=FALSE, warning=FALSE----
ggplot2::ggplot()+
  ggplot2::geom_histogram(ggplot2::aes(hci), fill = col1, color = col2, binwidth = 0.05)+
  ggplot2::labs(y = "Count", x = "HCI")+
  ggplot2::theme_minimal()

## -----------------------------------------------------------------------------
hci<-demcon::hci(vdem_sub, append = TRUE)
names(hci)

## ----error = TRUE-------------------------------------------------------------
id_vars <- c("country_text_id", "COWcode", "year")

  frefair_components_missing <-
    c('v2elembaut',
      'v2elembcap',
      'v2elrgstry',
      'v2elvotbuy')

  vci_components_missing <-
    c('v2x_suffr',
      'v2x_elecoff',
      'v2x_frassoc_thick')
  
keeps<-c(id_vars, frefair_components_missing, vci_components_missing)
  
vdem_sub_missing<-data.table::copy(vdem_sub[, ..keeps])

vdem_sub_missing<-demcon::vci(vdem_sub_missing)

## ----include=FALSE------------------------------------------------------------
rm(vdem_sub_missing)
gc()

## -----------------------------------------------------------------------------
hci<-demcon::vci(hci, append = TRUE)
data.table::setDT(hci)
names(hci)

## ----echo=FALSE, fig.width=7.5, fig.height=5, message=FALSE, warning=FALSE----
ggplot2::ggplot()+
  ggplot2::geom_histogram(ggplot2::aes(hci$vci), fill = col2, color = col1, binwidth = 0.05)+
  ggplot2::labs(y = "Count", x = "VCI")+
  ggplot2::theme_minimal()

## ----fig.width=7.5, fig.height=5, echo = FALSE--------------------------------
global<-rnaturalearth::ne_countries(returnclass = 'sf', scale = 'medium')
global$cow<-countrycode::countrycode(global$iso_a3, origin = "iso3c", destination = "cown")
global<-merge(
  global, hci[year==2020],
  by.x = "cow", by="COWcode", all.x = TRUE
)

# plot(global[, "vci"], graticule = TRUE, key.pos = 1, axes = TRUE, key.width = lcm(1.3), key.length = 1.0)


## ----fig.height=5, fig.width=7.5, echo = FALSE--------------------------------
ggplot2::ggplot(global)+
  ggplot2::geom_sf(ggplot2::aes(fill = vci), size = 0.0000001)+
  ggplot2::labs(title = "Global VCI Estimates for 2020",
                subtitle = "Using V-Dem V11.1 and the demcon Package",
                fill = "VCI")+
  ggplot2::scale_fill_gradient(low = col2, high = col1)+
  ggplot2::theme_minimal()

## ----fig.height=5, fig.width=7.5, echo=FALSE----------------------------------
ggplot2::ggplot(global)+
  ggplot2::geom_sf(ggplot2::aes(fill = hci), size = 0.0000001)+
  ggplot2::labs(title = "Global HCI Estimates for 2020",
                subtitle = "Using V-Dem V11.1 and the demcon Package",
                fill = "HCI")+
  ggplot2::scale_fill_gradient(low = col2, high = col1)+
  ggplot2::theme_minimal()

