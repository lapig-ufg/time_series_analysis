####################################################################################################
####################################################################################################
#'Claudinei Oliveira-Santos
#'LAPIP - Laboratorio de Processamento de Imagens e Geoprocessamento
#'Doutorando em Ciencias Ambientais - UFG
#'claudineisantosnx@gmail.com

#############################################
#############################################
#Descricao

options(scipen = 999)
#############################################
#############################################
#pacotes
library(raster)
library(doBy)
library(OpenStreetMap)
###
###
shp11 <- shapefile('H:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_11.shp')
shp55 <- shapefile('H:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_55.shp')
shp111 <- shapefile('H:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_111.shp')
shp200 <- shapefile('H:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_200.shp')

###
###
plot(shp200)

#processamentoaqua
################################################################################
################################################################################


##################################################
## London Data Maps Visualisation               ##
## Author: Mark Bulling                         ##
## Date: 2011-06-01                             ##
## Comments: code to generate maps of London    ##
##################################################

library(ggplot2)
library(maps)
library(sp)

x <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap")
# install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE) # load the required packages


dt200 <- shp200@data
head(dt200)

#### Plot the map - facetted by country of origin
plot(shp200, col = "lightgrey") # plot the london_sport object
sel <- sample(1:460,50)
plot(shp200[sel, ], col = "darkblue", add = TRUE) # add selected zones to map
plot(shp200[150, ], col = "red", add = TRUE) # add selected zones to map

# Find the centre
center <- coordinates(gCentroid(shp200))
plot(gCentroid(shp200), add = TRUE, coll = 'black', lwd = 5)
points(center, col = 'blue', lwd = 5)

center_pol <- coordinates(gCentroid(shp200[150,]))
plot(gCentroid(shp200[150,]), add = TRUE, coll = 'forestgreen', lwd = 5)
points(center_pol, col = 'pink', lwd = 5)

####
####
# Find the centre of the london area
easting_lnd <- coordinates(gCentroid(shp200))[[1]]
northing_lnd <- coordinates(gCentroid(shp200))[[2]]

# arguments to test whether or not a coordinate is east or north of the centre
east <- sapply(coordinates(shp200)[,1], function(x) x > easting_lnd)
north <- sapply(coordinates(shp200)[,2], function(x) x > northing_lnd)

# test if the coordinate is east and north of the centre
shp200$quadrant <- "unknown" # prevent NAs in result
shp200$quadrant[east & north] <- "northeast"



###
###
#map with tmap
vignette("tmap-nutshell")
qtm(shp = shp200, fill = "ID", fill.palette = "-Blues") # not shown
#Good to plot!
qtm(shp = shp200, fill = c("ID", "Y_MIN", "Y_MAX", "X_MAX"), fill.palette = "Blues", ncol = 2) 


###
###
#Maptools

lnd_wgs = spTransform(shp200, CRS("+init=epsg:4326"))
if(curl::has_internet()) {
  osm_tiles = tmaptools::read_osm(bbox(lnd_wgs)) # download images from OSM
  tm_shape(osm_tiles) + tm_raster() +
    tm_shape(lnd_wgs) +
    tm_fill("Pop_2001", fill.title = "Population, 2001", scale = 0.8, alpha = 0.5) +
    tm_layout(legend.position = c(0.89, 0.02)) 
} else {
  tm_shape(lnd_wgs) +
    tm_fill("Pop_2001", fill.title = "Population, 2001", scale = 0.8, alpha = 0.5) +
    tm_layout(legend.position = c(0.89, 0.02))
}


###
###
#GGPLOT
library(ggplot2)
p <- ggplot(lnd@data, aes(Partic_Per, Pop_2001))

p + geom_point(aes(colour = Partic_Per, size = Pop_2001)) +
  geom_text(size = 2, aes(label = name))




###
###
#Rgeos
lnd_f <- fortify(shp200) 

head(lnd_f, n = 2) # peak at the fortified data
shp200$id <- row.names(shp200) # allocate an id variable to the sp data
head(shp200@data, n = 2) # final check before join (requires shared variable name)
lnd_f <- left_join(lnd_f, shp200@data) # join the data

map <- ggplot(lnd_f, aes(long, lat, group = group, fill = quadrant)) +
  geom_polygon() + coord_equal() +
  labs(x = "Easting (m)", y = "Northing (m)",
       fill = "% Sports\nParticipation") +
  ggtitle("London Sports Participation")



install.packages("leaflet")
library(leaflet)


m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=lnd_f$long, lat=lnd_f$lat, popup="ID")
m  # Print the map


####
####
#Use that
library(maps)
mapStates = map(shp, fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(2, alpha = NULL), stroke = FALSE, fillOpacity = 0.4)



library(rgdal)

states <- readOGR("H:\\DATASAN\\shapefile\\limite_estados\\pa_br_estados_250_2013_ibge.shp",
                  layer = "pa_br_estados_250_2013_ibge", GDAL1_integer64_policy = TRUE)
neStates <- subset(states, states$NM_UF %in% c(
  "TO", "BA", "SE", 'DF', "MG", "MT", "PA"
))

leaflet(states) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", as.numeric(CD_GEOCUF))(as.numeric(CD_GEOCUF)),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))


leaflet(shp111) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("BuPu", as.numeric(ID))(as.numeric(ID)),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))


leaflet(shp55) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("BuPu", as.numeric(ID))(as.numeric(ID)),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))


leaflet(shp11) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("BuPu", as.numeric(ID))(as.numeric(ID)),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))



# 
# jpeg("/tmp/foo%02d.jpg")
# for (i in 1:5) {
#   my.plot(i)
# }      
# make.mov <- function(){
#   unlink("plot.mpg")
#   system("convert -delay 0.5 plot*.jpg plot.mpg")
# }
# 
# dev.off()
library(ggplot2)
# ggWatershed <- 
  ggplot(data = lnd_f, aes(x=long, y=lat, group = group,
                                              fill = ID)) +
  geom_polygon()  +
  geom_path(color = "white") +
  scale_fill_hue(l = 40) +
  coord_equal() +
  theme(legend.position = "none", title = element_blank(),
        axis.text = element_blank())

# print(ggWatershed)
