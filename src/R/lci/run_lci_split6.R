#Descricao
options(scipen = 999)
#pacotes
library(raster)
library(doBy)
source("H:\\Dropbox (Pessoal)\\carreira\\Lapig\\GitHubLapig\\time_series_analysis\\src\\R\\lci\\ZonalStatisticByPoligon.R")

args = commandArgs(trailingOnly = TRUE)
#
shp <- shapefile('F:\\DATASAN\\shapefile/GridBrasil/gridbrasiliduf/Grid_br_111_km_wgs84_iduf.shp')
Mod <- raster('H:\\DATASAN\\raster\\NDVI\\CellNUmberNDVIBrasil_brlimite.tif')
#Ndvi <- raster('F:\\DATASAN\\raster\\ndvimedian\\2016-1.tif')
Dec <- raster('F:\\DATASAN\\raster\\srtm_relevo\\pa_br_srtm_declividade_30_2000_lapig.tif')
Dec <- raster('W:\\DATASAN\\raster\\declividade\\Nova pasta\\pa_br_srtm_declividade_30_2000_lapig.tif')

#
path <- 'F:\\DATASAN\\results\\lci_br\\declividade\\'
Name <- 'DEC_SD_'
#
shp <- shp[shp$inbrasil == 1, ]
#
for (i in args[1]:args[2]) {
  ST <- Sys.time()
  print(c("executing tile ",i));
  ZonalStatLapig(rlow = Mod, rhigh = Dec, shpi = shp[i,], Path = path, Name = Name)
 #plot(shp[i,], col = 'blue', add = TRUE)
  print( Sys.time() - ST)
}