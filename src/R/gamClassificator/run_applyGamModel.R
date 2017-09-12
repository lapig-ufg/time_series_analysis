####################################################################################################
####################################################################################################
#'Claudinei Oliveira-Santos
#'LAPIP - Laboratorio de Processamento de Imagens e Geoprocessamento
#'Doutorando em Ciencias Ambientais - UFG
#'claudineisantosnx@gmail.com

###
###
#description
#'rodar classificador gam desenvildo pelo prof. Luís Baumman

###
###
#congiguration
options(scipen = 999)

###
###
#packages and functions
library(raster)
library(forecast)
library(parallel)
source("/hds/ssd/ClassificadorLuis/algoritmo_gam_global_san_rodar.R")
source("/hds/ssd/ClassificadorLuis/MaxMinFilter.R")

###
###
#files
# ndvi <- brick("/hds/ssd/DATASAN/raster/BHRV_MASK_pa_br_ndvi_ALL.tif")
# load("/hds/ssd/ClassificadorLuis/mod_gam_full.RData")

###
###
#na.interp
ndviNaInterp <- rtp_bhrv
ndviNaInterp[, -c(1:2)] <- NA
colnames(ndviNaInterp)[3:394] <- "ndvi"

#
cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
ndviNaInterp[, -c(1:2)] <- t(parApply(cl = cl, rtp_bhrv[,-c(1:2)], 1, na.interp))
Sys.time() - ST
stopCluster(cl)
#save(ndviNaInterp, file = "/hds/ssd/ClassificadorLuis/rtp_BHRV_ndviNaInterp.rdata")

###
###
#maxminFilter
ndviFilter <- ndviNaInterp
ndviFilter[, -c(1:2)] <- NA
colnames(ndviFilter)[3:394] <- "ndviFilter"

#
cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
ndviFilter[, -c(1:2)] <- t(parApply(cl = cl, ndviNaInterp[,-c(1:2)], 1, na.interp))
Sys.time() - ST
stopCluster(cl)
# save(ndviFilter, file = "/hds/ssd/ClassificadorLuis/rtp_BHRV_ndviFilter.rdata")
load("/hds/ssd/ClassificadorLuis/rtp_BHRV_ndviFilter.rdata")

###
###
#run model
ndviProbPast <- ndviFilter[, 1:20]
ndviProbPast[, -c(1:2)] <- NA
colnames(ndviProbPast)[3:18] <- "ndviProbPast"

cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
tempList = parApply(cl = cl, ndviFilter, 1, past_prev)
Sys.time() - ST
# stopCluster(cl)

df <- do.call("rbind", tempList)
ndviProbPast[1:1000, 3:19] <-df

################################################################################
################################################################################