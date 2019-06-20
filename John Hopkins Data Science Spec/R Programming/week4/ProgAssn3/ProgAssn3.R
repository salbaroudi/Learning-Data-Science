#Common-Code Functions:
#============================
#Signature: Character Character -> DataFrame
#Purpose: Load the dataframe, and check validity conditions.
loadvalidate <- function(state,outcome) {
  ##Read outcome data
  dF <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  if (is.null(dF)){
    stop("Error: outcomes data file not found. Check your workspace!")
  }
  ##Check that state and outcome are valid
  problems <- c("heart attack","heart failure","pneumonia")
  if (!is.element(state,dF$State)) {
    stop("Error: Invalid State")
  }
  else if (!is.element(outcome,problems)) {
    stop("Error: Invalid Outcome!")
  }
  dF  
}

#Signature: DataFrame Character Character Names[Object] -> DataFrame
#Purpose: this filters down our data frame to the state level, focusing
#on a particular outcome. Also clips out NAs from the outcome column.
filterdown <- function(dF,state,outcome,colObj) {
  #first filter down to specified state.
  dF <- dF[dF$State == state,]
  #next, convert our character 30-day col to numeric
  dF[,colObj[outcome]] <- as.numeric(dF[,colObj[outcome]])
  #next, clear out all of the NAs in the outcome column
  bad <- is.na(dF[,colObj[outcome]])
  dF <- dF[!bad,] 
  dF
}
#Signature: Character -> Names[Object Mapping]
namemap <- function(problems) {
  colObj <- c(11,17,23)
  names(colObj) <- problems
  colObj  
}

#Assignment Functions:
#=============================

#Signature: Character, Character -> Character
#Purpose: Find the best hospital in given state
best <- function(state,outcome) {
  #Load and Setup our data frame via subfunctions.
  dF <- loadvalidate(state,outcome)
  problems <- c("heart attack","heart failure","pneumonia")
  colObj <- namemap(problems)
  dF <- filterdown(dF,state,outcome,colObj)

  #We now determine which hospital is best.  
  index <- which(dF[,colObj[outcome]] == min(dF[,colObj[outcome]]))

  if (length(index) <= 0) {
    stop("Error: No maximal element in chosen outcome!")
  }
    
  if (length(index) >  1) {
    dF <- dF[index,] #This should cut down our number or rows to whatever matched.
    dF <- dF[order(dF$Hospital.name,decreasing = TRUE)] #This does a reordering of the rows that are left over
    return(dF$Hospital.name[1]) #finally, this gives the name we wanted.
  }
  else if (length(index) == 1) {
    return(dF$Hospital.Name[index])
  }
}
#Signature: 
#Purpose: Given a data frame conditioned on a state, return the hospital of specified rank
rhbody <- function(dF,outcome,colObj,num) {
  #calculate a permutation with decreasing 30 days rates
  dF <- dF[order(dF[,colObj[outcome]],decreasing = FALSE),] #do the rearragement of rows
  #Now we have an increasing rate list. Check if our num parameter is in valid range.
  if (num == "best") 
    num <- 1
  else if (num == "worst") 
    num <- nrow(dF)
  else if (num < 0 | num > nrow(dF)) #Note: You don't check if its a whole number!
    return(NA)
  
  foundRank <- dF[num,colObj[outcome]]
  #Now check for duplicates for the given rank.
  dupRows <- dF[(dF[,colObj[outcome]] == foundRank),] #pick them out
  if (nrow(dupRows) > 1)
    dupRows[order(dupRows$Hospital.Name,decreasing = FALSE),]
  dupRows$Hospital.Name[1]
}

#Signature: Character Character Character/Numeric -> Character
#Purpose: return name of hospital that matches given state, outcome and rank.
#See assignment for all the constraints.
rankhospital <- function(state, outcome, num = "best") {
  dF <- loadvalidate(state,outcome)
  #next, we check to see if num is a valid input:
  if (!is.element(num,c("best","worst")) & !is.numeric(num)) {
    stop("Error: num have numeric value, or be 'best' or 'worst'.")
  }
  problems <- c("heart attack","heart failure","pneumonia")  
  colObj <- c(11,17,23) #these are used for our outcomes
  names(colObj) <- problems
  
  dF <- filterdown(dF,state,outcome,colObj)
  rhbody(dF,outcome,colObj,num)
}

#Signature: Character Character/Numeric -> DataFrame
#Purpose: Construct a dataframe that holds a hospital of a given rank
#with respect to state and a given outcome.
#Some of the previous functionality is reused.
rankall <- function(outcome, num = "best") {
  #The assigment stated that we were not supposed to call rankhospital for this.
  #I separated out the data frame loading from the body of rankhospital, so its OK
  #to reuse parts of it.
  dF <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  if (is.null(dF)){
    stop("Error: outcomes data file not found. Check your workspace!")
  }

  problems <- c("heart attack","heart failure","pneumonia")
  if (!is.element(outcome,problems)) {
    stop("Error: Invalid Outcome!")
  }  

  colObj <- namemap(problems)

  #construct a DataFrame, according to assignment specification:
  dFRet <- data.frame(hospital=character(),state=character(),stringsAsFactors = FALSE)
  #get a vector of every state from the data 
  stateList <- unique(dF$State)
  stateList <- stateList[order(stateList)]
  for (st in stateList) {
    dFTemp <- filterdown(dF,st,outcome,colObj)
    hospitalName <- rhbody(dFTemp,outcome,colObj,num)
    dFRet <- rbind(dFRet,list(hospital=hospitalName,state=st),stringsAsFactors=FALSE)
  }
  dFRet
}

