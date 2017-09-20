#sample Code
#Gets netCDF data for lat/long points from Stevens Institute NYHOPS Data
library(ncdf4)

#Connect to netCDF
nyhops.nc <- nc_open("http://colossus.dl.stevens-tech.edu/thredds/dodsC/LISS/Hindcast/all_nb_mon_81.nc")

##To get 'simple', 3D variale (e.g., depth)
#Load depth, lat, and long
depth.nc <- ncvar_get(nyhops.nc, 'depth')
lat.nc <- ncvar_get(nyhops.nc, 'lat')
long.nc <- ncvar_get(nyhops.nc, 'lon')

#Create dataframe
depth.df <- data.frame(lat=as.vector(lat.nc), long=as.vector(long.nc), depth=as.vector(depth.nc))

#Remove NA values
depth.df <- depth.df[!is.na(depth.df$depth),]
#Can then convert to spatial object, export as table, etc.

##Example getting data involving a vertical horizon dimension and a date dimension
#Fetch the temperature data; start is the starting position for x, y, sigma, date; count is how many 
# here, all rows & columns, and one horizon (horizon 3) and date (394)
temp.nc <- ncvar_get(nyhops.nc, 'temp', start=c(1,1,3,394), count=c(147,452,1,1))

#Can Find out how many dimensions and entries:
nyhops.nc$var[['temp']]$varsize
#Output: [1] 147 452  11 394
#147 rows; 452 columns; 11 horizons; 394 dates/times

#Create dataframe w/ lat, long, temp
temp.df <- data.frame(cbind(long=as.vector(long.nc), lat=as.vector(lat.nc), temp=as.vector(temp.nc)))

#remove NA rows for temp
temp.df <- temp.df[!is.na(temp.df$temp),] #Can convert to spatial object, export as table, etc.

##Can plot, just as a non-spatial object for now.
#assign color ramp
rbPal <- colorRampPalette(c('blue',  'red'))

#Adds a column of color values based on the temp values
temp.df$Col <- rbPal(10)[as.numeric(cut(temp.df$temp,breaks = 10))]

plot(temp.df$long, temp.df$lat, col=temp.df$Col)

