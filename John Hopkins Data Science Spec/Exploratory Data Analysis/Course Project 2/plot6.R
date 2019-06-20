#We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
bMotorDF <- subset(NEI, fips == "24510" & type == "ON-ROAD")

#x:
years <- unique(bMotorDF$year)

#y: 
baEmissions <- sapply(years, function(e) {
  sum((subset(bMotorDF, bMotorDF$year == e))$Emissions) 
})

#Lets compare to Los Angeles:

laMotorDF <- subset(NEI, fips == "06037" & type == "ON-ROAD")
#y: 
laEmissions <- sapply(years, function(e) {
  sum((subset(laMotorDF, laMotorDF$year == e))$Emissions) 
})

png(filename="./Plots/plot6.png",width = 480, height = 480);

yChar <- "Emissions [tons]"
xChar <- "Year"
typeChar <- unique(NEI$type)
par(mfrow=c(1,2),mar=c(4,4,4,4))
par(pch=13,col="blue")
plot(years, baEmissions, type="b", xlab=xChar, ylab=yChar)
title("Baltimore Motor Emissions:")
plot(years, laEmissions, type="b", xlab=xChar, ylab=yChar)
title("Los Angeles Motor Emissions:")

dev.off()

#---------------------------
# dplyr and ggplot2 Plot:

tEBA <- NEI %>% filter(fips == "24510" & type == "ON-ROAD") %>% group_by(year) %>% summarize(total=sum(Emissions))
tELA <- NEI %>% filter(fips == "06037" & type == "ON-ROAD") %>% group_by(year) %>% summarize(total=sum(Emissions))

#we need to partition into two graphs, so we mutate our DFs to include type factor information:
tEFull <- rbind(tEBA,tELA)
tEFull <- mutate(tEFull, as.factor(c(rep("Baltimore",4),rep("Los Angeles",4))))
names(tEFull) <- c("year", "total", "city")

g <- ggplot(aes(x=year,y=total),data=tEFull)
g <- g+geom_line(color="blue")+geom_point(color="orange")+facet_wrap(. ~ city)
g <- g+ggtitle("Baltimore and Los Angeles Emissions:")+theme_dark()
g+xlab("Year")+ylab("Total Emissions [in tons]")

ggsave(filename="gplot6.png",path="./Plots/",width=4,height=4,units="in")