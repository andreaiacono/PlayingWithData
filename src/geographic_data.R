require(RgoogleMaps)

### loads data ###

// sets current directory
setwd("/home/andrea/Programming/code/R/PlayingWithData/")

# loads the schools info
schools <- read.csv(file="data/schools.csv")

# loads the abandonments info identified by a school id (cod_scuola)
abandonments <- read.csv(file="data/quits.csv")

### setup the data for our needs ###

# removes the observations that don't have LAT/LONG info
schools <- schools[which(schools$LATITUDINE != "NA",),]

# get only the geo related columns of the schools' info
schools_geo <- data.frame(schools$codice_scuola, schools$LATITUDINE, schools$LONGITUDINE)

# removes the observations that don't have the abandomnent rate
abandonments <- abandonments[which(abandonments$scuola != "NA"),]

# renames the column of school id to "cod_scuola" for matching the name of the quit dataset
colnames(schools_geo)[1] <- "cod_scuola"

# now merges the two dataset and we have info of schools quits with geographic info
data <- merge(abandonments, schools_geo, by="cod_scuola")

# we want to show only the schools where the abandonment rate is greater than 0
data <- data[which(data$scuola>0),]

# sorts the data according to the abandonment rate
# (so that the higher values will overwrite the lower)
#data <- data[order(data$scuola, decreasing=FALSE), ]

### plot's setup ###

# setup of latitude and longitude centered on Italy
lat_c<-42.1
lon_c<-12.5

# get a box of coordinates
rectangle<-qbbox(lat = c(lat_c[1]+5, lat_c[1]-5), lon = c(lon_c[1]+5, lon_c[1]-5))

# retrieves a map from googlemaps
map<-GetMap.bbox(rectangle$lonR, rectangle$latR)

### plots the data  ###

# creates a colormap 
#cls <- densCols(data$scuola, colramp= function(n){BTC(n,beg=1,end=150)})

# plots on the maps downloaded from google the data 
PlotOnStaticMap(MyMap=map, lat=data$schools.LATITUDINE, lon=data$schools.LONGITUDINE, TrueProj=TRUE, cex=data$scuola/15, pch=1, col="blue")

# draws the legend on the plot
legend(x=120, y=300, title="Abandonment rate", x.intersp=2, y.intersp=c(1.1,1.1,1.1,1.1,1.15,1.2),legend=c("< 1%", "1% - 5%", "5% - 10%", "10% - 20%", "20% - 50%", "> 50%"), col="blue",pch=1,cex=0.8, pt.cex=c(1/15, 5/15, 10/15, 20/15, 50/15, 70/15)) 