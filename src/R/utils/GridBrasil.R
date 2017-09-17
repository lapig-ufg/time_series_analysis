####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(raster)

#Arquivos

shp <- shapefile('F:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_11.shp')
r <- raster('H:\\DATASAN\\raster\\NDVI\\TANGURO\\NDVI\\CROP\\TAN_CROP_pa_br_ndvi_250_2017049_lapig.tif')
r.cell <- raster('H:\\DATASAN\\raster\\NDVI\\CellNUmberNDVIBrasil.tif')
dec <- raster('F:\\DATASAN\\raster\\srtm_relevo\\pa_br_srtm_declividade_30_2000_lapig.tif')
ndvi <- raster('W:\\DATASAN\\DADOS\\lci\\landsat\\2016-1.tif')

#shpt <- crop(shp, r)


ModCell <- crop(r.cell, shpt[1,])
DecP1 <- crop(dec, shpt[1,])
NdviP1 <- crop(ndvi, shpt[1,])

plot(ModCell)
plot(DecP1, add = TRUE)
plot(NdviP1, add = TRUE)

plot(shpt, add = TRUE)
plot(shpt[1,], add = TRUE, col = 'red')





####################################################################################
####################################################################################