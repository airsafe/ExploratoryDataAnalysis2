# Part 4 of Project 2 requires an output of a PNG plot showing the total PM2.5 emission from from 
#   coal combustion-related sources in the US. 

# Unique values in the NEI table are as follows:
# Column 1 is the county [fips] (3263)
# Column 2 is the SCC codes for the source (5,386), 
# Column 3 is the aggregate pollutant (1), 
# Column 4 is the emissions in tons (2,648,767),
# Column 5 the source type (4), and 
# Column 6 is the year (4)
# Objective is total pollutants for each of the four years covered, so must do R function that gets 
#   totals for each unique year.
#
# First, get the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Can use the base function grep to find character string matches.
# From results from running 'grep' on SCC table, can find from SCC codes in NEI are associated with coal.

# What are the relevant coal-related SCC codes? Inspected SCC file to look for key terms.
# Tested all columns of SCC for 'coal' or 'Coal', found in columns 3,4,9, and 10
# for (i in 1:ncol(SCC)){
# if (any(grep("coal",SCC[,i], ignore.case = TRUE))){  
# print(c(any(grep("coal",SCC[,i], ignore.case = TRUE)),"Col",i ))}
# }

# Looked for the rows with 'coal' in columns 3,4,9, and 10
SCC_source_coal3 <- grep("coal",SCC[,3], ignore.case = TRUE) # 239 found
SCC_source_coal4 <- grep("coal",SCC[,4], ignore.case = TRUE) # 99 found
SCC_source_coal9 <- grep("coal",SCC[,9], ignore.case = TRUE) # 181 found
SCC_source_coal10 <- grep("coal",SCC[,10], ignore.case = TRUE) # 126 found
coal_concat <- c(SCC_source_coal3,SCC_source_coal4,SCC_source_coal9,SCC_source_coal10)
# coal_concat has potentially many duplicates length(coal_concat) = 645

# First sort the row numbers, than get rid of duplicates
coal_concat_sorted <- sort(coal_concat)
unique_coal_rows <- unique(coal_concat_sorted) # 251 found among 11,717

# Now get the SCC codes for rows with 'coal' or 'Coal' in columns 3, 4, 9, or 10
# Made SCC_coal_IDs as character to match the type of the SCC column in 
#  NEI data frame (in vector SCC_coal_IDs below)
SCC_coal_IDs <- as.character(SCC[c(unique_coal_rows),1])
  
# Now get the NEI rows matching coal lines in SCC?
# Need all the NEI rows that match the SCC values from coal rows in SCC vector
# There were 190 found in this test loop
# cnt <- 0
# for (i in 1:length(unique_coal_rows)){
#   if( any( NEI[,2]==SCC_coal_IDs[i]  )  ){cnt<-cnt+1}
# }
# cnt

coal_rows <- NULL
for (i in 1:length(unique_coal_rows)){
  if( any( NEI[,2]==SCC_coal_IDs[i]  )  ){
    coal_rows <- rbind(coal_rows, NEI[ NEI[,2]==SCC_coal_IDs[i],])
  }
}

# Running length(unique(coal_rows[,2])) also gives 190 unique values in

# Column 4 has pollutant values, and column 6 the year, so can do a split in combination with sapply 
# on the list created by split(coal_rows[,4],coal_rows[,6] to get a sum by year

coal_sums <- sapply(split(coal_rows[4],coal_rows[,6]),sum)
# Below is the test in RStudio
# barplot(coal_sums/10^6, xlab="Year", ylab="Pollution in millions of tons", col="blue", main="Selected years of U.S. coal-rleated PM2.5 emissions")

# Below is the same plot output to working directory in PNG format
par(mfrow=c(1,1)) # Ensure full sized graphic
png(file = "plot4.png", width = 480, height = 480) # Open PNG device to place output in working directory

barplot(coal_sums/10^6, xlab="Year", ylab="Pollution in millions of tons", col="blue", main="Selected years of U.S. coal-rleated PM2.5 emissions")
dev.off() # Close the PNG device

