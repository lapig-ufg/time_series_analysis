####################################################################################################
####################################################################################################
#'Claudinei Oliveira-Santos
#'LAPIP - Laboratorio de Processamento de Imagens e Geoprocessamento
#'Doutorando em Ciencias Ambientais - UFG
#'claudineisantosnx@gmail.com

#############################################
#############################################
#Descricao

#'passos para calcular desvio padr?o
#'1) reprojetar as imagens para que tenham a mesma resolu??o
#'2) usar o ncell para colocar um id na imagem modis
#'3) fazer stack e extrair os dados para um data.frame
#'4) usar o summary by ou apply para calcular o desvio padr?o
#'5) usar o reaster ndvi de origem para preencher com desvio padr?o
#'6) calcular o ?ndice
#'
options(scipen = 999)
#############################################
#############################################
#pacotes
library(raster)
library(doBy)
###
###
#arquivos
TRC <- raster('/home/jose/Documentos/LAPIG/Grids_cerrado/veg_TCC_10m.tif')
NDVI_trc <- raster('/home/jose/Documentos/LAPIG/Grids_cerrado/NDVI_TRC_10M_cerrado_reprojetado.tif') 
#usando shp grid_cerrad_11km da pra cortar
gridCerrado11Km = shapefile('/home/jose/Documentos/LAPIG/Grids_cerrado/Grid_cerrado_11km.shp')
NDVI_trc_c <- crop(NDVI_trc, gridCerrado11Km)

trc <- stack(NDVI_trc, TRC)

##
##
PRB <- raster('D:\\temp\\veg_cerrado\\veg_probio_tst.TIF') 
NDVI_prb <- raster('D:\\temp\\PROP_PIXEL\\NDVI_PRB_10M_cerrado_reprojetado.tif') 
prb <- stack(NDVI_prb, PRB)

NDVI_Orig <- raster('D:\\temp\\PROP_PIXEL\\NDVI_TRC_250M_cerrado.tif')

shp <- shapefile('D:\\temp\\veg_cerrado/grid_cerrado_222km_export.shp')
plot(shp)
###
###
#TERRACLASS

c(rowColFromCell(NDVI_Orig, 40109288 ))

ndvi = crop(NDVI_Orig, extent(NDVI_Orig, 4491, 4491, 4608, 4608))
  plot(ndvi)
  
  TRC_c <- crop(TRC, ndvi)
  plot(TRC_c)
  
NDVI_result <- NDVI_Orig
NDVI_result[] <- NA  

ST <- Sys.time() 
pixels <- 1:10#ncell(NDVI_Orig)
Pix_resul <- list()  

  for (i in 1:length(pixels)) {
    cat("pixel", pixels[i], '\n')
    rc = c(rowColFromCell(NDVI_Orig, pixels[i] ))
    
    #Recorta 3x3
    ndvi = crop(NDVI_Orig, extent(NDVI_Orig, rc[1], rc[1], rc[2], rc[2]))
    TRC_c <- crop(TRC, ndvi)
    
    NDVI_result[ pixels[i] ]<- round(sum(as.numeric(TRC_c[], na.rm = TRUE))/ncell(TRC_c) * 100,2)
}
Sys.time() - ST 




################################################################################
################################################################################
