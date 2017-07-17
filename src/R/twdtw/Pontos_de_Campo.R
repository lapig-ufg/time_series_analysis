####################################################################################
####################################################################################
#'../../../../../../../..'
#' o shape original tinha problemas nos pontos abaixo, que foram excluídos
#' shp2 <- shp[-c(2694, 2780, 3242, 3328),]
#'shapefile(shp2, file ='H:/DATASAN/campo/PontosPastagem_todos/PONTOS_PASTAGEM_ok.shp')



###
###
options(scipen = 999)

#Pacotes e funcoes
library(raster)
library(forecast)
library(measurements)
source('../../../src/R/utils/MaxMinFilter.r')

#Arquivos
r <- brick('E:/pa_br_mod13q1_ndvi_250_2000_2017.tif')
# shp = shapefile('H:/DATASAN/campo/PontosPastagem_todos/PONTOS_PASTAGEM_ok.shp')
# dates = scan('../../../data/bfast/timeline', what = 'date')
# 
# #coordenadas para extrair ndvi
# dfcoord <- as.data.frame(shp@coords)
# names(dfcoord) <- c('lon', 'lat')
# dfcoord$CellNumber <- cellFromXY(r, dfcoord)
# write.csv(dfcoord, file = "H:/DATASAN/campo/PontosPastagem_todos/PontosPastagem.csv", row.names = FALSE)
#pontos <- read.csv("H:/DATASAN/campo/PontosPastagem_todos/PontosPastagem.csv")

#Criando data.frame em branco
# pontos[,4:395] <- NA
# names(pontos)[4:395] <- dates
# write.csv(pontos, file = "H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem.csv", row.names = FALSE)

pontos <- read.csv("H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem_1.csv")

#Extrair dados de ndvi para os pontos de campo
CellNumber <- pontos$CellNumber[3001:4000]

pix <- NULL
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = length(CellNumber), style = 3)
for (i in 1:length(CellNumber)) {
  pix <- rbind(pix, as.numeric(r[CellNumber[i] ]))
  setTxtProgressBar(pb, i)
}
close(pb) 
Sys.time() - ST

pontos <- read.csv("H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem_1.csv")
pontos[3001:4000, 4:395] <- pix

write.csv(pontos, file = "H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem_1.csv", row.names = FALSE)
View(pontos)
#######################################################################################
#######################################################################################