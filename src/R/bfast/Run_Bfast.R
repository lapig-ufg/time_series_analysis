####################################################################################
####################################################################################

#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
source('../../../src/R/utils/MaxMinFilter.r')

#Arquivos
r <- brick('E:/pa_br_mod13q1_ndvi_250_2000_2017.tif');
samples = read.csv('../../../data/bfast/samples.csv')
dates = scan('../../../data/bfast/timeline', what = 'date')

#Pixels para rodar bfast
cellNumber = samples[,5]

#Timeline NDVI
dates <- as.Date(dates)

BfastResult <- NULL

for (pix in 1:length(cellNumber)) {
  
cat('pixel', cellNumber[pix], '\n')
  
#preecher NA e remove outliers
r.p = MaxMinFilter(
  na.interp(
    as.numeric(
      as.vector(
        r[cellNumber[pix] ]))), 3)

ID <- cellNumber[pix]
###
###
#Transformar em serie temporal
Yt = bfastts(r.p, dates, type = c("16-day"))

#Rodar o bfast
bfit = bfast(Yt,h = 0.3, season = 'harmonic', max.iter = 1)

#Extrair posicao, data, numero de breakpoints e magnitude dos breakpoints
PBK = as.numeric(bfit$output[[1]]$Vt.bp) # Posicao dos breakpoints
DBK = ifelse(PBK > 0,
             paste(dates[PBK], collapse = ';'),
             NA)#Datas dos breakpoints
NBK <- ifelse(PBK > 0,
              length(PBK),
              0)# Numero de breakpoints
MAG <- ifelse(PBK > 0,
              paste(round(as.numeric(bfit$Mags[,3]), 3), collapse = ';'),
              NA)#Magnitudes

#Loop para pegar slope e intercept
TREND = bfit$output[[1]]$Tt

INTERCEPT <- NULL
SLOPE <- NULL

for (i in 1:NBK) {

START <- max( 1, PBK[i - 1])
END <- min(length(TREND), PBK[i])

SEG <- TREND[START:END]

LM <- as.numeric(lm(SEG ~ c(1:length(SEG)))$coefficients)  

INTERCEPT[i] <- round(LM[1] , 3)
SLOPE[i] <- round(LM[2] , 3)

}
INT <- paste(INTERCEPT, collapse = ';')
SLO <- paste(SLOPE, collapse = ';')
PBK <- paste(PBK, collapse = ';')

xx <- cbind(ID, NBK, PBK, DBK, MAG, INT, SLO)
length(xx)

BfastResult <- rbind(BfastResult, cbind(ID, NBK, PBK, DBK, MAG, INT, SLO))
BfastResult
}

#write.csv(BfastResult, file = "F:\\DATASAN\\BfastResult\\BfastResult.csv", row.names = FALSE)

#######################################################################################
#######################################################################################