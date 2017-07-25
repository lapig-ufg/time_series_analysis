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
source("F:\\DATASAN/Scripts/time_series_analysis/src/R/lci/DecSD_Function.R")
###
###
shp <- shapefile('F:\\DATASAN\\DADOS\\lci\\gribbrasil\\GRID_BR_111.shp')
shpbrlim <- shapefile('F:\\DATASAN\\DADOS\\limite_brasil\\pa_br_Limite_Brasil_250_2013_ibge.shp')
Mod <- raster('F:\\DATASAN\\DADOS\\lci\\CellNUmberNDVIBrasil.tif')
Dec <- raster('F:\\DATASAN\\DADOS\\lci\\declividade/pa_br_srtm_altitude_30_2000_lapig.tif')
#Ndvi <- raster('F:\\DATASAN\\DADOS\\lci\\landsat/2016-1.tif')

shplim <- crop(shp, Mod)
plot(shplim)
plot(Mod)
plot(shpbrlim, add = TRUE)

crs(shpbrlim) <- crs(Mod)

ST <- Sys.time()
ModBrMask <- mask(Mod, shpbrlim)
ST - Sys.time()

plot(Mod)
plot(shpbrlim, add = TRUE, col = 'blue')
writeRaster(ModBrMask, filename = 'F:\\DATASAN\\DADOS\\lci\\CellNUmberNDVIBrMask_OrigNcell.tif')

shplim <- crop(shp, Mod)
plot(shplim)

###
###
# for (i in 1:460) {
# for (i in 461:920) {
# for (i in 921:1380) {
for (i in 1381:1840) {
ST <- Sys.time()

ZonalStatLapig(Mod = Mod, shpi = shp[i,], Dec = Dec)
  
print(ST - Sys.time())
}
################################################################################
################################################################################
