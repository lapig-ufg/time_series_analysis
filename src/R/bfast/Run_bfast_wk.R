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
#d <- gUnaryUnion(mu, id = mu@data$ANODEREFER)
library(bfast)
library(doBy)
source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\bfast\\BfastFunctionLapig.R')
dates = scan('../../../data/bfast/timeline', what = 'date')

# #Arquivos
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_1.rdata")
# PolyCellsNDVI <- PolyCellsNDVIInterp
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_300001.rdata")
# PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_600001.rdata")
# PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_900001.rdata")
# PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_1200001.rdata")
# PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)
# load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_1500001.rdata")
# PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)

 # load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_1_1800000.rdata")
 # dim(PolyCellsNDVI)
 # length(unique(PolyCellsNDVI$ID))
 # 
 # load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_1800001.rdata")
 # dim(PolyCellsNDVIInterp)
 # PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp[,-399])
 # load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_2100001.rdata")
 # dim(PolyCellsNDVIInterp)
 # PolyCellsNDVI <- rbind(PolyCellsNDVI, PolyCellsNDVIInterp)
 # 
# save(PolyCellsNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_PolyCellNumber_2016_MaxMinFILTER_ALL.rdata")

ST = Sys.time()
PolyNDVI <- summaryBy(.~ID, data = PolyCellsNDVI, FUN = c(mean))
save(PolyNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_Poly_ALL.rdata")
print(Sys.time() - ST) #Time difference of 22.64509 mins

#load("F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_Poly_ALL.rdata")
head(PolyNDVI[1:5])
PolyNDVI <- PolyNDVI[,-2]
head(PolyNDVI[1:5])


PolyNDVI2 <- PolyNDVI[PolyNDVI$ID > 81462, ]
dim(PolyNDVI2)
length(unique(PolyNDVI2$ID))
save(PolyNDVI2, file = "F:\\DATASAN\\DADOS\\SiadBfast\\MaxMin\\NDVI_Poly_Lastnona.rdata")
###
###
#Run Bfast
h = 0.16099599
season = "harmonic"

library(parallel)
cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
BfastPolyNDVI = data.frame(t(parApply(cl = cl, PolyNDVI2, 1, RunBfast, h = h, season = season, LM = TRUE)))
Sys.time() - ST #Time difference of 8.180278 hours
stopCluster(cl)

names(BfastPolyNDVI) <- c('ID', 'NBK', 'PBK', 'DBK', 'MAG', 'INT', 'SLO')
save(BfastPolyNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastPolyNDVI_last_parte.rdata")

#######################################################################################
#######################################################################################
#Bfast Output
bfresult <- as.data.frame(BfastPolyNDVI)

MAXBK <- max(as.numeric(bfresult$NBK))
NCOL <- (MAXBK * 5) + 2
STCOL <- seq(3, NCOL, MAXBK)

NAMESCOL <- c(paste0(rep('PBK_',MAXBK),1:MAXBK), 
              paste0(rep('DBK_',MAXBK),1:MAXBK), 
              paste0(rep('MAG_',MAXBK),1:MAXBK), 
              paste0(rep('INT_',MAXBK),1:MAXBK), 
              paste0(rep('SLO_',MAXBK),1:MAXBK))

bfresult2 <- bfresult[,1:2]

bfresult2[ ,3:NCOL] <- ""
names(bfresult2)[3:NCOL] <- NAMESCOL

VAR <- names(bfresult)[-c(1:2)]

for (i in 1:length(VAR)) {
  
  LSTR <- strsplit(as.character(bfresult[, VAR[i]]), ";")
  
  for (j in 1:nrow(bfresult2)) {
    bfresult2[j,STCOL[i]:(length(LSTR[[j]]) + (STCOL[i] - 1))] <- LSTR[[j]]
  }
}

#sapply(bfresult2, class)
write.csv(bfresult2, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastResult_cols_lastparte.csv", row.names = FALSE)


#######################################################################################
#######################################################################################