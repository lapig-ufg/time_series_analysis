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
library(wavelets)
library(parallel)

source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\bfast\\BfastFunctionLapig.r')
dates = scan('../../../data/bfast/timeline', what = 'date')

posDate <- seq(2, 397, 2);length(posDate)
DT <- dates[posDate]
DT <- as.Date(dates)
# # #Arquivos
# load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_Poly_ALL.rdata")
# head(PolyNDVI[1:5])
# 
# PolyNDVI_WVl <- PolyNDVI[,1:2]
# PolyNDVI_WVl[, 3:200] <- ''
# 
# ndvi <- PolyNDVI[,3:398]

###
###
# f2 <- function(x) {
#   pix <- as.numeric(
#     wavelets::dwt(as.numeric(x), filter = "d2", n.levels=2)@V$V1)
#   return(pix)
# }
###
###
# 
# ST <- Sys.time()
# ndviWvl <- t(apply(ndvi, 1, f2))
# Sys.time() - ST #Time difference of 3.077387 mins (101874)
# 
# PolyNDVI_WVl[, 3:200] <- ndviWvl
# save(PolyNDVI_WVl, file = "F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_Poly_ALL_wvl.rdata")
###
###
load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_Poly_ALL_wvl.rdata")
PolyNDVI_WVl <- PolyNDVI_WVl[,-2]
#head(PolyNDVI_WVl[1:5])

###
###
#Run Bfast
h = (23*5)/396 #23 obs/year vs H == 5 years / 396 obs in timeserie
season = "none"

cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
BfastPolyNDVI = as.data.frame(t(parApply(cl = cl, PolyNDVI_WVl, 1, RunBfast, 
                                         h = h, season = season, dates = DT, LM = TRUE)))
Sys.time() - ST #Time difference of 8.180278 hours
stopCluster(cl) #Time difference of 49.59249 mins

names(BfastPolyNDVI) <- c('ID', 'NBK', 'PBK', 'DBK', 'MAG', 'INT', 'SLO')
save(BfastPolyNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastPolyNDVI_wvl.rdata")

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
    bfresult2[j,STCOL[i]:(length(LSTR[[j]]) + (STCOL[i] - 1))] <- LSTR[[j]] #ifelse(identical(a, LSTR[[j]]),
    #                                                                      NA, LSTR[[j]])
  }
}
head(bfresult2, 50)
#sapply(bfresult2, class)
write.csv(bfresult2, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastResult_cols_wvl.csv", row.names = FALSE)


#######################################################################################
#######################################################################################