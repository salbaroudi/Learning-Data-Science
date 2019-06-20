#Load Libraries:
library(dplyr)
library(ggplot2)

#load the data.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

#The data has already been compiled for us in a reasonable format. Augmentations will be done
#as necessary for our EDA and plots.
