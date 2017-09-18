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
#pacotes e funcoes
library(raster)
library(parallel)
source("/hds/dados_work/GitHub/time_series_analysis/src/R/lci/ZonalStatisticAllBrasil.R")
###
###
#files
ndviCell <- raster("/hds/dados_work/DATASAN/raster/NDVI/CellNUmberNDVIBrasil_brlimite.tif")
ndviLandsat <- raster("/hds/dados_work/DATASAN/raster/LCI/pa_br_landsat_ndvi_median_30_2016_lapig.tif")

load("/hds/dados_work/DATASAN/raster/NDVI/CellNUmberNDVIBrasil_brlimite.RData")
# cellNumber <- ndviCellBrLim$cellNumber
# rm(ndviCellBrLim)
gc(reset = TRUE)

ST <- Sys.time()
f2 <- function(x) {ZonalStatLapig(pix = as.numeric(x[3]), rlow = ndviCell, rhigh = ndviLandsat)}
ndviCellBrLimZN <- t(apply(ndviCellBrLim, 1, FUN = f2))
Sys.time() - ST

save(ndviCellBrLimZN, file = "/hds/dados_work/DATASAN/raster/NDVI/ZN_NDVI_Landsat.RData")
####################################################################################################
####################################################################################################