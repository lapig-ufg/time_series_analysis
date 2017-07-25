f2 <- function(x) {
  x = as.numeric(x)
  sd((x/(mean(x)))/sd(x))
}


ZonalStatLapig <- function(Mod, shpi, Dec) {
  
  Mod.c <- crop(Mod, shpi)
  
  Dec.c <- crop(Dec, shpi)
  
  Mod.c.r <- projectRaster(Mod.c, Dec.c, method = 'ngb')
  ModDec <- stack(Mod.c.r, Dec.c)
  names(ModDec) <- c('CellNumber', 'declividade')
  
  ModDec.df <- as.data.frame(ModDec[])
  
  DecMod.sd <- summaryBy(declividade ~ CellNumber, data = ModDec.df, FUN = c(f2, mean, sd, length))
  
  PathCsv <- paste0('F:\\DATASAN\\DADOS\\lci\\result\\DecSD\\DeclividadeSD_', shpi$ID+1, '.csv')
  
  write.csv(DecMod.sd, file = PathCsv)
  #return(DecMod.sd)
}