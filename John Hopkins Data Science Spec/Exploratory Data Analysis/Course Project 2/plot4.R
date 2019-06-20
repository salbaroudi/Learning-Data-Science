
#We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
#We need a bar chart to show how the levels have went down.

#x:
years <- unique(NEI$year)

#First, we need to identify all records that have "Coal Related Sources" 
#Lets find them. Recall the following SCC names:

names(SCC)
#Where does the word "coal" appear? Lets grep it up.
coalIndex <- with(SCC, grep("coal", Short.Name ,ignore.case=TRUE))
compareDF <- data.frame(SCC$SCC[coalIndex], SCC$Short.Name[coalIndex], SCC$EI.Sector[coalIndex], stringsAsFactors = FALSE)
View(compareDF) #from this, I manually compile ranges of valid coalIndex entries: those that indicate
#direct combustion of coal!

#So these are our SCCKeys that we need to search for, in the NEI list!
SCCKeys <- compareDF[c(1:96,108:109, 117, 126:129, 146:148, 199:202, 229:235),1]


coalDF <- subset(NEI, SCC == SCCKeys[1], select = c("Emissions","year"))

#For every SCCKey, we gather up emission and year values.
for (key in SCCKeys[2:length(SCCKeys)]) {
  tempDF <- subset(NEI, SCC == key, select = c("Emissions","year"))
  coalDF <- rbind(coalDF,tempDF)
}

#x:
years <- unique(coalDF$year)

#y: 
totalEmissions <- sapply(years, function(e) {
  sum((subset(coalDF, coalDF$year == e))$Emissions) 
})

png(filename="./Plots/plot4.png",width = 480, height = 480);

par(mfrow=c(1,1))
par(ylim=max(totalEmissions))
barplot(totalEmissions, main="Total Coal Emissions by Year:", axes=TRUE, names.arg=as.character(years),
        xlab="Year",ylab="Total Emissions [in tons]",
        col=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

dev.off()

#---------------------------
# dplyr and ggplot2 Plot:

#I don't use dplyr here. The filtering above was already derived by hand in the eda.R file.
##ggplot2:
years  <- as.factor(years)
tE <- data.frame(year=years, total=totalEmissions)

g <- ggplot(data=tE, aes(x = year, y = total))
g <- g+geom_col(aes(fill = year))+ggtitle("Total Coal Emissions across U.S, by Year:")
g <- g+xlab("Year")+ylab("Total Emissions [in tons]")
g+theme_dark()+scale_fill_manual(values=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

ggsave(filename="gplot4.png",path="./Plots/",width=4,height=4,units="in")