#This script loads the data frame, converts the Date and Time Cols accordingly,
#and stores our plot functions.

dataLoc <- "household_power_consumption/household_power_consumption.txt";

#These are lost when we skip rows.
colNames <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage",
              "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

hpcDF <- read.csv(dataLoc, sep=";", header=TRUE, stringsAsFactors = FALSE, 
                  na.strings = c("?"), skip=66636, nrows=2880, col.names = colNames);

#Convert to Date and Time Objects.
hpcDF$Time <- strptime(paste(hpcDF$Date,hpcDF$Time),"%d/%m/%Y %H:%M:%S");
hpcDF$Date <- as.Date(hpcDF$Date,"%d/%m/%Y");

plot1 <- function() {
  with(hpcDF,hist(Global_active_power,
                  col="red",
                  xlab = "Global Active Power (kilowatts)", 
                  ylab="Frequency",
                  main="Global Active Power"));
}

plot2 <- function() {
  with(hpcDF,plot(Time,Global_active_power,
                  type = "l",
                  xlab = "", 
                  ylab="Global Active Power (kilowatts)",
                  main=""));
}

plot3 <- function() {
  with(hpcDF,plot(Time,Sub_metering_1,
                  type = "l",
                  xlab = "", 
                  ylab="Energy sub metering",
                  main="",
                  col = "black"));
  with(hpcDF,lines(Time,Sub_metering_2,col="red"));
  with(hpcDF,lines(Time,Sub_metering_3,col="blue"));
  legend("topright", col = c("black","red","blue"), 
         legend = names(hpcDF)[7:9],lty=1);
  
}

plot4volt <- function() {
  with(hpcDF,plot(Time,Voltage,
                  type = "l",
                  xlab = "datetime", 
                  ylab="Voltage",
                  main="",
                  col = "black"));
}

plot4globreactive <- function() {
  with(hpcDF,plot(Time,Global_reactive_power,
                  type = "l",
                  xlab = "datetime", 
                  ylab="Global_reactive_power",
                  main="",
                  col = "black"));
}
