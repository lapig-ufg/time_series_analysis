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
unixtools::set.tempdir("/hds/ssd/DATASAN/rtemp/")
###
###
#files and data
lower <- c(1.42, 1.58, 1.3, 1.3)
upper <- c(1.48, 1.56, 1.32, 1.7)

setwd("/hds/ssd/DATASAN/result/twdtw/")
lsf <- Sys.glob("*Past*Patt*tif")

###
###
#Pattern 1
rPatt <- brick(lsf[1])
rPatt[ rPatt > min(upper[1], lower[1]) ] <- NA
# rPatt[ rPatt < lower[1] ] <- NA
writeRaster(rPatt, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_01_PattOne_twdtw_2000_2016.tif", overwrite = TRUE)

###
###
#Pattern 2
rPatt <- brick(lsf[2])
rPatt[ rPatt > min(upper[2], lower[2]) ] <- NA
# rPatt[ rPatt < lower[2] ] <- NA
writeRaster(rPatt, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_02_PattTwo_twdtw_2000_2016.tif", overwrite = TRUE)


###
###
#Pattern 3
rPatt <- brick(lsf[3])
rPatt[ rPatt > min(upper[3], lower[3]) ] <- NA
# rPatt[ rPatt < lower[3] ] <- NA
writeRaster(rPatt, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_03_PattThr_twdtw_2000_2016.tif", overwrite = TRUE)


###
###
#Pattern 4
rPatt <- brick(lsf[4])
rPatt[ rPatt > min(upper[4], lower[4]) ] <- NA
# rPatt[ rPatt < lower[4] ] <- NA
writeRaster(rPatt, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_04_PattFou_twdtw_2000_2016.tif", overwrite = TRUE)

# plot(rPatt[[1]])


###
###
lsf <- Sys.glob("lim*Past*Patt*tif")
rPatt1 <- brick(lsf[1])
rPatt2 <- brick(lsf[2])
rPatt3 <- brick(lsf[3])
rPatt4 <- brick(lsf[4])

###
###
#Distancia
tempList <- list()
for(i in 1:16){
  cat("loop", i, "\n")
  
  rPatt <- stack(rPatt1[[i]], rPatt2[[i]], rPatt3[[i]], rPatt4[[i]])
  tempList[[i]] <- calc(rPatt, min)
}
rDist <- stack(tempList)
names(rDist) <- paste0("distancia_", 2001:2016)
writeRaster(rDist, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_DISTANCIA_2000_2016.tif", overwrite = TRUE)

rDist <- brick("/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_DISTANCIA_2000_2016.tif")
rtpDist <- rasterToPoints(rDist)
save(rtpDist, file = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_DISTANCIA_2000_2016.rdata")


###
###
#Classes
tempList <- list()
for(i in 1:16){
  cat("loop", i, "\n")
  
  rPatt <- stack(rPatt1[[i]], rPatt2[[i]], rPatt3[[i]], rPatt4[[i]])
  tempList[[i]] <- which.min(rPatt)
}
rClass <- stack(tempList)
names(rClass) <- paste0("Classes_", 2001:2016)
writeRaster(rClass, filename = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_CLASSES_2000_2016.tif", overwrite = TRUE)

plot(rClass[[1:4]])

rClass <- brick("/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Pasture_CLASSES_2000_2016.tif")
rtpClass <- rasterToPoints(rClass)
save(rtpClass, file = "/hds/ssd/DATASAN/result/twdtw/limiar_BHRV_Classes_2000_2016.rdata")

################################################################################
################################################################################