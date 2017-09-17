



require(rgdal)

# The input file geodatabase
fgdb <- "F:\\DATASAN/ArcGisDB/UtilsGribBR.gdb"

# List all feature classes in a file geodatabase
subset(ogrDrivers(), grepl("GDB", name))
fc_list <- ogrListLayers(fgdb)
print(fc_list)

# Read the feature class
fc <- readOGR(dsn = fgdb, layer = "Grid_br_11_km_wgs84")

# Determine the FC extent, projection, and attribute information
summary(fc)

# View the feature class
plot(fc)
plot(fc[fc$inbrasil == 1,], add = TRUE, col = 'red')
