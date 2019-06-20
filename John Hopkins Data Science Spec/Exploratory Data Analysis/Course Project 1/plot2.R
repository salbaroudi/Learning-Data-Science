#Load a cleaned up data set.
source("./loadData.R", echo=TRUE)

#Lets use a PNG File device to save our code.
png(filename="./plots/plot2.png",width = 480, height = 480);
plot2();
dev.off();

