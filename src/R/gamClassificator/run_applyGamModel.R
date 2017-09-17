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
unixtools::set.tempdir("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/RTEMP/")
pathPrc <- "/data/PROCESSAMENTO/"
# pathDt1 <- "/data/DADOS01/"
# pathDt2 <- "/data/DADOS02/"

###
###
#packages and functions
library(raster)
library(forecast)
library(parallel)
source(paste0(pathPrc,"SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/applyGamModel.R"))
source(paste0(pathPrc,"SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/Function_to_filter_ndvi.R"))
source(paste0(pathPrc,"SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/MaxMinFilter.R"))

###
###
#files
shp <- shapefile("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/DADOS/gridbrasil/Grid_br_11_km_wgs84.shp")
load("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/gamModel.RData")
mod_gam_full <- mod_gam_full

shpSub <- shp[shp$OBJECTID == 73422,]

# lsf <- Sys.glob(file.path(path = "/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/DADOS/pa_br_ndvi_250_lapig/", "*.tif"))

setwd("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/DADOS/pa_br_ndvi_250_lapig/")
lsf <- Sys.glob("*.tif")

lsf14 <- grep("2014", lsf, value = TRUE)
lsf15 <- grep("2015", lsf, value = TRUE)
lsf16 <- grep("2016", lsf, value = TRUE)
lsf <- c(lsf14, lsf15, lsf16)
rstStk<- stack(sapply(lsf, raster))

rstCrp <- crop(rstStk, shpSub)

###
###
#na.interp
beginCluster()
ST <- Sys.time()
 rstFilt <- clusterR(rstCrp, calc, args = list(fun=FILTERNDVIPOLY))#,
#          filename = "/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/ndvifilter/results/ndviFilterAllImages/filter",
#          format = "GTiff",
#          bylayer = TRUE, suffix = c(names(rstCrp),"naCount"))
print(Sys.time() - ST)
# endCluster()

 rstFilt <- rstFilt[[-70]]
 rtp <- rasterToPoints(rstFilt)
 
 # cl <- makeCluster(detectCores() - 1)
 ST = Sys.time()
 tempList = parApply(cl = cl, rtp, 1, gamApply)
 Sys.time() - ST
 # stopCluster(cl)
 

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
tempList = parApply(cl = cl, ndviFilter, 1, gamApply)
Sys.time() - ST
# stopCluster(cl)

df <- do.call("rbind", tempList)
ndviProbPast[1:1000, 3:19] <-df

################################################################################
################################################################################