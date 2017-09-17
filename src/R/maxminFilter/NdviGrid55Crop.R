ST <- Sys.time()
########################################################################################
########################################################################################
#/data/DADOS01/QUALIDADE_PASTAGEM/OUTPUTR/DATASAN

library(raster)
library(parallel)

source('F:\\DATASAN\\Scripts\\ndvifilter/Function_to_filter_ndvi.R')
rasterOptions(tmpdir = 'F:\\DATASAN\\temp\\')
###
###
#Shape with tiles to process
shp <- shapefile('F:\\DATASAN\\shapefile\\GridBrasil/gridbrasil/Grid_br_55_km_wgs84.shp')
 
#list of raster's files
setwd('F:\\DATASAN\\DADOS\\NDVI\\')
LSF <- Sys.glob("*.tif")

###
###
beginCluster(7)
for (s in 1:length(shp)) {
cat('Processing tile ', s, '\n')

STi <- Sys.time()

#Grid tile to crop raster
shpSub <- shp[s, ]

#Crop and stack raster tile
STcrop <- Sys.time()
RCropStack <- stack(
  sapply(LSF, FUN = function(x){
    crop(
      raster(x),
      shpSub)
    }))
print('time to crop')
print(Sys.time() - STcrop)

#write original ndvi tile
STwr <- Sys.time()
pathWriteorig <- "F:\\DATASAN\\results\\ndvifilter/ndviGrid55Crop/"
nameWriteorig <- paste0('NDVI_Grid_55km_orig_tile_', s, "_ID_", shpSub$ID , ".tif")
writeRaster(RCropStack, filename = paste0(pathWriteorig, nameWriteorig), overwrite = TRUE)

print('time to write origNDVI')
print(Sys.time() - STwr)

rm(pathWriteorig)
rm(nameWriteorig)

#Filter ndvi with maxmin and polinomio
STfilt <- Sys.time()
#RStackFilt <- calc(RCropStack, fun = FILTERNDVIPOLY)
RStackFilt <- clusterR(RCropStack, calc, args = list(fun = FILTERNDVIPOLY))
names(RStackFilt) <- c(names(RCropStack), 'NaCount')

print('time to filter NDVI')
print(Sys.time() - STfilt)

rm(RCropStack)

#write filter ndvi tile
STwrF <- Sys.time()
pathWritefilt <- "F:\\DATASAN\\results\\ndvifilter\\ndviGrid55Filter/"
nameWritefilt <- paste0('NDVI_Grid_55km_filt_tile_', s, "_ID_", shpSub$ID , ".tif")
writeRaster(RStackFilt, filename = paste0(pathWritefilt, nameWritefilt), overwrite = TRUE)

print('time to write filtNDVI')
print(Sys.time() - STwrF)

rm(RStackFilt)
rm(pathWritefilt)
rm(nameWritefilt)

#Garbage colect (clean memory)
gc(reset = TRUE)

#cicle's time
print('time to execute tile')
print(Sys.time() - STi)
}
endCluster()

print(Sys.time() - ST)
########################################################################################
########################################################################################