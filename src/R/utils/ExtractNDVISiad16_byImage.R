####################################################################################
####################################################################################
#Author: Oliveira-Santos, claudinei
#
#Script para rodar twdtw para o SIAD
#
####################################################################################
####################################################################################
#Pacotes e funcoes
library(raster)

#Arquivos
load("F:\\DATASAN\\raster\\siad_raster_2016\\CellNumberPolSiad.rdata")

###
###
PolNumber <- CellNumberPolSiad

#Function to extract data
ST <- Sys.time()
PolyCells <- NULL
for (i in 1:length(PolNumber)) {
PolyCells <- rbind(PolyCells,
                   cbind(ID = i, CellNumber = PolNumber[[i]]))
}
dim(PolyCells)
Sys.time() - ST

PolyCells <- as.data.frame(PolyCells)

save(PolyCells, file = "F:\\DATASAN\\raster\\siad_raster_2016\\PolyCellNumber_Siad_2016.rdata")

raster()

####################################################################################
####################################################################################
sum(c(34.27175,
  42.20141,
  54.06041,
  56.43271,
  55.30863,
  54.4146,
  53.82098,
  54.01865,
  54.41362,
  52.99376,
  55.13992,
  56.03075,
  54.64226,
  75.5049,
  67.08228,
  59.60746,
  54.51702,
  55.36523,
  52.75703))/60