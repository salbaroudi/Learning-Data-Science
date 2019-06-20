#datatests.R

#The following fiasco happened because I presumed equal spacing with the sep option.
#Learn to stop worrying and avoid the sep option (when whitespace separator present)!
#Testing Data: Our "X" input data.
#---------------------------------
hold <- readLines("./test/X_test.txt", n=2)
cv2 <- strsplit(hold[[2]]," ")
cv1 <- strsplit(hold[[1]]," ")
length(cv2[[1]]) #646
length(cv1[[1]]) #667
#Our lines don't have a consistent number of elements. This is a problem.  Can we just fill=TRUE for read.table? Well...
xTestDF <- read.table("./test/X_test.txt", header=FALSE, sep=" ", nrows=1); #
dim(xTestDF) # 1 667
xTestDF <- read.table("./test/X_test.txt", header=FALSE, sep=" ", skip=1, nrows=1); #
dim(xTestDF) # 1 1 646

#If we pad, everyting will be of dimension 667. But why? Are there missing values, or extra spaces in the lines? 
#Note that when we use sep=" " in our read function, two spaces in a row are interpreted as <demimiter><element>.

#One promising observation:
#Lets investigate what the training and test data actually look like:
hold <- readLines("./test/X_test.txt", n=100)
lenVec <- lapply(hold,function(x) { temp <- strsplit(x," ")[[1]]; length(temp[temp != ""]);}) #All are 561 in length.
#-------------------------------

#Now that data is properly loaded, the real data tests start here.
#2 examine features that have mean and std dev. in the title.
#Check common synonyms for them as well.
meanFeat <- grep("mean", featuresDF$V2,value=TRUE);
aveFeat <- grep("ave", featuresDF$V2,value=TRUE);
stdFeat <- grep("std",featuresDF$V2,value=TRUE);
devFeat <- grep("dev",featuresDF$V2,value=TRUE);

#mean and std return values. We need to make a decision on what needs to be selected.
#There are first order summary statistics (on raw data), and others on derived quantities
#We have raw accXYZ and gyroXYZ signals that are transformed into various derived measurements.
#I consider all mean() and std() features valid, except the meanFreq() which uses a weighted
#average. I took mean and std to mean basic (unweighted) ones.

