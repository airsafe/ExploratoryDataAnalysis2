# Part 3 of Project 2 requires an output of a PNG plot using ggplot2 plotting system in R
#   that shows the total PM2.5 emission fromBaltimore City, Maryland (fips = "24510") by year
#   for the years 1999, 2002, 2005, and 2008. The graphic should compare the pollution from four types
#   of sources indicated by the type variable (point, nonpoint, onroad, nonroad) variable in order
#   to see which of these four sources have seen decreases.

# Unique values in the NEI table are as follows:
# Column 1 is the county [fips] (3263)
# Column 2 is the SCC codes for the source (5,386), 
# Column 3 is the aggregate pollutant (1), 
# Column 4 is the emissions in tons (2,648,767),
# Column 5 the source type (4), and 
# Column 6 is the year (4)
#
# Can load the ggplot2 RStudio package, which allow easy comparison of subsets of a dataset.
# The basic plotting function is qplot where x-axis is years and y-axis cumulative emmissions
# Data will be the part of NEI that is both associated with Baltimore City 
#  where  observations are represented by geoms, or geometric objects, 
#  (in this case, geom_bar for bars), and where there is a statistical transformation (sum).
#  Another variable (column) in NEI can be used as an attribute that can be used to compare subsets of the data
#  In this case the variable 'type' had four categories, and the resulting graph was compared each of 
#  those four variations in a bar graph.


# First step was to get the data
NEI <- readRDS("summarySCC_PM25.rds")


# Next step is to install ggplot2 in RStudio
install.packages("ggplot2")
library(ggplot2)

# Also need SCC <- readRDS("Source_Classification_Code.rds") to map some data names to data codes
# Column 4 has pollutant values, and column 6 the year, so can do a split in combination with sapply 
# on the list created by split(NEI[4],NEI$year to get a sum by year


# Next step is to extract only those rows associated with Baltimore City, MD (fips == "24510")
##  Side note. The city of Baltimore is within Baltimore County, and the residents of the County
##  can be rather touchy if you confuse the two in their presence

NEI_bal_city <- NEI[NEI[,1]=="24510",]

# The following are equivalent
#   NEI_bal_city <- NEI[NEI$fips=="24510",]
#   NEI_bal_city <- NEI[NEI[,1]=="24510",] # Prefer this version because tolerates change in column name

# Can test for equivalence using all(NEI[NEI$fips=="24510",] == NEI[NEI[,1]=="24510",])
# For building the graph, used as reference http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/

# x-axis: NEI_bal_city[,6]
# y-axis: NEI_bal_city[,4]
# Pollutions type:  NEI_bal_city[,5] 

# Test print plot in section below
# ggplot(data=NEI_bal_city, aes(x=NEI_bal_city[,6], y=NEI_bal_city[,4]/10^3)) + 
#   geom_bar(aes(fill=NEI_bal_city[,5]), stat="identity", position=position_dodge()) +
#   scale_fill_manual(values=c("black", "blue","red", "green")) + 
#   labs(title = "Selected years of Baltimore City, MD PM2.5 emissions by type") + labs(fill="Type") +
#   xlab("Year")+ ylab("Pollution in millions of tons") +
#   scale_x_continuous(breaks=c(1999,2002,2005,2008)) 

# Note: If command line is long, leave an operator or open bracket at the end of the line
# But need to do compare for each of the four variations of the 'type' variable (column 5) 
# Variations are "POINT"    "NONPOINT" "ON-ROAD"  "NON-ROAD"

# Below is the same plot output to working directory in PNG format
par(mfrow=c(1,1)) # Ensure full sized graphic
png(file = "plot3.png", width = 480, height = 480) # Open PNG device to place output in working directory
ggplot(data=NEI_bal_city, aes(x=NEI_bal_city[,6], y=NEI_bal_city[,4]/10^3)) + 
  geom_bar(aes(fill=NEI_bal_city[,5]), stat="identity", position=position_dodge()) +
  scale_fill_manual(values=c("black", "blue","red", "green")) + 
  labs(title = "Selected years of Baltimore City, MD PM2.5 emissions by type") + labs(fill="Type") +
  xlab("Year")+ ylab("Pollution in millions of tons") +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) 
dev.off() # Close the PNG device