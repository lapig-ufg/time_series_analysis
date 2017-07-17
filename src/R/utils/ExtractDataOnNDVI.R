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
library(forecast)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
shp <- shapefile("F:\\DATASAN\\raster\\siad_raster_2016\\siad_2016_inspecionado.shp")
r <- brick("E:\\pa_br_mod13q1_ndvi_250_2000_2017.tif")
dates = scan('../../../data/bfast/timeline', what = 'date')

head(shp@data)


ST <- Sys.time()
df <- cellFromPolygon(r, shp)
Sys.time() - ST

# CellNumberPolSiad <- df
# 
# save(CellNumberPolSiad, file = "F:\\DATASAN\\raster\\siad_raster_2016\\CellNumberPolSiad.rdata")

###
###
# NdviSiad <- shp@data
# NdviSiad[, 8:399] <- NA
# names(NdviSiad)[8:399] <- dates
# head(NdviSiad)
# 
# write.csv(NdviSiad, file = "F:\\DATASAN\\raster\\siad_raster_2016\\NdviSiad.csv")


CellNumber <- df[[1]]

pix <- NULL
ST <- Sys.time()
for (i in 1:length(CellNumber)) {
  pix <- rbind(pix, as.numeric(r[CellNumber[i] ]))
}
Sys.time() - ST



pix <- t(apply(pix, 1, na.interp))

pix <- t(apply(pix, 1, MaxMinFilter, n = 3))

pix <- colMeans(pix, na.rm = TRUE)



NdviSiad[1, 8:399] <- pix
 head(NdviSiad[, 1:10]) 
  
# write.csv(NdviSiad, file = "F:\\DATASAN\\raster\\siad_raster_2016\\NdviSiad.csv")
 
####################################################################################
####################################################################################