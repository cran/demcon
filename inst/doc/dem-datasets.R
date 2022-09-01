## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----sample-image, echo=FALSE, fig.cap="Global map of Varieties of Democracy's 2021 'v2x_lbdem' composite metric. Raw V-Dem data is tabular, but depicted here using a choropleth.", warning=FALSE, message=FALSE, fig.pos='center', fig.height=4.5, fig.width=7----

library(data.table)
library(sf)
library(rnaturalearth)

vdem.raw <- demcon::get_vdem()
data.table::setDT(vdem.raw)

metrics<-c('v2x_libdem')

id.vars<-c('country_name', 'COWcode','histname' ,'codingstart_contemp', 'codingend_contemp','year')
vars<-c(id.vars, metrics)

vdem<-vdem.raw[year==max(year), ..vars]
rm(vdem.raw)

global<-rnaturalearth::ne_countries(returnclass = 'sf')
global$cow<-countrycode::countrycode(global$iso_a3, origin = "iso3c", destination = "cown")
global<-merge(
  global, vdem,
  by.x = "cow", by="COWcode", all.x = TRUE
)

plot(global[, "v2x_libdem"], graticule = TRUE, key.pos = 1, axes = TRUE, key.width = lcm(1.3), key.length = 1.0)


