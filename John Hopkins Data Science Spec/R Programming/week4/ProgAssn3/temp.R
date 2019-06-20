##Return hospital name in that state with lowest 30-day death rate
#dF[dF$State == state, colObj[outcome]]

if (nrow(dupRows) == 1) 
  dupRows[1,colObj[outcome]]
else if {
  
}
else 
  stop("Error: dupRows was 0 or negative. Serious problem!")


#first filter down to specified state.
dF <- dF[dF$State == state,]
#next, convert our character 30-day col to numeric
dF[,colObj[outcome]] <- as.numeric(dF[,colObj[outcome]])
#next, clear out all of the NAs in the outcome column
bad <- is.na(dF[,colObj[outcome]])
dF <- dF[!bad,] 

#first filter down to specified state.
dF <- dF[dF$State == state,]
#next, convert our character 30-day col to numeric
dF[,colObj[outcome]] <- as.numeric(dF[,colObj[outcome]])
#next, clear out all of the NAs in the outcome column
bad <- is.na(dF[,colObj[outcome]])
dF <- dF[!bad,] 

colObj <- c(11,17,23)
names(colObj) <- problems


#calculate a permutation with decreasing 30 days rates
dF <- dF[order(dF[,colObj[outcome]],decreasing = FALSE),] #do the rearragement of rows
#Now we have an increasing rate list. Check if our num parameter is in valid range.
if (num == "best") {
  num <- 1
}
else if (num == "worst") {
  num <- nrow(dF)
}
else if (num < 0 | num > nrow(dF)) { #Note: You don't check if its a whole number!
  return(NA)
}

foundRank <- dF[num,colObj[outcome]]
#Now check for duplicates for the given rank.
dupRows <- dF[(dF[,colObj[outcome]] == foundRank),] #pick them out
if (nrow(dupRows) > 1) {
  dupRows[order(dupRows$Hospital.Name),]
}
#dupRows$Hospital.Name[1]