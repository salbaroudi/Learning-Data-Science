 #We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
#We need a bar chart to show how the levels have went down.

#Here, we need to gather all of the motor related sources for Baltimore City.
#Looking at the NEI Documentation (see PDF), our data points must be "ON-ROAD"
#and be in a section that involves motor vehicles. Page 23 of the document shows us
#that ON-ROAD contains points exclusively in the motor vehicle catagories; we can just
#focus on "ON-ROAD" points and be pretty sure we have an accurate subset.

bMotorDF <- subset(NEI, fips == "24510" & type == "ON-ROAD")

#x:
years <- unique(bMotorDF$year)

#y: 
baEmissions <- sapply(years, function(e) {
  sum((subset(bMotorDF, bMotorDF$year == e))$Emissions) 
})

png(filename="./Plots/plot5.png",width = 480, height = 480);

par(mfrow=c(1,1))
par(ylim=max(totalEmissions))
barplot(baEmissions, main="Total Baltimore Motor Emissions by Year:", axes=TRUE, names.arg=as.character(years),
        xlab="Year",ylab="Total Emissions [in tons]",
        col=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

dev.off()

#---------------------------
# dplyr and ggplot2 Plot:

tE <- NEI %>% filter(fips == "24510" & type == "ON-ROAD") %>% group_by(year) %>% summarize(total=sum(Emissions))

tE$year <- as.factor(tE$year)
g <- ggplot(data=tE, aes(x = year, y = total))
g <- g+geom_col(aes(fill = year))+ggtitle("Baltimore City, Total Emissions by Year:")
g <- g+xlab("Year")+ylab("Total Emissions [in tons]")
g+theme_dark()+scale_fill_manual(values=colorRampPalette(c(rgb(1,0,0,0), rgb(0,0,1,0)))(4))

ggsave(filename="gplot5.png",path="./Plots/",width=4,height=4,units="in")