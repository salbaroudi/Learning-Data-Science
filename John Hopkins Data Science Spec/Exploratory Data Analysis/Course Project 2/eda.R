source("./loader.R", echo=TRUE)

#------------------
#Support Functions:

#Signature: Integer -> Character
#Function assumes SCC dataframe is in parent frame. Prints a formatted record for spot analysis.
formatrecord <- function(row) {
  finalStr <- paste("For Row: ", as.character(row), ":\n", sep="")  
  finalStr <- paste(finalStr, SCC$Data.Category[row],",\n", SCC$Short.Name[row], ",\n", sep="") 
  finalStr <- paste(finalStr, SCC$EI.Sector[row], ",\n", SCC$Option.Group[row], ",\n", sep="")
  finalStr <- paste(finalStr, SCC$Option.Set[row], ",\n", SCC$SCC.Level.One[row], ",\n", sep="")
  finalStr <- paste(finalStr, SCC$SCC.Level.Two[row], ",\n", SCC$SCC.Level.Three[row], ",\n", sep="")
  finalStr <- paste(finalStr, SCC$SCC.Level.Four[row], ",\n", sep="")
  cat(finalStr)  
} 

#Basic Exploration -----------------------
#Summary of the Data Frames:
#For NEI, the data types seem appropriate (no transforms needed).
str(NEI)
str(SCC)

#What are the Column Names? 
names(NEI)
names(SCC)

#What years do we have data for? 
table(NEI$year)

#How does NEI relate to SCC? NEI has a SCC column that acts as a primary
#key for unique records in SCC. 

#PROOF of unique records is verified with the following test:
dim(SCC)[1] == length(unique(SCC$SCC))

#THEN: the reason for this particular data structuring is to avoid a large data frame
#filled with long, redundant entries. 

#Note that one col of NEI is completely redundant (all the same).
pollutants <- unique(NEI$Pollutant)

#For SCC, we have a lot of columns that are levelled factors. Some of these are not typed 
#correctly, such as: Revised_Date, Created_Date, etc. 

#Question 4 ----------------------------------

#For Question 4, we need to get the emissions for all sources of coal across the US. However,
#when you grep for "coal" across the SCC table, you get many different matches. Some of them
#are incidental like "Charcoal" or "Coal Transport - Rail". These cases don't involve coal
#being combusted. So we have to narrow down our catagories, and find the right
#set of SCC records in order to filter on for our NEI dataset...here we go.

#Where does the word "coal" appear? Grep it.
coalIndex <- with(SCC, grep("coal", Short.Name ,ignore.case=TRUE))
coalIndex2 <- with(SCC, grep("coal", EI.Sector ,ignore.case=TRUE))

#First, lets output each record column to a data frame, and "View" it using Rstudio
View(SCC$Short.Name[coalIndex])
View(SCC$EI.Sector[coalIndex2])

#There are a lot of exceptions in the Short.Name catagory.
#What EI.Sector names do the exceptions have? It might be that we can just use EI.Sector
#to quickly filter what we want.

#Non-Related entries that have COAL in the name.
coalBedIndex <- with(SCC, grep("Coal Bed Methane NG", Short.Name ,ignore.case=TRUE))
#EI.SECTORs:Industrial Process - Oil and Gas Production
View(SCC$EI.Sector[coalBedIndex])

charcoalIndex <- with(SCC, grep("Charcoal", Short.Name ,ignore.case=TRUE))
#EI.SECTORs: Misc. Non Industrial, Industrial Processes - Chemical Manufacture, Storage and Transfer.
View(SCC$EI.Sector[charcoalIndex])

bulkIndex <- with(SCC, grep("Bulk Materials Transport", Short.Name ,ignore.case=TRUE))
#EI.SECTOR: #Industrial Process - Storage and Transfer
View(SCC$EI.Sector[bulkIndex])

miningIndex <- with(SCC, grep("Coal Mining", Short.Name ,ignore.case=TRUE))
#EI.SECTOR: #Industrial Process - Mining
View(SCC$EI.Sector[miningIndex])

conveyIndex <- with(SCC, grep("Coal Conveying", Short.Name ,ignore.case=TRUE))
#EI.SECTOR:	Industrial Processes - Storage and Transfer
View(SCC$EI.Sector[conveyIndex])

#ANDed Short Names: "Coke & Coal-Fired..."

cokeIndex <- with(SCC, grep("Coke & Coal", Short.Name ,ignore.case=TRUE))
#EI.SECTOR:	Industrial Processes - Ferrous Metals
View(SCC$EI.Sector[cokeIndex])

oilIndex <- with(SCC, grep("Coal & Oil", Short.Name ,ignore.case=TRUE))
#EI.SECTOR:	Industrial Processes - Ferrous Metals
View(SCC$EI.Sector[oilIndex])

#So none of our Exceptions have EI.Sector names that indicate coal combustion.

#For completeness, we need to do the following: What is the range of EI.Sectors that we get
#from our Short.Name list?

rangeNames <- unique(SCC$EI.Sector[coalIndex])
#Some catagories can be excluded, like Ferrous Metals or Transport. Others cannot easily,
#like Marine Vessals - some vessals burn coal, others are diesel/nuclear. So I can't use
#the Marine Vessal EI catagory as a "quick" way of burning coal sources. 

#To judge if a catagory is worthy, I just have to look at every Short.Name and EI.Sector Pair...
compareDF <- data.frame(SCC$SCC[coalIndex], SCC$Short.Name[coalIndex], SCC$EI.Sector[coalIndex], stringsAsFactors = FALSE)
View(compareDF) #from this, I manually compile ranges of valid coalIndex entries: those that indicate
#direct combustion of coal!

#So These are our SCCKeys that we need to search for, in the NEI list!
SCCKeys <- compareDF[c(1:96,108:109, 117, 126:129, 146:148, 199:202, 229:235),1]

#I should have spent some time looking at the Level.One....Level.Four columns. It might have 
#been faster, but the task is already done.