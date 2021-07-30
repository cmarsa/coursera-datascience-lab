# conecting_listing_databases_in_r.r
library(RMySQL)

# connecting to genome database (test)
ucscDb <- dbConnect(MySQL(), user='genome',
                    host='genome-mysql.cse.ucsc.edu')
result <- dbGetQuery(ucscDb, 'SHOW DATABASES;')
result
dbDisconnect(ucscDb)



# connecting to genome database and particular database
hg19 <- dbConnect(MySQL(), user='genome',
                  db='hg19',
                  host='genome-mysql.cse.ucsc.edu')
all_tables <- dbListTables(hg19)
length(all_tables)
all_tables[1:10]

# get dimensions of a specific table
dbListFields(hg19, 'affyU133Plus2')
dbGetQuery(hg19, 'SELECT COUNT(*) from affyU133Plus2')

# read from the table
affyData <- dbReadTable(hg19, 'affyU133Plus2')
head(affyData)

# select a specific subset
query <- dbSendQuery(hg19, 'select * from affyU133Plus2 where misMatches between 1 and 3')
affyMis <- fetch(query)
quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10)
dbClearResult(query)
dim(affyMisSmall)
