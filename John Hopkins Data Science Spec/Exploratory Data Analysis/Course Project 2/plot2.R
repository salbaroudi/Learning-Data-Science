#We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
#We need a bar chart to show how the levels have went down.

#x:
years <- unique(NEI$year)
NEIBaltimore <- subset(NEI, fips == "24510")

#y: 
totalEmissions <- sapply(years, function(e) {
  sum((subset(NEIBaltimore, NEIBaltimore$year == e))$Emissions) #Ugly, but terse.
})

png(filename="./Plots/plot2.png",width = 480, height = 480);

par(mfrow=c(1,1))
barplot(totalEmissions, main="Baltimore City, Total Emissions by Year:", axes=TRUE, names.arg=as.character(years),
        xlab="Year",ylab="Total Emissions [in tons]",
        col=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

dev.off()

#---------------------------
# dplyr and ggplot2 Plot:

#y: 
tE <- NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarize(total=sum(Emissions))

tE$year <- as.factor(tE$year)
g <- ggplot(data=tE, aes(x = year, y = total))
g <- g+geom_col(aes(fill = year))+ggtitle("Baltimore City, Total Emissions by Year:")
g <- g+xlab("Year")+ylab("Total Emissions [in tons]")
g+theme_dark()+scale_fill_manual(values=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

ggsave(filename="gplot2.png",path="./Plots/",width=4,height=4,units="in")
