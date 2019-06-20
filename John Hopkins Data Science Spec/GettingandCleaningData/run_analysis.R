#Tidy Data Clean Up Project:
#0 - Successfully load the datasets!
xTrainDF <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE); #7352 by 561 
xTestDF <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE); #2947 by 561
yTrainDF <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="\n"); #7352 by 1
yTestDF <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="\n"); #2947 by 1

#Read in subject data:
subTrainDF <-  read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="\n"); #7352 by 1
subTestDF <-  read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="\n"); #2947 by 1

#Labels and Features:
actLabelDF <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE);
featuresDF <- read.table("./UCI HAR Dataset/features.txt", header=FALSE,stringsAsFactors = FALSE);

#1 - Merge training and test sets to create one data set
#Do the rbindings first (needs col names to be the same)
fullXDF <- rbind(xTrainDF,xTestDF);
fullYDF <- rbind(yTrainDF,yTestDF);
fullSubjectDF <- rbind(subTrainDF,subTestDF);
names(fullXDF) <- featuresDF$V2;

#Lets do the cbindings now...
YSubCols <- cbind(fullSubjectDF,fullYDF);
names(YSubCols) <- c("subject", "y");
#We now have the fully built data frame, all on its own.
fullDF <- cbind(YSubCols,fullXDF);

#Destroy temporary DFs, to save memory.
remove(fullXDF,fullYDF,YSubCols,fullSubjectDF);
remove(xTrainDF,yTrainDF,xTestDF,yTestDF);
remove(subTrainDF,subTestDF);

#2 - Extract measurements on the mean and std dev. for each measurement
stdVect <- grep("std",featuresDF$V2,value=TRUE);
mVIndex <- grep("mean",featuresDF$V2); 
mVIndex <- mVIndex[! mVIndex %in% grep("meanFreq",featuresDF$V2)];
meanVect <- featuresDF$V2[mVIndex];

#Now lets make a DF with only the variables that we care about.
finalDF <- fullDF[,c("subject", "y")];
names(finalDF) <- c("subject", "y");

#3 Appropriately Labels the dataset with descriptive variable names
finalMean <- fullDF[,meanVect];
names(finalMean) <- gsub("[()-_]*","",tolower(meanVect));
finalStd <- fullDF[,stdVect];
names(finalStd) <- gsub("[()-_]*","",tolower(stdVect));

finalDF <- cbind(finalDF,finalMean,finalStd);

#Remove more DFs that aren't needed.
remove(mVIndex,fullDF, finalMean, finalStd);

#4 Uses descriptive activity names.
#Lets dump the underscores, lower the case, and shorten the names (verb and preposition only).
actLabelDF$V2 <- sapply(actLabelDF$V2, tolower);
actLabelDF$V2 <- gsub("[_]*([i][n][g])*([s][t][a][i][r][s])*","",actLabelDF$V2);
actLabelDF$V2[4] <- "sit"; #two t's. Just overwrite.

finalDF$y <- sapply(finalDF$y, function(x) actLabelDF[x,2]) #it would be nice to dump the 2.

#5: Create a 2nd, tidy indep. dataset wtih averaging across subject and activity groups.
library(reshape2)
tidyDF <- melt(finalDF[,1:35],id.vars=c("subject","y"));

#6 - Finally, let's save the datasets to csv files.
write.csv(tidyDF,file="./output/tidy.csv");
write.csv(finalDF,file="./output/wide.csv");

#END.
