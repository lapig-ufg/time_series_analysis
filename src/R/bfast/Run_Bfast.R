####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
r <- brick('S:/PORTAL/time-series-db/pa_br_mod13q1_ndvi_250_2000_2017.tif');
samples = read.csv('../../../data/bfast/samples.csv')
ndvi = read.csv('../../../data/bfast/NDVIMod13q1.csv')
dates = scan('../../../data/bfast/timeline', what = 'date')

#Parametros dos bfast
h = 0.16099599
season = "harmonic"

ndvi.2 <- ndvi[,c(2,8:399)]

#Timeline NDVI
dates <- as.Date(dates)

ResultBfastNdvi <- NULL
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = nrow(ndvi.2), style = 3)
for (l in 1:nrow(ndvi.2)) {
  pix <- as.numeric(ndvi.2[l,])
  ResultBfastNdvi <- rbind(ResultBfastNdvi, RunBfast(pix, h, season))
  setTxtProgressBar(pb, l)
}
close(pb) 
Sys.time() - ST

#Time difference of 7.052529 mins

ResultBfastNdvi2 <- ResultBfastNdvi


#######################################################################################
#######################################################################################