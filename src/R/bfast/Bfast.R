####################################################################################
####################################################################################
#Author: Oliveira-Santos, claudinei
#
#Script para rodar Bfast para o SIAD
#
####################################################################################
####################################################################################

#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
###
###
#Arquivos
#setwd('/home/jose/Documentos/LAPIG/time_series_analysis/data/')

r <- brick('E:/pa_br_mod13q1_ndvi_250_2000_2017.tif');
samples = read.csv('../../../data/bfast/samples.csv')
dates = scan('../../../data/bfast/timeline', what = 'date')

cellNumber = samples[,5]

id = samples[,1]

#Parametros dos bfast
h = 0.16099599
season = "harmonic"
max.iter = 1
output <- list()
breaks = NULL
hpc = "none"
level = 1.00  #Nível de corte  (Valor de P)
type = "OLS-MOSUM"

###
###

dates <- as.Date(dates)

###
###
r.p = na.interp(
  as.numeric(
    as.vector(
      r[cellNumber[4] ])))

###
###
#Transformar em serie temporal
Yt = bfastts(r.p, dates, type = c("16-day"))

#Rodar o bfast
bfit = bfast(Yt,h = h, season = season, max.iter = 1)
plot(bfit)

###
###
#Extrair posicao, data e numero de breakpoints
Pbk = as.numeric(bfit$output[[1]]$Vt.bp) # Posicao dos breakpoints
Dbp = dates[breaks] #Datas dos breakpoints
NBk <- length(breaks) # Numero de breakpoints

trendCmp = bfit$output[[1]]$Tt

lastBreak = if (!bfit$nobp$Vt) breaks[length(breaks)] else 1
lastBreakDate = as.character(dates[lastBreak])


for(1 i  NBk)
lastSegment = trendCmp[lastBreak:length(trendCmp)]

Segment = lastSegment[1]

slope = as.numeric(lm(lastSegment ~ c(1:length(lastSegment)))$coefficients[2])




magnitude = bfit$Magnitude

break1 = breaks[1]
break2 = breaks[2]

NOBSegmento1 = length(trendCmp[1:break1])
NOBSegmento2 = length(trendCmp[break1+1:break2])
NOBSegmento3 = length(trendCmp[break2+1:length(trendCmp)])

intercept1 = trendCmp[1];
intercept2 = trendCmp[break1+1];
intercept3 = trendCmp[break2+1];


breakDate1 = dates[breaks[1]]
breakDate2 = dates[breaks[2]]




metadata = matrix(c(id,
                    magnitude, 
                    breaks[1], 
                    breaks[2],  
                    dates[breaks[1]],
                    dates[breaks[2]],
                    slope, 
                    NOBSegmento1,
                    NOBSegmento2,
                    NOBSegmento3,
                    intercept1,
                    intercept2,
                    intercept3),ncol=13, byrow=TRUE);
colnames(metadata) = c("id",
                       "magnitude",
                       "firstBreak",
                       "secondBreak",
                       "firstBreakDate",
                       "secondBreakDate",
                       "slope",
                       "NOBSegmento1",
                       "NOBSegmento2",
                       "NOBSegmento3",
                       "intercept1",
                       "intercept2",
                       "intercept3");





#######################################################################################
#######################################################################################