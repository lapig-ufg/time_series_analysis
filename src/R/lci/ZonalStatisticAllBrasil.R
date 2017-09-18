ZonalStatLapig <- function(pix, rlow, rhigh) {
  library(raster)
  pix = pix
  rlow = rlow
  rhigh = rhigh
  
  rowColExt <- rowColFromCell(rlow, pix)
  # rowExt <- rowColExt[1]
  # colExt <- rowColExt[2]
  # cellExt <- extent(rlow, rowExt, rowExt, colExt, colExt)
  # # cropRlow <- crop(rlow, cellExt)
  # cropRhigh <- crop(rhigh, cellExt)
  rowColExt <- rowColFromCell(rlow, pix)
  cropRhighByPixRlow <- extract(rhigh, extent(rlow, rowColExt[1], rowColExt[1], rowColExt[2], rowColExt[2]))/10000
  
  # cropRhighByPixRlow <- cropRhigh[]/10000

  RESULT <- c(cellNumber = pix,
              MEAN = mean(cropRhighByPixRlow, na.rm = TRUE),
              SD = sd(cropRhighByPixRlow, na.rm = TRUE),
              LENGTH = length(cropRhighByPixRlow))
  
  return(RESULT)
}

