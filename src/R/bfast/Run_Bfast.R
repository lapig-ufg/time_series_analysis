####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
r <- brick('E:/pa_br_mod13q1_ndvi_250_2000_2017.tif');
samples = read.csv('../../../data/bfast/samples.csv')
ndvi = read.csv('../../../data/bfast/NDVIMod13q1.csv')
dates = scan('../../../data/bfast/timeline', what = 'date')

#Parametros dos bfast
h = 0.16099599
season = "harmonic"

ndvi.2 <- ndvi[,c(2,8:399)]

#Timeline NDVI
dates <- as.Date(dates)

ResultBfastNdvi <- NULL
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = nrow(ndvi.2), style = 3)
for (l in 1:nrow(ndvi.2)) {
  pix <- as.numeric(ndvi.2[l,])
  ResultBfastNdvi <- rbind(ResultBfastNdvi, RunBfast(pix, h, season))
  setTxtProgressBar(pb, l)
}
close(pb) 
Sys.time() - ST

#Time difference of 7.052529 mins
#Time difference of 7.097569 mins

ndvibr <- raster('F:\\DATASAN\\raster\\siad_raster_2016\\pa_br_ndvi_250_2017049_lapig.tif')

shp <- shapefile('F:\\DATASAN\\raster\\siad_raster_2016\\siad_2016_points.shp')

SIAD_2016_centroid <- as.data.frame(shp@coords)
head(SIAD_2016_centroid)
names(SIAD_2016_centroid) <- c('x', 'y')

SIAD_2016_centroid$CellNumber <- cellFromXY(ndvibr, SIAD_2016_centroid[, 1:2] )
write.csv(SIAD_2016_centroid, file = 'F:\\DATASAN\\raster\\siad_raster_2016\\SIAD_2016_Centroind_CellXY.csv', row.names = FALSE)

siad <- raster('F:\\DATASAN\\raster\\siad_raster_2016\\SIAD_2016.tif')
siad.df <- as.data.frame(siad, xy = TRUE)
siad.df.naa <- na.omit(siad.df)

tail(SIAD_2016_ID)

ndvibr <- raster('F:\\DATASAN\\raster\\siad_raster_2016\\pa_br_ndvi_250_2017049_lapig.tif')

SIAD_2016_ID$CellNumber <- cellFromXY(ndvibr, SIAD_2016_ID[,1:2] )

#write.csv(SIAD_2016_ID, file = 'F:\\DATASAN\\raster\\siad_raster_2016\\SIAD_2016_ID_CellXY.csv', row.names = FALSE)



library(parallel)
cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
szmtt = data.frame(t(parApply(cl = cl, ndvi.2, 1, RunBfast, h = h, season = season, LM = TRUE)))
Sys.time() - ST #0.04440017 by pixel (4 x faster)
stopCluster(cl)

SIAD_2016_centroid <- read.csv('F:\\DATASAN\\raster\\siad_raster_2016\\SIAD_2016_Centroind_CellXY.csv')

CellNumber <- SIAD_2016_centroid$CellNumber[1:100]

ndvibr[] <- NA

ndvibr[CellNumber] <- CellNumber

r.1 <- stack(ndvibr,r)

f2 <- function(x) {
  if (!is.na(x[1])) {
    pix <- MaxMinFilter(
      na.interp(
        as.numeric(x[])),3)
    #RunBfast, h = h, season = season, LM = TRUE
return(pix)
    }
}


pix <- NULL
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = length(CellNumber), style = 3)
for (l in 1:length(CellNumber)) {
  pix <- rbind(pix, as.numeric(r[CellNumber[l] ]))
  setTxtProgressBar(pb, l)
}
close(pb) 
Sys.time() - ST


###
###
setwd('H:\\DATASAN\\raster\\NDVI\\BRASIL\\NDVI')

ls.f <- Sys.glob('*.tif')

CellNumber <- SIAD_2016_centroid$CellNumber[1:100]
pix <- data.frame(ID = CellNumber)

ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = length(ls.f), style = 3)
for (i in 1:10) {#length(ls.f)) {

STp <- Sys.time()  
  r <- raster(ls.f[i])
  pix <- cbind(pix, r[CellNumber])
print(Sys.time() - STp)

#  setTxtProgressBar(pb, i)  
}
Sys.time() - ST

#######################################################################################
#######################################################################################




CellNumber <- SIAD_2016_centroid$CellNumber
pix <- data.frame(ID = CellNumber)
ST <- Sys.time()
pb <- txtProgressBar(min = 0, max = length(ls.f), style = 3)
for (i in 1:5) {#length(ls.f)) {
  STp <- Sys.time()  
  #r <- raster(ls.f[i])
  r <- raster(ls.f[i])[]
  r <- r[CellNumber]
  pix <- cbind(pix, ndvi = r[CellNumber])
  print(Sys.time() - STp)
}
Sys.time() - ST


