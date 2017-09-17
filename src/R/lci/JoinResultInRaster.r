#Merge result of ZonalStatistic
#options(scipen = 999)

library(raster)

###
###
shp <- shapefile('F:\\DATASAN\\shapefile/GridBrasil/gridbrasiliduf/Grid_br_111_km_wgs84_iduf.shp')
Mod <- raster('F:\\DATASAN\\results\\lci_br\\SDDecNorm.tif')

DecSDRaster <- Mod
rm(Mod)

DecSDRaster[] <- NA

###
###
setwd("F:\\DATASAN\\results\\lci_br\\ndec")

LS.F <- Sys.glob("*.csv")

ST <- Sys.time()
for (i in 1:length(LS.F)) {
cat("Merge", LS.F[i], '\n')
STi <- Sys.time()
RESULT <- read.csv(LS.F[i])
DecSDRaster[ RESULT$CellNumber ] <- RESULT$declividade.FUN1
print(Sys.time() - STi)
}
Sys.time() - ST

names(DecSDRaster) <- "SD_Dec"
writeRaster(DecSDRaster, filename = 'F:\\DATASAN\\results\\lci_br\\SDDecNorm_2.tif')

DecSDRaster2 <- DecSDRaster
DecSDRaster2[DecSDRaster2 > 1] <- NA
plot(DecSDRaster2)

#plot(shp, add = TRUE)


dec1 <- raster('F:\\DATASAN\\results\\lci_br\\SDDecNorm.tif')

plot(dec1)

#dec1[ is.na(dec1)] <- 

STdec <- stack(dec1, DecSDRaster2)

f2 = function(x) { 
  ifelse(is.na(x[1]) == 1 , x[2], x[1])
}
  

ST <- Sys.time()
r <- calc(STdec, f2)
Sys.time() - ST

plot(r)

names(r) <- 'SDDeclividade'

writeRaster(r, filename = 'F:\\DATASAN\\results\\lci_br\\SDDecNorm_join12.tif')
