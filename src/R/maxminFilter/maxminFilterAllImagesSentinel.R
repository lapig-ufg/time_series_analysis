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

###
###
#packages and functions
library(raster)
library(forecast)
library(parallel)
source("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/Function_to_filter_ndvi.R")

###
###
#files
setwd("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/DADOS/pa_br_ndvi_250_lapig/")
lsf <- Sys.glob("*.tif")

rstStk<- stack(sapply(lsf, raster))

###
###
#na.interp
beginCluster()
ST <- Sys.time()
clusterR(rstStk, calc, args = list(fun=FILTERNDVIPOLY),
	filename = "/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/ndvifilter/results/ndviFilterAllImages/filter",
	format = "GTiff",
	bylayer = TRUE, suffix = c(names(rstStk),"naCount"))
print(Sys.time() - ST)
endCluster()
################################################################################
################################################################################