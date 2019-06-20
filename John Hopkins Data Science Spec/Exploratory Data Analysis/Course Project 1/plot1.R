#Load a cleaned up data set.
source("./loadData.R", echo=TRUE)

#Lets use a PNG File device to save our code.
png(filename="./plots/plot1.png",width = 480, height = 480);
plot1();
dev.off();
