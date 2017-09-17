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
source('F:\\DATASAN\\Scripts\\time_series_analysis\\src\\R\\bfast\\BfastFunctionLapig.R')

###
###
#Files
dates = scan('../../../data/bfast/timeline', what = 'date')
dates <- as.Date(dates[320:388])

load("F:\\DATASAN\\DADOS\\SiadBfast\\NDVI_Poly_ALL.rdata")
head(PolyNDVI[1:5])

PolyNDVI <- PolyNDVI[,c(1,322:390)]

###
###
#Run Bfast
h = (23)/69 #23 obs/year vs H == 5 years / 396 obs in timeserie
season = "none"

cl <- makeCluster(detectCores() - 1)
ST = Sys.time()
BfastPolyNDVI = data.frame(t(parApply(cl = cl, PolyNDVI[1:50, ], 1, RunBfast, h = h, season = season, dates = dates, LM = TRUE)))
Sys.time() - ST #Time difference of 8.180278 hours
stopCluster(cl)
#Time difference of 49.59249 mins | Time difference of 49.58206 mins
#Time difference of 15.42485 mins (3years)

names(BfastPolyNDVI) <- c('ID', 'NBK', 'PBK', 'DBK', 'MAG', 'INT', 'SLO')
save(BfastPolyNDVI, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastPolyNDVI_3years.rdata")

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
    bfresult2[j,STCOL[i]:(length(LSTR[[j]]) + (STCOL[i] - 1))] <- ifelse(identical(a, LSTR[[j]]),
      NA, LSTR[[j]])
    }
  }
head(bfresult2)
#sapply(bfresult2, class)
write.csv(bfresult2, file = "F:\\DATASAN\\DADOS\\SiadBfast\\result\\BfastResult_cols_3years.csv", row.names = FALSE)


#######################################################################################
#######################################################################################