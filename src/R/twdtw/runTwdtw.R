################################################################################
################################################################################
#'Claudinei Oliveira-Santos
#'LAPIP - Laboratorio de Processamento de Imagens e Geoprocessamento
#'Doutorando em Ciencias Ambientais - UFG
#'claudineisantosnx@gmail.com

###
###
#Descricao
options(scipen = 999)
#install.packages("doBy")

###
###
#pacotes
library(raster)
library(rasterVis)
library(dtwSat)
rasterOptions(tmpdir = "/hds/ssd/DATASAN/rasterRTmpFile/")
# source("/hds/dados_work/Dropbox (Pessoal)1/carreira/Lapig/GitHubLapig/time_series_analysis/src/R/utils/MaxMinFilter.r")
###
###
#Timeline
timeline <- scan("/hds/dados_work/Dropbox (Pessoal)1/carreira/Lapig/GitHubLapig/LAPIG_TSA/data/timeline", what = 'Date')
timeline <- as.Date(timeline)

#Shape
# shp <- shapefile('/hds/ssd/DATASAN/shapefile/GridBrasil/gridbrasil/Grid_br_11_km_wgs84.shp')
# shpSub <- shp[93343, ]
# plot(shpSub)

#Raster
# LFS <- list.files(path = '../../raster/ndviBHRVCrop/', pattern = "*.tif", full.names = TRUE)
# 
# ST = Sys.time()
# r <- stack(
#   sapply(LFS, function(x) {
#     crop(raster(x), shpSub)
#   }))
# Sys.time() - ST
# 
# writeRaster(r, filename = "/hds/ssd/DATASAN/raster/ndviTwdtw/NDVI_11KM_93343.tif")
# r <- brick("/hds/ssd/DATASAN/raster/ndviTwdtw/NDVI_11KM_93343.tif")

# doy <- r
# doy[] <- NA
# 
# vdoy <- as.numeric(substr(names(r), 57,59), byrow = TRUE)
# mdoy <- matrix(data = vdoy, 
#                nrow = ncell(doy),
#                ncol = length(vdoy),
#                byrow = TRUE)
# 
# doy[] <- mdoy
# names(doy) <- rep('doy', length(vdoy))
# #levelplot(doy[[1:50]])
# 
# writeRaster(doy, filename = "/hds/ssd/DATASAN/raster/ndviTwdtw/DOY_11KM_93343.tif")

###
###
#arquivos
load('/hds/ssd/DATASAN/result/twdtw/patt_pastagem.RData')
pastPatt <- dados_patt
  rm(dados_patt)
plot(pastPatt)

timeline <- time(pastPatt@timeseries$pastagem_1)

ndvi <- read.csv("/hds/ssd/limiaresTWDTW/limiar_grupo1.csv", sep = ";", dec = ",")
###
###
pixm <- as.matrix(ndvi[,3])
colnames(pixm) <- 'ndvi'

TSzoo <- zoo(pixm, timeline)
head(TSzoo)

###
###
ts <- twdtwTimeSeries(TSzoo)
plot(ts, type = 'timeseries')

###
###
log_fun <- logisticWeight(alpha = -0.1, beta = 100) 
# Run TWDTW analysis
ST <- Sys.time()
matches <- twdtwApply(x = ts, y = pastPatt, weight.fun = log_fun, keep = TRUE) 
#class(matches)
Sys.time() - ST
matches@alignments[[1]]$pastagem_1$distance
matches@alignments[[1]]$pastagem_2$distance
matches@alignments[[1]]$pastagem_3$distance
matches@alignments[[1]]$pastagem_4$distance

###
###
plot(x = matches, type = "alignments")
plot(x = matches, type = "paths", k <- 1:4) 

plot(x = matches, type = "classification",
     from = timeline[1], to = timeline[23], 
     by = "2 month", overlap = 1) 

################################################################################
################################################################################