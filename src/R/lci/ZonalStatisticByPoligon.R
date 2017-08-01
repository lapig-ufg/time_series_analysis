ZonalStatLapig <- function(rlow, shpi, rhigh, Path, Name) {
# rlow = Raster de menor resolução
# shpi = Shapefile poligono i
# rhigh = raster de maior resolução
# Path = path para salvar o resultado
# Name = nome do arquivo de saida

  rlow.c <- crop(rlow, shpi)
  
  rhigh.c <- crop(rhigh, shpi)
  
  rlow.c.r <- projectRaster(rlow.c, rhigh.c, method = 'ngb')
  RlowRhigh <- stack(rlow.c.r, rhigh.c)
  names(RlowRhigh) <- c('CellNumber', 'declividade')
  rm(rlow.c.r)
  rm(rhigh.c)
  rm(rlow.c)
  
  RlowRhigh.df <- as.data.frame(RlowRhigh[])
  rm(RlowRhigh)
  
  RlowRhigh.sd <- summaryBy(declividade ~ CellNumber, data = RlowRhigh.df, 
    FUN = c(
	  function(x) {
        x = as.numeric(x)
		sd((x/(mean(x)))/sd(x))},
	  mean, sd, length))
  rm(RlowRhigh.df) 
 
  idPol <- paste(shpi[1,]$FID_GRID_B, shpi[1,]$NM_UF, sep = "_")
  PathCsv <- paste0(Path, Name, idPol, '.csv')
  
  write.csv(RlowRhigh.sd, file = PathCsv)
  #return(RlowRhigh.sd)
  rm(RlowRhigh.sd)
  gc(reset = TRUE)
}