####################################################################################
####################################################################################
#Author: Oliveira-Santos, claudinei
#
#Script para rodar twdtw para o SIAD
#
####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
library(parallel)
library(plyr)
source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\utils/MaxMinFilter.r')
source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\bfast\\BfastFunctionLapig.R')
rasterOptions(tmpdir = "F:\\DATASAN\\temp")

#Arquivos
load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_Siad_2016.rdata")

#Raster
setwd('F:\\DATASAN\\DADOS\\NDVI')
ls.f <- Sys.glob('*.tif')

temp.list <- list()

for (i in 1:length(ls.f)) {
cat(ls.f[i], '\n')  
  temp.list[[i]] <- raster(ls.f[i])
}
#r <- stack(temp.list)

###
CellNumber <- PolyCellsNDVI$CellNumber

ST <- Sys.time() 
for(j in 1:length(temp.list)) {

cat(names(temp.list[[j]]), '\n')

STj <- Sys.time()

  r.v <- temp.list[[j]][]
  
PolyCellsNDVI[,j+2] <- r.v[CellNumber]

print(Sys.time() - STj)
}
Sys.time() - ST #Time difference of 5.961758 hours

save(PolyCellsNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016.rdata") 

####################################################################################
####################################################################################
load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016.rdata") 
# PolyCellsNDVI1mim <- PolyCellsNDVI[1:1000000,]
# save(PolyCellsNDVI1mim, file = "F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016_1mi.rdata") 
# PolyCellsNDVI2mim <- PolyCellsNDVI[1000001:2109964,]
# save(PolyCellsNDVI2mim, file = "F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016_2mi.rdata") 

# PolyCellsNDVIInterp <- PolyCellsNDVI[, 1:2]
# 
 ST = Sys.time()
 PolyCellsNDVIInterp[,3:398] = t(apply(PolyCellsNDVI[, 3:398], 1, na.interp))
 Sys.time() - ST

PolyCellsNDVIList <- split(PolyCellsNDVI, PolyCellsNDVI$ID)
save(PolyCellsNDVIList, file = "F:\\DATASAN\\DADOS\\SiadBfast\\LIST_PolyCellsNDVIList_2016.rdata")


 
###
###
 # f1 <- function(x) {
 #   colMeans(
 #   t(
 #     apply(x, 1, f2)))
 #   }
 # 
 # ##
 f2 <- function(x) {
#   if(!all(is.na(x))){
  source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\utils\\MaxMinFilter.r')
   pix <- MaxMinFilter(
            forecast::na.interp(
             as.numeric(x[3:398])),3)
     return(pix)
#   } else NA
 }
###
###
SPLT <- c(seq(0, 2109964, 300000), 2109964)
cl <- makeCluster(detectCores() - 1)

for(i in 7:(length(SPLT)-1)){
print(c(SPLT[i]+1, SPLT[i+1]))

PolyCellsNDVIInterp <- PolyCellsNDVI[c((SPLT[7]+1):(SPLT[7+1])),]
print(dim(PolyCellsNDVIInterp))

ST = Sys.time()
PolyCellsNDVIInterp[,3:398] = t(parApply(cl = cl, PolyCellsNDVIInterp, 1, f2))
#PolyCellsNDVIInterp[,3:398] = t(apply(PolyCellsNDVIInterp, 1, f2))
print(Sys.time() - ST)

save(PolyCellsNDVIInterp, file = paste0("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_", SPLT[i]+1, ".rdata"))
#rm('PolyCellsNDVIInterp')
}
stopCluster(cl)
####################################################################################
####################################################################################
# load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016.rdata") 
# SPLT <- c(seq(0, 2109964, 300000), 2109964)
# #cl <- makeCluster(detectCores() - 1)
# class(PolyCellsNDVI)
# 
# for(i in 1:(length(SPLT)-1)){
#   print(c(SPLT[i]+1, SPLT[i+1]))
#   ST = Sys.time()
#   PolyCellsNDVI_split <- as.data.frame(PolyCellsNDVI[c((SPLT[i]+1):(SPLT[i+1])),])
#   print(dim(PolyCellsNDVI_split))
#   
#   (SPLT[i]+1):(SPLT[i+1])
#   
#   # PolyCellsNDVIInterp[,3:398] = t(parApply(cl = cl, PolyCellsNDVIInterp, 1, f2))
#   # #PolyCellsNDVIInterp[,3:398] = t(apply(PolyCellsNDVIInterp, 1, f2))
#   # print(Sys.time() - ST)
#   
#   
#   # save(PolyCellsNDVI_split, file = paste0("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_PolyCellNumber_2016_split_", SPLT[i]+1, ".rdata"))
#   rm('PolyCellsNDVI_split')
#   print(Sys.time() - ST)
# }
# #stopCluster(cl)

###
###
#Deletar
f1 <- function(x) {all(is.na(x))}
PolyCellsNDVIInterp$ALLNA <- apply(PolyCellsNDVIInterp[,3:398], 1, f1)
table(PolyCellsNDVIInterp$ALLNA)
PolyCellsNDVIInterp <- PolyCellsNDVIInterp[PolyCellsNDVIInterp$ALLNA == FALSE,]
###
###
