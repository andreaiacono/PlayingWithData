library(maptools) # for reading shapefiles
library(grid) # for adding a title to the legend of the plot

### loads data ###

# sets current directory
setwd("/home/andrea/Programming/code/R/PlayingWithData/")

# reads the shapefile of administrative regions
regions <- readShapeSpatial("data/prov2011_g.shp")

# reads the unemployment data
unemployment <- read.csv(file="data/unemployment.csv")

# selects only the data we are interested (the name and the year 2012)
unemployment <- subset(unemployment, select=c(1,10))

# adds the unemployment value to the shapefile
regions@data = data.frame(regions@data, unemployment[match(regions@data$NOME_PRO, unemployment$NOME_PRO),])

# plots it
spplot(regions, "Year.2012", col.regions=gray.colors(32, 0.9, 0.2), main="Unemployment in 2012")

# adds a title to the legend
grid.text("Number of unemployed people in thousands", x=unit(0.95, "npc"), y=unit(0.50, "npc"), rot=90,  gp = gpar(fontsize = 12))

# now we want the rate of unemployment instead of absolute number, so we load the population number for every region for having a rate

# loads data from CSV
population <- read.csv(file="data/population_per_region.csv")

# leaves only the three columns we're interested in (name, total_males, total_females)
population <- subset(population, select=c(2,8,13))

# adds a "Total" column to the dataset with the sum of total_males and total_females
population$Total <- population$Totale_Maschi + population$Totale_Femmine

# capitalize the names of the regions
population$Descrizione_Provincia <- toupper(population$Descrizione_Provincia)

# now we group by "Descrizione_Provincia" and sum the "Total" column
pop <- as.data.frame(aggregate(population$Total, by=list(population$Descrizione_Provincia), sum))

# rename the columns
colnames(pop)[1] <- "Descrizione_Provincia"
colnames(pop)[2] <- "Total"

# computes the number of unemployed 
pop$unemployed <- unemp_data$Year.2012[match(pop$Descrizione_Provincia, unemp_data$NOME_PRO)]*1000

# computes the rate of unemployed people related to total population
pop$rate <- pop$unemployed / pop$Total * 100

# updates the shapefile with these new data
regions@data = data.frame(regions@data, pop[match(regions@data$NOME_PRO, pop$Descrizione_Provincia),])

# and plots it
cols <- gray.colors(32, 0.9, 0.2)
spplot(regions, "rate", col.regions=cols, main="Unemployment in 2012")
grid.text("% of unemployed population", x=unit(0.95, "npc"), y=unit(0.50, "npc"), rot=90,  gp = gpar(fontsize = 14))
