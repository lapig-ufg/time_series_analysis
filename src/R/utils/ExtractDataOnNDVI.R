####################################################################################
####################################################################################
#Author: Oliveira-Santos, claudinei
#
#Script para rodar twdtw para o SIAD
#
####################################################################################
####################################################################################
#Pacotes e funcoes
library(raster)

#Arquivos
shp <- shapefile("F:\\DATASAN\\raster\\siad_raster_2016\\siad_2016_inspecionado.shp")
r <- brick("E:\\pa_br_mod13q1_ndvi_250_2000_2017.tif")

shp_i <- shp[shp$OBJECTID %in% 1:10000,]
plot(shp_i)

ST <- Sys.time()
df <- cellFromPolygon(r, shp)
Sys.time() - ST

CellNumberPolSiad <- df

save(CellNumberPolSiad, file = "F:\\DATASAN\\raster\\siad_raster_2016\\CellNumberPolSiad.rdata")

####################################################################################
####################################################################################