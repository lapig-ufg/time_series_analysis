####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
library(plyr)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
# siadbf <- read.csv("F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols.csv")
# siadbf_lp <- read.csv("F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols_lastparte.csv")
# 
# siadbf <- rbind(siadbf, siadbf_lp)
# 
# write.csv(siadbf, file = "F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols_ALL.csv", row.names = FALSE)

# siadbf <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols_ALL.csv")
# siadbf <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols_wvl.csv")

sbf_all <- read.csv("F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols_ALL.csv")
sbf_wvl <- read.csv("F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols_wvl.csv")
sbf_3yr <- read.csv("F:\\DATASAN\\results\\BfastResult\\siad\\BfastResult_cols_3years.csv")

sbf_all$GAP <- c(0, (sbf_all$ID[2:101875] - sbf_all$ID[1:101874]))
sbf_wvl$GAP <- c(sbf_wvl$ID[2:101875] - sbf_wvl$ID[1:101874])
sbf_3yr$GAP <- c(sbf_3yr$ID[2:101875] - sbf_3yr$ID[1:101874])


#table(sbf_3yr$GAP)
table(sbf_all$NBK)
table(sbf_wvl$NBK)
table(sbf_3yr$NBK)

sort(unique(sbf_all$PBK_1))
sort(unique(sbf_all$PBK_2))
sort(unique(sbf_all$PBK_3))
sort(unique(sbf_all$PBK_4))
sort(unique(sbf_all$PBK_5))


sort(unique(sbf_wvl$PBK_1))
sort(unique(sbf_wvl$PBK_2))

(table(sbf_3yr$DBK_1))

#######################################################################################
#######################################################################################

library(raster)
area <- raster(matrix(c(1:4,1),5,5))
shape <- rasterToPolygons(area,fun=function(x){x == 1},dissolve=TRUE)
plot(area)
plot(shape)

library(sp)
shape2 <- disaggregate(shape)
shape2@data
shape2$id <- factor(seq_len(length(shape2)))
spplot(shape2, 'id')

?rasterToPolygons

ndvi_tan_all <- raster('F:\\DATASAN\\raster\\BHRV\\NDVI/BHRV_CROP_pa_br_ndvi_250_2000049_lapig.tif')

pixels = c(5812)

n = 3

rc_tan = c(rowColFromCell(ndvi_tan_all, pixels[i] ))
  
  ndvi_3x3 = crop(ndvi_tan_all, extent(ndvi_tan_all, rc_tan[1] - n, rc_tan[1] + n, rc_tan[2] - n, rc_tan[2] + n))
  
#  rpol_ndvi_3x3 = rasterToPolygons(ndvi_3x3, dissolve = TRUE)
  rpol_ndvi_3x3 = rasterToPolygons(ndvi_3x3, fun = function(x){x > 0.7}, dissolve = TRUE)
  
  plot(ndvi_3x3)
  plot(rpol_ndvi_3x3, add = TRUE, lwd = 2)
