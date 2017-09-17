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
library(parallel)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
r <- brick("E:/pa_br_mod13q1_ndvi_250_2000_2017.tif")
dates <- scan('../../../data/bfast/timeline', what = 'date')
NdviSiad <- read.csv("F:\\DATASAN\\raster\\siad_raster_2016\\NdviSiad.csv")
load("F:\\DATASAN\\raster\\siad_raster_2016\\CellNumberPolSiad.rdata")

###
###
PolNumber <- CellNumberPolSiad

###
###
#Function to extract data
PixExtract <- function(x){

pix <- NULL
r <- raster::brick("E:/pa_br_mod13q1_ndvi_250_2000_2017.tif")
source('../../../src/R/utils/MaxMinFilter.r')

CellNumber <- as.numeric(x)

for (i in 1:length(CellNumber)) {
  pix <- rbind(pix, as.numeric(r[CellNumber[i] ]))
}

pix <- t(apply(pix, 1, forecast::na.interp))

pix <- t(apply(pix, 1, MaxMinFilter, n = 3))

pix <- colMeans(pix, na.rm = TRUE)

return(pix)
}

###
###
#Extract in parallel
cl <- makeCluster(detectCores() - 1)
ST <- Sys.time()
NDVI <- parLapply(cl = cl, PolNumber, PixExtract)
Sys.time() - ST
stopCluster(cl)

r.ndvi <- do.call("rbind", NDVI)

NdviSiad[, 8:399] <- do.call("rbind", NDVI)

write.csv(NdviSiad, file = "F:\\DATASAN\\raster\\siad_raster_2016\\NdviSiad_2.csv")
 
####################################################################################
####################################################################################