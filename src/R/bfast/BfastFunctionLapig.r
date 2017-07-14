#funcao para rodar bfast e ter o resultado padronizado (um pixel pro linha)
RunBfast <- function(pix, h, season, LM = FALSE) {
library(bfast)
#Objetos que vao receber os resultados
BfastResult = NULL
INTERCEPT <- NULL
SLOPE <- NULL

#Pixel
ID <- as.numeric(pix[1])
pix = as.numeric(pix[-1])

#Transformar em serie temporal
Yt = bfastts(pix, dates, type = c("16-day"))

#Rodar o bfast
bfit = bfast(Yt,h = h, season = season, max.iter = 1)

#Extrair posicao, data, numero de breakpoints e magnitude dos breakpoints
PsoBK = as.numeric(bfit$output[[1]]$Vt.bp) # Posicao dos breakpoints
DBK = ifelse(PsoBK > 0,
             paste(dates[PsoBK], collapse = ';'),
             NA)[1]#Datas dos breakpoints
NBK <- ifelse(PsoBK > 0,
              c(length(PsoBK)),
              0)[1]# Numero de breakpoints
MAG <- ifelse(PsoBK > 0,
              paste(round(as.numeric(bfit$Mags[,3]), 3), collapse = ';'),
              NA)[1]#Magnitudes

#Loop para pegar slope e intercept
TREND = bfit$output[[1]]$Tt

if(LM == TRUE){

for (j in 1:NBK) {

START <- max( 1, PsoBK[j - 1])
END <- min(length(TREND), PsoBK[j])

SEG <- TREND[START:END]

LM <- as.numeric(lm(SEG ~ c(1:length(SEG)))$coefficients)  

INTERCEPT[j] <- round(LM[1] , 3)
SLOPE[j] <- round(LM[2] , 3)

}
INT <- paste(INTERCEPT, collapse = ';')
SLO <- paste(SLOPE, collapse = ';')
PBK <- paste(PsoBK, collapse = ';')

BfastResult <- rbind(BfastResult, c(ID, NBK, PBK, DBK, MAG, INT, SLO))
names(BfastResult) <- c('ID', 'NBK', 'PBK', 'DBK', 'MAG', 'INT', 'SLO')

}else{
PBK <- paste(PsoBK, collapse = ';')
BfastResult <- rbind(BfastResult, c(ID, NBK, PBK, DBK, MAG))
names(BfastResult) <- c('ID', 'NBK', 'PBK', 'DBK', 'MAG')
}
return(BfastResult)
}