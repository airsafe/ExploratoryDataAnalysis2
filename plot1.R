# Part 1 of Project 2 requires an output of a PNG plot using base plotting system in R that shows
#   the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

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

NEI_sums <- sapply(split(NEI[4],NEI[,6]),sum)

# NEI_sums <- sapply(split(NEI[4],NEI$year),sum) #equivalent

# Tested by doing the total sums for column four, and equaled to the sums from the four years
# Note: sum(NEI_sums)-sum(NEI[,4]) gave -4.470348e-08, but sum(NEI_sums)==sum(NEI[,4]) returns FALSE

# Because the y-axis values (emissions in tons) is in the millions, divided the values by one million (10^6)

# Below is the test in RStudio
# barplot(NEI_sums/10^6, xlab="Year", ylab="Pollution in millions of tons", col="blue", main="Selected years of U.S. PM2.5 emissions")

# Below is the same plot output to working directory in PNG format
par(mfrow=c(1,1)) # Ensure full sized graphic
png(file = "plot1.png", width = 480, height = 480) # Open PNG device to place output in working directory

barplot(NEI_sums/10^6, xlab="Year", ylab="Pollution in millions of tons", col="blue", main="Selected years of U.S. PM2.5 emissions")
dev.off() # Close the PNG device