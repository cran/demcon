## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(knitr)
library(kableExtra)

## ----install packages, eval=FALSE---------------------------------------------
#  # If you would like to install the package over GitHub.
#    devtools::install_github("vdeminstitute/vdemdata")}
#  

## -----------------------------------------------------------------------------
# library(vdemdata)
library(data.table)
library(states)

## -----------------------------------------------------------------------------
vdem <- demcon::get_vdem(write_out = FALSE)
data.table::setDT(vdem)

## -----------------------------------------------------------------------------
metrics<-c('v2x_libdem','v2x_polyarchy')

## -----------------------------------------------------------------------------
id.vars<-c('country_name', 'COWcode','histname' ,'codingstart_contemp', 'codingend_contemp','year')
vars<-c(id.vars, metrics)

## -----------------------------------------------------------------------------
vdem<-vdem[, ..vars]

## -----------------------------------------------------------------------------
vdem <- vdem[year>1950]

## -----------------------------------------------------------------------------
names(vdem)[2]<-"cow"

## -----------------------------------------------------------------------------
unique(vdem[is.na(cow),country_name])

## -----------------------------------------------------------------------------

library(countrycode)

vdem[, iso3:=countrycode::countrycode(cow, 
                                      origin = "cown",
                                      destination = "iso3c")]


## -----------------------------------------------------------------------------
vdem[cow %in% c(260, 265, 315, 345, 347, 511, 678, 680, 817), unique(country_name)]

## -----------------------------------------------------------------------------
vdem <- vdem[!is.na(cow)][, iso3:=NULL]

## -----------------------------------------------------------------------------
dcast(vdem[cow %in% c(345, 341, 347), .(country_name, cow, year)],
      year~cow, value.var = "country_name")

## -----------------------------------------------------------------------------
for(i in 1995:2005) vdem[cow %in% c(341,345) & year==i, (metrics):=lapply(.SD, mean, na.rm = TRUE), .SDcols = metrics]

## -----------------------------------------------------------------------------
dcast(vdem[cow %in% c(625,626), .(country_name, cow, year)],year~cow, value.var = "country_name")

## -----------------------------------------------------------------------------
cowstates<-data.table::setDT(states::cowstates)
missing_in_vdem<-cowstates[end >= sprintf("%s-01-01", 1995)][!cowcode %in% vdem$cow]
knitr::kable(missing_in_vdem)

## -----------------------------------------------------------------------------
microstates <- cowstates[microstate==TRUE,unique(cowcode)]
vdem<-vdem[!(cow %in% microstates)]

## -----------------------------------------------------------------------------
dupes<-unique(vdem[,.(country_name, cow)])
# check for duplicate names across codes
table(duplicated(dupes$country_name))

## -----------------------------------------------------------------------------
hist.dat<-melt(vdem, 
               id.vars = c("cow", "year"),
               measure.vars = c("v2x_libdem",
                                "v2x_polyarchy"),
               variable.name = "metric",
               value.name = "value")

ggplot2::ggplot(hist.dat, ggplot2::aes(x=value))+
  ggplot2::geom_histogram()+
  ggplot2::facet_wrap(~metric)+
  ggplot2::labs(title = "V-Dem Metric Distributions",
                x = "Value",
                y= "Count")+
  ggplot2::theme_minimal()

## -----------------------------------------------------------------------------
vdem[is.na(v2x_libdem) | is.na(v2x_polyarchy),.(unique(country_name), n=.N, last_year=max(year)), by=cow]

## -----------------------------------------------------------------------------
vdem[cow==860, .(country_name, year, v2x_libdem, v2x_polyarchy)]

## -----------------------------------------------------------------------------
vdem[cow==692, .(country_name, year, v2x_libdem, v2x_polyarchy)]


## -----------------------------------------------------------------------------
ggplot2::ggplot(vdem[cow==692], ggplot2::aes(x=year, y=v2x_libdem))+
  ggplot2::geom_point(size = 2)+
  ggplot2::labs(title="Bahrain Libdem Time Series",
                x = "Year",
                y = "Libdem")+
  ggplot2::theme_minimal()

## -----------------------------------------------------------------------------
vdem[cow==692 & year==2001, v2x_libdem := vdem[cow==692 & year==2002, v2x_libdem]]

## -----------------------------------------------------------------------------
vdem <- vdem[, .(cow, year, v2x_libdem, v2x_polyarchy)]

## -----------------------------------------------------------------------------
cols<-c("cow", "year")
vdem[, (cols):=lapply(.SD, as.integer), .SDcols = cols]

## -----------------------------------------------------------------------------
data.table::setDF(vdem)

