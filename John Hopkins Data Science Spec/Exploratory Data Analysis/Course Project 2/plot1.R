 #We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
#We need a bar chart to show how the levels have went down.

#x:
years <- unique(NEI$year)

#y: 
totalEmissions <- sapply(years, function(e) {
  sum((subset(NEI, NEI$year == e))$Emissions) 
  })

#Set Writer:
png(filename="./Plots/plot1.png",width = 480, height = 480);

#Create Plot:
par(mfrow=c(1,1))
barplot(totalEmissions, axes=FALSE, names.arg=as.character(years),
          xlab="Year",ylab="Total Emissions [in tons]",
          col=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))
title(main="Total Emissions by Year:")
axis(side=2,tick=TRUE, lwd=1)

#Close Device:
dev.off()


#---------------------------
# dplyr and ggplot2 Plot:

#x: #Use the years from the base plot (above).
#y: 
tE <- NEI %>% group_by(year) %>% summarize(total=sum(Emissions))

tE$year <- as.factor(tE$year)
g <- ggplot(data=tE, aes(x = year, y = total))
g <- g+geom_col(aes(fill = year))+ggtitle("Total Emissions by Year:")
g <- g+xlab("Year")+ylab("Total Emissions [in tons]")
g+theme_dark()+scale_fill_manual(values=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

ggsave(filename="gplot1.png",path="./Plots/",width=4,height=4,units="in")
