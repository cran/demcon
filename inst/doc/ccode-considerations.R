## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(magrittr)

## ----echo=FALSE---------------------------------------------------------------
vdem <- demcon::get_vdem()
data.table::setDT(vdem)

somalia<-vdem[country_name=="Somalia", .(Start=min(year), End=max(year)), by=.(country_name,histname,COWcode)]

somalia %>% 
  kableExtra::kbl(caption = "V-Dem country name, V-Dem historic designation, Correlates of War country code, and start and end years for Somalia in the raw V-Dem Version 11.1 dataset.") %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", position = 'center'))

## ----echo=FALSE, message=FALSE, warning=FALSE, fig.height=9, fig.width=6, fig.align='center', fig.cap="Visual timeline of significant secessions from the former Yugoslavian state as internationally recognized and coded by the Correlates of War and cshapes project. The top panel depicts Yugoslavia (highlighted teal) in its 1989 unified state. Highlighted countries in remaining panels illustrate countries that gained sovereignty since the previous date."----
 steps <- data.table::data.table(
   dates = c(
     as.Date("1989-1-1"),
     as.Date("1992-5-1"),
     as.Date("1993-5-1"),
     as.Date("2006-7-1"),
     as.Date("2008-3-1")
   ),
   cow_codes = c(list(c(345)),
                 list(c(344, 346, 349)),
                      list(c(343)),
                           list(c(341)),
                                list(c(347)))
 )

 bb<-c(xmin=13,ymin=40,xmax=24,ymax=47)
 balkans<-list()

 for(i in 1:dim(steps)[1]){

  cshp<-cshapes::cshp(date=steps$dates[i], useGW = FALSE)
  cshp<-sf::st_make_valid(cshp)
  cshp<-sf::st_crop(cshp, bb)
  labels<-data.table::data.table(country_name=as.character(cshp$country_name),
                                 sf::st_coordinates(sf::st_point_on_surface(cshp)))
  new_shps<-cshp[cshp$cowcode %in% steps$cow_codes[[i]],]
  cshp<-cshp[!(cshp$cowcode %in% steps$cow_codes[[i]]),]
  bbox<-sf::st_bbox(cshp)

   balkans[[as.character(steps$dates[[i]])]]<-
     ggplot2::ggplot() +
     ggplot2::geom_sf(data=cshp, fill = "#F5F5F5") +
     ggplot2::geom_sf(data=new_shps, fill="#00dada") +
     ggplot2::coord_sf(xlim = c(bb[1], bb[3]),
                       ylim = c(bb[2], bb[4]),
                       expand = FALSE)+
     ggplot2::scale_x_continuous(breaks = seq(bb[1], bb[3], by = 2)) +
     ggplot2::scale_y_continuous(breaks = seq(bb[2], bb[4], by = 2)) +
     ggrepel::geom_text_repel(
       data=labels,
       ggplot2::aes(X, Y, label = country_name),
       min.segment.length = 5,
       seed = 1,
       force = 1,
       force_pull = 2,
       size = 3,
       xlim = c(NA, Inf),
       ylim = c(-Inf, Inf))+
     ggplot2::labs(x="",
                   y="",
                   title = as.character(lubridate::year(steps$dates[i])))+
     ggplot2::theme(
       plot.title = ggplot2::element_text(hjust = 0.5),
       panel.grid.major = ggplot2::element_line(
       color = gray(0.5),
       linetype = "dashed",
       size = 0.5),
       panel.background = ggplot2::element_rect(fill = "aliceblue"))

 }

 ggplot2::ggplot() +
   ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 9), expand = FALSE) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(balkans$`1989-01-01`),
                              xmin = 1.25, xmax = 4.75, ymin = 5.25, ymax = 9) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(balkans$`1992-05-01`),
                              xmin = 0, xmax = 3, ymin = 2.5, ymax = 6) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(balkans$`1993-05-01`),
                              xmin = 3, xmax = 6, ymin = 2.5, ymax = 6) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(balkans$`2006-07-01`),
                              xmin = 0, xmax = 3, ymin = 0, ymax = 3) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(balkans$`2008-03-01`),
                              xmin = 3, xmax = 6, ymin = 0, ymax = 3)+
   ggplot2::theme_void()

## ----echo=FALSE, message=FALSE, warning=FALSE, fig.width=7.5, fig.height=4, fig.align='center', fig.cap="Visual timeline of internationally recognized sovereign borders of Yemen, North Yemen, and South Yemen. Historic boundaries are determined by the cshapes packages. Note that cshapes does not include land area that lacks international independence. Hence, in the 1946 (left) panel, British Aden (South Yemen) and Djibouti are not present until they've gained their respective independence."----
steps <- data.table::data.table(
   dates = c(
     as.Date("1946-10-01"),
     as.Date("1967-12-1"),
     as.Date("1990-6-1")
   ),
   cow_codes = c(list(c(678)),
                 list(c(680)),
                 list(c(679)))
 )
 
 bb<-c(xmin=40,ymin=9,xmax=55,ymax=22)
 yemens<-list()

 for(i in 1:dim(steps)[1]){
   
  cshp<-cshapes::cshp(date=steps$dates[i], useGW = FALSE)
  cshp<-sf::st_make_valid(cshp)
  cshp<-sf::st_crop(cshp, bb)
  labels<-data.table::data.table(country_name=as.character(cshp$country_name),
                                 sf::st_coordinates(sf::st_point_on_surface(cshp)))
  new_shps<-cshp[cshp$cowcode %in% steps$cow_codes[[i]],]
  cshp<-cshp[!(cshp$cowcode %in% steps$cow_codes[[i]]),]
  bbox<-sf::st_bbox(cshp)
   
   yemens[[as.character(steps$dates[[i]])]]<-
     ggplot2::ggplot() +
     ggplot2::geom_sf(data=cshp, fill = "#F5F5F5") +
     ggplot2::geom_sf(data=new_shps, fill="#00dada") +
     ggplot2::coord_sf(xlim = c(bb[1], bb[3]),
                       ylim = c(bb[2], bb[4]),
                       expand = FALSE)+
     ggplot2::scale_x_continuous(breaks = seq(bb[1], bb[3], by = 3)) +
     ggplot2::scale_y_continuous(breaks = seq(bb[2], bb[4], by = 3)) +
     ggrepel::geom_text_repel(
       data=labels,
       ggplot2::aes(X, Y, label = country_name),
       min.segment.length = 5,
       seed = 1,
       force = 1,
       force_pull = 2,
       size = 3,
       xlim = c(NA, Inf),
       ylim = c(-Inf, Inf))+
     ggplot2::labs(x="",
                   y="",
                   title = as.character(lubridate::year(steps$dates[i])))+
     ggplot2::theme(
       plot.title = ggplot2::element_text(hjust = 0.5),
       panel.grid.major = ggplot2::element_line(
         color = gray(0.5),
         linetype = "dashed",
         size = 0.5),
       # plot.margin=grid::unit(c(-10,0,-10,0), "mm"),
       panel.background = ggplot2::element_rect(fill = "aliceblue"))
   
 }
 
 ggplot2::ggplot() +
   ggplot2::coord_equal(xlim = c(0, 9), ylim = c(0, 3), expand = FALSE) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(yemens$`1946-10-01`),
                              xmin = 0, xmax = 3, ymin = 0, ymax = 3) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(yemens$`1967-12-01`),
                              xmin = 3, xmax = 6, ymin = 0, ymax = 3) +
   ggplot2::annotation_custom(ggplot2::ggplotGrob(yemens$`1990-06-01`),
                              xmin = 6, xmax = 9, ymin = 0, ymax = 3) +
   ggplot2::theme_void()

