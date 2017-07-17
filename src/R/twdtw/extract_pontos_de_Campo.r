####################################################################################
####################################################################################
options(scipen = 999)

#Pacotes e funcoes
library(raster)

#Arquivos
r <- brick('E:/pa_br_mod13q1_ndvi_250_2000_2017.tif')

pontos <- read.csv("H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem_1.csv")

#Extrair dados de ndvi para os pontos de campo
CellNumber <- pontos$CellNumber[10001:11436]

pix <- NULL
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = length(CellNumber), style = 3)
for (i in 1:length(CellNumber)) {
  pix <- rbind(pix, as.numeric(r[CellNumber[i] ]))
  setTxtProgressBar(pb, i)
}
close(pb) 
Sys.time() - ST

pontos[10001:11436, 4:395] <- pix

write.csv(pontos, file = "H:/DATASAN/campo/PontosPastagem_todos/NDVI_PontosPastagem_1.csv", row.names = FALSE)
#######################################################################################
#######################################################################################