####################################################################################################
####################################################################################################
#'Claudinei Oliveira-Santos
#'LAPIP - Laboratorio de Processamento de Imagens e Geoprocessamento
#'Doutorando em Ciencias Ambientais - UFG
#'claudineisantosnx@gmail.com

#############################################
#############################################
#Descricao

options(scipen = 999)
#############################################
#############################################
#pacotes
library(raster)
library(doBy)
###
###
shp <- shapefile('F:\\DATASAN\\shapefile\\GridBrasil\\GRID_BR_111.shp')
r <- raster('H:\\DATASAN\\raster\\NDVI\\TANGURO\\NDVI\\CROP\\TAN_CROP_pa_br_ndvi_250_2017049_lapig.tif')
Mod <- raster('H:\\DATASAN\\raster\\NDVI\\CellNUmberNDVIBrasil.tif')
Dec <- raster('F:\\DATASAN\\raster\\srtm_relevo\\pa_br_srtm_declividade_30_2000_lapig.tif')
Ndvi <- raster('H:\\DATASAN\\raster\\landsat\\2016-1.tif')
###
###
f2 <- function(x) {
  x = as.numeric(x)
  sd((x/(mean(x)))/sd(x))
}

ID <- 1:length(shp)

for (i in 892:901) {#length(shpt)) {
  ST <- Sys.time()
  
  print(shp[ID[i], ]$ID)
  
  Mod.c <- crop(Mod, shp[ID[i], ])
  
  Dec.c <- crop(Dec, shp[ID[i], ])
  
  Mod.c.r <- projectRaster(Mod.c, Dec.c, method = 'ngb')
  ModDec <- stack(Mod.c.r, Dec.c)
  names(ModDec) <- c('CellNumber', 'declividade')
  
  ModDec.df <- as.data.frame(ModDec[])

  DecMod.sd <- summaryBy(declividade ~ CellNumber, data = ModDec.df, FUN = c(f2, mean, sd, length))

   print(dim(DecMod.sd))
   print(ncell(Mod.c))
  
  print(Sys.time() - ST)
#  count = count + 1;
}

################################################################################
################################################################################
