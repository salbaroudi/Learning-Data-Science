#Load a cleaned up data set.
source("./loadData.R", echo=TRUE)

#Lets make our composite plot. Override the global plot args with par()
png(filename="./plots/plot4.png",width = 480, height = 480);
par(mfcol=c(2,2));
plot2();
plot3();
plot4volt();
plot4globreactive();
dev.off();