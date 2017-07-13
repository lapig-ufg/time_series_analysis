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

setwd('/home/jose/Documentos/LAPIG/time_series_analysis/data/')

r <- brick('/run/user/1000/gvfs/smb-share:server=10.0.0.25,share=dados/PORTAL/time-series-db/pa_br_mod13q1_ndvi_250_2000_2017.tif');
samples = read.csv('bfast/samples.csv');
dates = scan('bfast/timeline', what = 'date')

cellNumber = samples[4,5]

id = samples[4,1]


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
      r[cellNumber])))

###
###
#serie temporal
Yt = bfastts(r.p, dates, type = c("16-day"))
ti <- time(Yt)
St <- stl(Yt, "periodic")$time.series[, "seasonal"]
ti <- time(Yt)
Vt <- Yt - St

###
###
bfit = bfast(Yt,
             h = h,
             season = season,
             max.iter = 1)

plot(bfit, type = c("trend"), ylim = c(-0.3, 1))
breaks_bfast = bfit$output[[1]]$bp.Vt

breaks = bfit$output[[1]]$Vt.bp

length(breaks)
trendCmp = bfit$output[[1]]$Tt
BreaksDate = dates[breaks]

lastBreak = if(!bfit$nobp$Vt) breaks[length(breaks)] else 1
lastBreakDate = as.character(dates[lastBreak])
lastBreakJulianDate = format(lastBreakDate, "%Y%j")

lastSegment = trendCmp[lastBreak:length(trendCmp)]

Segment = lastSegment[1]
slope = (lastSegment[2*floor(length(lastSegment)/3)] - lastSegment[floor(length(lastSegment)/3)])/(2*floor(length(lastSegment)/3) - floor(length(lastSegment)/3))

magnitude = bfit$Magnitude
bfit$MagscellNumber

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