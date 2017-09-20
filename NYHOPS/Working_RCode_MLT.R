library(ncdf4)
library(raster)

nyhops.nc <- nc_open("http://colossus.dl.stevens-tech.edu/thredds/dodsC/LISS/Hindcast/all_nb_mon_81.nc")
print(nyhops.nc)

nyhops.url <- "http://colossus.dl.stevens-tech.edu/thredds/dodsC/LISS/Hindcast/all_nb_mon_81.nc"


depth <- raster(nyhops.url, varname="depth", lvar=1, level=1, stopIfNotEqualSpaced=FALSE) #Forcing it to read layer despite unequal spacing of coords
plot(depth) #Plot looks distorted, as expected given irregular grid spacing.



long <- as.vector(nyhops.nc$var[['lon']][[16]][[1]]$vals)
lat <- as.vector(nyhops.nc$var[['lat']][[16]][[2]]$vals)
depth <- as.vector(nyhops.nc$var[['depth']][[16]][[3]]$vals)
head(depth)
depth


nyhops.nc$var
nyhops.nc$depth



#Things really work here
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

#write.csv(depth.df, '../../media/sf_Treglia_Data/depthtest.csv', row.names=FALSE)

help(ncvar_get)

##Example getting data involving a vertical horizon dimension and a date dimension
#Fetch the temperature; start is the starting position for x, y, sigma, date; count is how many - here, all rows & columns, and one horizon (horizon 3) and date (394)
temp.nc <- ncvar_get(nyhops.nc, 'temp', start=c(1,1,3,394), count=c(147,452,1,1))

temp.df <- data.frame(cbind(long=as.vector(long.nc), lat=as.vector(lat.nc), temp=as.vector(temp.nc)))

temp.df <- temp.df[!is.na(temp.df$temp),]
#assign color ramp
rbPal <- colorRampPalette(c('blue',  'red'))
#This adds a column of color values based on the temp values
temp.df$Col <- rbPal(10)[as.numeric(cut(temp.df$temp,breaks = 10))]

plot(temp.df$long, temp.df$lat, col=temp.df$Col)



longvert.nc <- ncvar_get(nyhops.nc, 'lon_vertices')
latvert.nc <- ncvar_get(nyhops.nc, 'lat_vertices')

longvert.nc[1:4,20,20]

head(longvert.nc)

dim(longvert.nc)




system.time(nyhops.nc2 <- nc_open("http://colossus.dl.stevens-tech.edu/thredds/dodsC/LISS/Hindcast/all_nb_mon_81.nc", readunlim=FALSE))
names(nyhops.nc$var)
temper <- nyhops.nc$var[['temp']]
varsize <- temper$varsize
ndims <- temper$ndims
nt <- varsize[ndims]
ndims
nt
varsize

nyhops.nc$var[['temp']]$varsize


#This throws error
for( i in 1:nt ) {
  # Initialize start and count to read one timestep of the variable.
  start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
  start[ndims] <- i	# change to start=(1,1,1,...,i) to read timestep i
  count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
  count[ndims] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
  data3 <- ncvar_get( nyhops.nc, temper, start=start, count=count )
  
  # Now read in the value of the timelike dimension
  timeval <- ncvar_get( nyhops.nc, temper$dim[[ndims]]$name, start=i, count=1 )
  
  print(paste("Data for variable",temper$name,"at timestep",i,
              " (time value=",timeval,temper$dim[[ndims]]$units,"):"))
  print(data3)
}



