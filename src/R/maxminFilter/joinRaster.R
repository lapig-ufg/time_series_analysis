ST <- Sys.time()
########################################################################################
########################################################################################
#/data/DADOS01/QUALIDADE_PASTAGEM/OUTPUTR/DATASAN

###
# configuration
###
unixtools::set.tempdir('/hds/dados_work/DATASAN/RTmpFile/')

###
# packages and functions
###
library(raster)
library(parallel)
source('/hds/dados_work/GitHub/time_series_analysis/src/R/maxminFilter/Function_to_filter_ndvi.R')

###
# files
###
# grid 55km brasil
shp <- shapefile('F:\\DATASAN\\shapefile\\GridBrasil/gridbrasil/Grid_br_55_km_wgs84.shp')
 
# list of raster's files
setwd('/hds/dados_work/DATASAN/results/maxminFilter/')
LSF <- Sys.glob("*.tif")

###
# process
###

#write filter ndvi tile
ST <- Sys.time()

tempList <- list()
for (i in 1:length(LSF)){

   tempList[[i]] <- brick(LSF[i])
}

m <- do.call(merge, tempList)

Sys.time() - ST

#Garbage colect (clean memory)
gc(reset = TRUE)

########################################################################################
########################################################################################