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

# rtp <- rasterToPoints(ndviCell)
# ndviCellBrLim <- as.data.frame(rtp)
# names(ndviCellBrLim) <- c("longitude", "latitude", "cellNumber")
# save(ndviCellBrLim, file = "/hds/dados_work/DATASAN/raster/NDVI/CellNUmberNDVIBrasil_brlimite.RData")
load("/hds/dados_work/DATASAN/raster/NDVI/CellNUmberNDVIBrasil_brlimite.RData")
gc(reset = TRUE)


cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
ndviCellBrLimZN <- t(parApply(cl = cl, ndviCellBrLim, MARGIN = 1, FUN = ZonalStatLapig))
Sys.time() - ST
save(ndviCellBrLimZN, file = "/hds/dados_work/DATASAN/raster/NDVI/ZN_NDVI_Landsat.RData")
stopCluster(cl)
####################################################################################################
####################################################################################################