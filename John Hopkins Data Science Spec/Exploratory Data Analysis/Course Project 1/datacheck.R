#This script is used to examine our data. I want to load it in, check for NAs and anomolies, etc.
#This is to avoid problems with the graphing later.
dataLoc <- "household_power_consumption/household_power_consumption.txt";
hpcFullDF <- read.csv(dataLoc, sep=";", stringsAsFactors = FALSE);

library(pryr)
#150mb! Why? Numeric elements take up 8 bytes. We have 7 * 8 * 2075259 elems which is approx= 116Mb. 
#Time and Date vectors are even larger (more bytes per element), and make up the other 34Mb of space.
object_size(hpcFullDF)

#So, we need to read in only a section of the DF. Read in only rows that correspond to 
#2007-02-01 and 2007-02-02. Lets just find the range of rows we need.
which(hpcFullDF$Date == "01/02/2007");

#And there are no dates that correspond to our range. Why??
#It seems that searching through character vectors returns an integer(0) vector. Lets convert
#dates and see what happens.
dateCol <- as.Date(hpcFullDF$Date,"%d/%m/%Y");
lowerDate <- as.Date("01/02/2007","%d/%m/%Y");
upperDate <- as.Date("02/02/2007","%d/%m/%Y");
lowRange <- range(which(dateCol == lowerDate)); #1439 elems
upRange <- range(which(dateCol == upperDate)); #1439 elems

#we infer that our rows are between 66637 and 69516
#We are also told that NA values are represented as "?" so this is also an option.
colNames <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage",
              "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

#I had to add 2 to nrows to get it to work; 2978 was not enough (lost two data points).
hpcDF <- read.csv(dataLoc, sep=";", header=TRUE, stringsAsFactors = FALSE, 
                  na.strings = c("?"), skip=66636, nrows=2880, col.names = colNames);

hpcDF$Date <- as.Date(hpcDF$Date,"%d/%m/%Y");
hpcDF$Time <- strptime(hpcDF$Time,"%H:%M:%S"); 
#Our data set is now <0.34Mb. Much more manageable. remove fullDF from before
remove(hpcFullDF);

#finally, lets check for NAs. if we complete cases and lose a row, we know there is a problem.
#Lets test
#Complete cases has trouble with Dates...as.Date and strptime didn't throw errors so...
table(complete.cases(hpcDF[,3:9])) #No False values. Numeric sections of DF are all OK.



