
#We should have an NEI and SCC data frame after loading.
source("./loader.R", echo=TRUE)

#---------------------------
#Manual Structuring + Base Plot:
#We need a bar chart to show how the levels have went down.

#x:
years <- unique(NEI$year)

NEIBaltimore <- subset(NEI, fips == "24510")

NEIPoint <- subset(NEIBaltimore, type == "POINT")
NEINonPoint <- subset(NEIBaltimore, type == "NONPOINT")
NEIRoad  <- subset(NEIBaltimore, type == "ON-ROAD")
NEINonRoad <- subset(NEIBaltimore, type == "NON-ROAD")

#y: 
tEPoint <- sapply(years, function(e) {
  sum((subset(NEIPoint, NEIPoint$year == e))$Emissions) #Ugly, but terse.
})

tENonPoint <- sapply(years, function(e) {
  sum((subset(NEINonPoint, NEINonPoint$year == e))$Emissions) #Ugly, but terse.
})

tERoad <- sapply(years, function(e) {
  sum((subset(NEIRoad, NEIRoad$year == e))$Emissions) #Ugly, but terse.
})

tENonRoad <- sapply(years, function(e) {
  sum((subset(NEINonRoad, NEINonRoad$year == e))$Emissions) #Ugly, but terse.
})

png(filename="./Plots/plot3.png",width = 480, height = 480);

yChar <- "Emissions [tons]"
xChar <- "Year"
typeChar <- unique(NEI$type)
par(mfrow=c(2,2),mar=c(4,4,4,4))
par(pch=13,col="blue")
plot(years, tEPoint, type="b", xlab=xChar, ylab=yChar)
title(paste("T. Emission, Type: ",typeChar[1],", n=",as.character(dim(NEIPoint)[1])))

plot(years, tENonPoint , type="b", xlab=xChar, ylab=yChar)
title(paste("T. Emission, Type: ",typeChar[2],", n=",as.character(dim(NEINonPoint)[1])))

plot(years, tERoad, type="b", xlab=xChar, ylab=yChar)
title(paste("T. Emission, Type: ",typeChar[3],", n=",as.character(dim(NEIRoad)[1])))

plot(years, tENonRoad, type="b", xlab=xChar, ylab=yChar)
title(paste("T. Emission, Type: ",typeChar[4],", n=",as.character(dim(NEINonRoad)[1])))

dev.off()

#---------------------------
# dplyr and ggplot2 Plot:

#y: 
tE <- NEI %>% filter(fips == "24510") %>% group_by(type,year) %>% summarize(total=sum(Emissions))

#now for ggplot2:

g <- ggplot(aes(x=year,y=total),data=tE)
g <- g+geom_line(color="blue")+geom_point(color="orange")+facet_wrap(. ~ type)
g <- g+ggtitle("Baltimore Total Emissions | Type")+theme_dark()
g+xlab("Year")+ylab("Total Emissions [in tons]")

ggsave(filename="gplot3.png",path="./Plots/",width=4,height=4,units="in")
