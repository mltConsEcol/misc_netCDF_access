####This code allows pulling of daily TopoWx data from an OpenDap server, coarsely selecting specific days 
####Opendap Access form at: https://cida.usgs.gov/thredds/dodsC/topowx.html
####for ncdf4 to pull from OpenDap, cannot be run on windows unless specifically compiled for such; 
####see notes in this thread: https://stat.ethz.ch/pipermail/r-help/2015-July/430161.html

#Load necessary packages
library(raster)
library(ncdf4)
#library(spatial.tools)

#Set call to dataset via OpenDap
topowx.url <- "https://cida.usgs.gov/thredds/dodsC/topowx"

rasterOptions(tmpdir="../../media/sf_Treglia_Data/rastertmp")

#"load" data into R via Raster package
tmax <- brick(topowx.url, varname="tmax",  ncdf=TRUE)

#Set bounding box desired for cropping the image
bb1 <- extent(-80,-70,40,45.2)

#To call specific dates by layer index and crop to desired bounding box:
#test1 <- crop(tmax[[1:2]], bb1) 

#To call specific dates based on range using appropriate slot, and crop to desired bounding box:
# system.time(test3 <- crop(tmax[[which(tmax@z$Date < "1996-09-01" & tmax@z$Date > "1996-08-01")]], bb1))
# writeRaster(test3, "../../media/sf_Treglia_Data/test_Aug96.grd")
# 
# system.time(test3 <- crop(tmax[[which(tmax@z$Date == "1996-09-30" & tmax@z$Date > "1996-08-01")]], bb1))
# 
# testx <- tmax[[which(tmax@z$Date < "1950-05-11" & tmax@z$Date > "1950-05-01")]]
# 
# testx <-tmax[[which(tmax@z$Date >= "1950-05-12" & tmax@z$Date < "1950-05-13")]]
# testx
# 
# testx <-tmax[[which(tmax@z$Date >= "1950-05-11" & tmax@z$Date <= "1950-05-11")]]
# 
# tmax <- raster(topowx.url, varname="tmax",  ncdf=TRUE)
# 

datesList <- list()

for(i in (1996:2016)){
  #for (j in c(1996:2016)){
  
  datesList[[paste(i)]] <-  seq(as.Date(paste(i, "-5-1", sep=""), format="%Y-%m-%d"), as.Date(paste(i, "-9-30", sep=""), format="%Y-%m-%d"), "days")
  #}
}

dataDates <- do.call(c, datesList)


datesList1 <- list()
for(i in 1:5){
  datesList1[[i]] <- datesList[[i]]
}

datesList2 <- list()
for(i in (6:10)){
  datesList2[[paste(i)]] <- datesList[[i]]
}

datesList3 <- list()
for(i in (11:15)){
  datesList3[[paste(i)]] <- datesList[[i]]
}

datesList4 <- list()
for(i in (16:21)){
  datesList4[[paste(i)]] <- datesList[[i]]
}

#system.time(test3 <- crop(tmax[[which(tmax@z$Date >= i &  tmax@z$Date < i + 1]], bb1))

datesList4b <- list()
for(i in (19:21)){
  datesList4b[[paste(i)]] <- datesList[[i]]
}

testfun2 <- function(x){
  data1 <- tmax[[which(tmax@z$Date>=x & tmax@z$Date<x+1)]]
  cropped1 <- crop(data1, bb1)
  cropped1 <- projectRaster(cropped1, crs="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs", method='bilinear')
  writeRaster(cropped1, paste("../../media/sf_N_DRIVE/Projects/Regional/ConservationDimensions/People/TempRegulation/TopoWx/tmax", x, ".img", sep=""), overwrite=TRUE)
}

system.time(lapply(datesList4b, sapply, testfun2))