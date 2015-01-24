# Part 2 of Project 2 requires an output of a PNG plot using base plotting system in R
#   that shows the total PM2.5 emission from Baltimore City, Maryland (fips = "24510") for 
#   each of the years 1999, 2002, 2005, and 2008.

# Unique values in the NEI table are as follows:
# Column 1 is the county [fips] (3263)
# Column 2 is the SCC codes for the source (5,386), 
# Column 3 is the aggregate pollutant (1), 
# Column 4 is the emissions in tons (2,648,767),
# Column 5 the source type (4), and 
# Column 6 is the year (4)
#
# Objective is total pollutants for each of the four years covered, so must do R function that gets 
#   totals for each unique year.

# First step was to get the data

NEI <- readRDS("summarySCC_PM25.rds")

# Column 4 has pollutant values, and column 6 the year, so can do a split in combination with sapply 
# on the list created by split(NEI[4],NEI$year to get a sum by year

# Next step is to extract only those rows associated with Baltimore City, MD (fips == "24510")
##  Side note. The city of Baltimore is within Baltimore County, and the residents of the County
##  can be rather touchy if you confuse the two in their presence

# The following are equivalent
#   NEI_bal_city <- NEI[NEI$fips=="24510",]
#   NEI_bal_city <- NEI[NEI[,1]=="24510",] # Prefer this version because tolerates change in column name

# Can test for equivalence using all(NEI[NEI$fips=="24510",] == NEI[NEI[,1]=="24510",])

NEI_bal_city <- NEI[NEI[,1]=="24510",]

# Column 4 has pollutant values, and column 6 the year, so can do a split in combination with sapply 
# on the list created by split(NEI_bal_city[4],NEI_bal_city$year to get a sum by year

NEI_bal_city_sums <- sapply(split(NEI_bal_city[4],NEI_bal_city[,6]),sum)

# NEI_bal_city_sums <- sapply(split(NEI_bal_city[4],NEI_bal_city$year),sum) # Equivalent

# Tested by doing the total sums for column four, and equaled to the sums from the four years
# Note: sum(NEI_bal_city_sums)-sum(NEI_bal_city[,4]) gave -1.818989e-12, but sum(NEI_bal_city_sums)==sum(NEI_bal_city[,4]) returns FALSE

# Because the y-axis values (emissions in tons) is in the millions, divided the values by one million (10^6)

# Below is the test in RStudio
# barplot(NEI_bal_city_sums/10^3, xlab="Year", ylab="Pollution in thousands of tons", col="blue", main="Selected years of Baltimore City, MD PM2.5 emissions")

# Below is the same plot output to working directory in PNG format
par(mfrow=c(1,1)) # Ensure full sized graphic
png(file = "plot2.png", width = 480, height = 480) # Open PNG device to place output in working directory

barplot(NEI_bal_city_sums/10^3, xlab="Year", ylab="Pollution in thousands of tons", col="blue", main="Selected years of Baltimore City, MD PM2.5 emissions")
dev.off() # Close the PNG device