### loads data from github ###

# loads the schools info
schools <- read.csv(file="/home/andrea/Dropbox/code/R/PlayingWithData/data/schools.csv")

# loads the quits info identified by a school id (cod_scuola)
quits <- read.csv(file="/home/andrea/Dropbox/code/R/PlayingWithData/data/quits.csv")

### setup the data for our needs ###

# get only the geo related columns of the schools' info
schools_geo <- data.frame(schools$codice_scuola, schools$cap, schools$LATITUDINE, schools$LONGITUDINE)

# removes the observations that don't have LAT/LONG info
schools_geo <- schools_geo[which(schools$LATITUDINE != "NA"),]

# renames the column of school id to "cod_scuola" for matching the name of the quit dataset
colnames(schools_geo)[1] <- "cod_scuola"

# now merges the two dataset and we have info of schools quits with geographic info
data <- merge(quits, schools_geo, by="cod_scuola")

