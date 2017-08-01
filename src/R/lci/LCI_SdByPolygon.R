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
library(parallel)
library(doParallel)
source("ZonalStatisticByPoligon.R")

###
###
shp <- shapefile('F:\\DATASAN\\shapefile/GridBrasil/gridbrasiliduf/Grid_br_111_km_wgs84_iduf.shp')
Mod <- raster('H:\\DATASAN\\raster\\NDVI\\CellNUmberNDVIBrasil_brlimite.tif')
Ndvi <- raster('F:\\DATASAN\\raster\\ndvimedian\\2016-1.tif')

###
###
path <- 'F:\\DATASAN\\results\\lci_br\\ndvi\\'
Name <- 'NDVI_SD_'

###
###
shp <- shp[shp$inbrasil == 1, ]
seq(1, length(shp),186)
###
###
plot(shp)

# for (i in 1:280) {
# for (i in 281:560) {
# for (i in 561:840) {
for (i in 841:1113) {
ST <- Sys.time()
  
ZonalStatLapig(rlow = Mod, rhigh = Ndvi, shpi = shp[i,], Path = path, Name = Name)

plot(shp[i,], col = 'blue', add = TRUE)

print( Sys.time() - ST)
}

#processamentoaqua
################################################################################
################################################################################