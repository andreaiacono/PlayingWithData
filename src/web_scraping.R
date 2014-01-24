library(XML)

# sets the URL
url <- "http://sdw.ecb.europa.eu/browse.do?node=2120803"

# let the XML library parse the HTMl of the page
parsed <- htmlParse(url)

# reads the HTML table present inside the page, paying attention
# to the data types contained in the HTML table
table <- readHTMLTable(parsed, skip.rows=c(1,3,4,5), colClasses = c(rep("integer", 31) ))

# this web page contains seven HTML tables, but the one that contains the data
# is the fifth
values <- as.data.frame(table[5])

# renames the columns for the period and Italy
colnames(values)[1] <- 'Period'
colnames(values)[19] <- 'Italy'

# now subsets the data: we are interested only in the first and 
# the 19th column (period and Italy info)
ids <- values[c(1,19)]

# Italy has only 25 year of info, so we cut away the others
ids <- as.data.frame(ds[1:25,])

# plots the data
plot(ids, xlab="Year", ylab="Population in thousands", main="Population 1990-2014", pch=19, cex=0.5)

