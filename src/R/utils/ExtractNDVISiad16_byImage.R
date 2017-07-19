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