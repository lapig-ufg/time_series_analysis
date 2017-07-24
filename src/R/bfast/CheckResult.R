####################################################################################
####################################################################################
options(scipen = 999)
#Pacotes e funcoes
library(bfast)
library(raster)
library(forecast)
library(plyr)
source('../../../src/R/utils/MaxMinFilter.r')
source('BfastFunctionLapig.R')

#Arquivos
# siadbf <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols.csv")
# siadbf_lp <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols_lastparte.csv")
# 
# siadbf <- rbind(siadbf, siadbf_lp)
# 
# write.csv(siadbf, file = "H:\\DATASAN\\siadbfastresult\\BfastResult_cols_ALL.csv", row.names = FALSE)

siadbf <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols_ALL.csv")
siadbf <- read.csv("H:\\DATASAN\\siadbfastresult\\BfastResult_cols_wvl.csv")
dim(siadbf)

siadbf$GAP <- c(siadbf$ID[2:101875] -siadbf$ID[1:101874])

head(siadbf)

table(siadbf$GAP)
table(siadbf$NBK)

summary(siadbf$MAG_1)
table( siadbf$MAG_1 > 0 )
table( siadbf$MAG_2 > 0 )
table( siadbf$MAG_3 > 0 )
table( siadbf$MAG_4 > 0 )
table( siadbf$MAG_5 > 0 )

#######################################################################################
#######################################################################################