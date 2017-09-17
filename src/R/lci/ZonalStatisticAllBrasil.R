ZonalStatLapig <- function(x) {
  library(raster)
  pix = as.numeric(x[3])
  rlow = raster("/hds/dados_work/DATASAN/raster/NDVI/CellNUmberNDVIBrasil_brlimite.tif")
  rhigh = raster("/hds/dados_work/DATASAN/raster/LCI/pa_br_landsat_ndvi_median_30_2016_lapig.tif")
  
  rowColExt <- rowColFromCell(rlow, pix)
  rowExt <- rowColExt[1]
  colExt <- rowColExt[2]
  cellExt <- extent(rlow, rowExt, rowExt, colExt, colExt)
  # cropRlow <- crop(rlow, cellExt)
  cropRhigh <- crop(rhigh, cellExt)
  
  cropRhighByPixRlow <- cropRhigh[]/10000

  RESULT <- c(cellNumber = pix,
              MEAN = mean(cropRhighByPixRlow, na.rm = TRUE),
              SD = sd(cropRhighByPixRlow, na.rm = TRUE),
              LENGTH = length(cropRhighByPixRlow))
  
  return(RESULT)
}

