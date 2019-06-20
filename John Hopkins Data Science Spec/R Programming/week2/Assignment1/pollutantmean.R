#Signature: Character[String] Numeric -> Character[String]
#Purpose: Given a directory string and number, generate relative path to CSV file.
generatePath <- function(dir,nID) {
  if (nID < 10) 
    fileName = paste("00",toString(nID),sep="")
  else if (nID < 100) 
    fileName = paste("0",toString(nID),sep="")
  else if (nID >= 100)
    fileName = toString(nID)
  tempDirStr <- paste("./", dir, "/", fileName, ".csv", sep="")
  tempDirStr
}


#Signature: Character[String] Character[String] Vector[Numeric] -> Numeric
# Purpose: Find Sensor files listed in id vector, and calculate
# the average reading. NAs will be removed if found.
pollutantmean <- function(directory, pollutant, id=1:332) {
    #First, lets assume all inputs are correct.
    #Lets open up the list of files.
    #Check pollutant type:
    if (pollutant == "sulfate"){
      colIndex = 2
    } else if (pollutant == "nitrate"){
      colIndex = 3
    } else { #colIndex cannot be undefined. 
      print("Error: Unrecognized pollutant argument.")
      return
    }
    #we use these to calculate our aveage for the pollutant.
    totalSum = 0
    totalN = 0
    
    for (nID in id) {
      tempDirStr <- generatePath(directory,nID)
      
      tempDF <- read.table(tempDirStr,header=TRUE,sep=",")
      tempDF <- tempDF[complete.cases(tempDF[,colIndex]),]
      totalSum <- totalSum + sum(tempDF[,colIndex])
      totalN <- totalN + nrow(tempDF)
    }
    #print(paste("Total Sum =",toString(totalSum)))
    #print(paste("Total N =",toString(totalN)))
    totalSum / totalN
}

#Signature: Character[String] Vector[Numeric] -> DataFrame[**]
#Purpose: Return a Data Frame that reports number of complete rows for each file.
#Header for Data Frame: (ID, NOBS)
complete <- function(directory,id = 1:332) {
    dF <- data.frame(id=numeric(),nobs=character(),stringsAsFactors = FALSE)
    for (nID in id){
      tempDirStr <- generatePath(directory,nID)
      print(tempDirStr)
      tempDF <- read.table(tempDirStr, header=TRUE, sep=",")
      tempDF <- tempDF[complete.cases(tempDF),]
      dE <- list(id=nID,nobs=nrow(tempDF))
      dF <- rbind(dF,dE,stringsAsFactors=FALSE)
  }
  dF 
}

#Signature: Character[String] Numeric -> Object[Correlation]
#Purpose: Calculate the correlation of all data points from monitors above a given
#complete cases function. We use the complete function for this.
corr <- function(directory,threshold=0) {
  dT <- complete(directory) 
  dT <- dT[(dT$nobs > threshold),] #kick out underperforming ones.
  if (nrow(dT) == 0)
     return(vector(mode="numeric",length=0))
  #corrDF <- data.frame(Date=as.Date(character()),sulfate=numeric(),nitrate=numeric(),ID=numeric(),stringsAsFactors = FALSE)
  corrVect <- vector(mode="numeric",length=nrow(dT))
    for (nID in 1:nrow(dT)) {
    tempDirStr <- generatePath(directory,nID)
    tempDF <- read.table(tempDirStr,header=TRUE,sep=",")
    tempDF <- tempDF[complete.cases(tempDF),] 
    corrVect[nID] <- cor(tempDF$sulfate,tempDF$nitrate)
  }
  corrVect
}