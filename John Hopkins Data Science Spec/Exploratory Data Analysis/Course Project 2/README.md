## Johns Hopkins University Data Science Specialization
### Exploratory Data Analysis - Course Project 2: 


#### Introduction:

This is the final of two projects for the EDA course. Here, all of the skills in plotting and exploration are showcased. For my attempt, I have extended this project to include more work. Every plot will be generated using *base* and *ggplot2*, as a comparative exercise. I also do additional analysis on issues that pique my interests. 

#### Code Structure, and Running the Code:

The project is structured as follows:

1. **./Plots**: All of the plot.R scripts will print base and ggplot2 graphics to this folder.
2. **./exdata_data_NEI_data**: This is the unzipped folder from the supplied NEI/SCC zip download.
2. **loader.R**: This loads common libraries and the NEI/SCC data; the EDA and plot.R scripts call this.
3. **eda.R**: I have included a separate Exploratory Data Analysis script. I explored the data before generating plots. In particular, Question 4 required extensive investigation. 
4. **plotX.R**: A set of files that filter the data and generate plots. They correspond to answering question X (below).
5. **README.md**: You are reading this file right now.

To set up the project, clone this repo, and then download the NEI and SCC dataset. Unzip the 
directory into the root of the cloned directory. Plot files can be run immediately in R studio.

#### Project Questions:

The plots answer the questions on their own. No commentary required.

##### Question 1:

*Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
Using the base plotting system, make a plot showing the total PM2.5 emission from 
all sources for each of the years 1999, 2002, 2005, and 2008.*

![ ][plot1]

![ ][gplot1]

**Answer:**

##### Question 2:

*Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?*

**Answer:**


![ ][plot2]

![ ][gplot2]


##### Question 3:

*Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
Which have seen increases in emissions from 1999–2008?* 

**Answer:**

![ ][plot3]

![ ][gplot3]

##### Question 4:

*Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?*

**Answer:**

![ ][plot4]

![ ][gplot4]

##### Question 5:

*How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?*

**Answer:**

![ ][plot5]

![ ][gplot5]

##### Question 6:

*Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?* 

**Answer:**


![ ][plot6]

![ ][gplot6]


[plot1]:./Plots/plot1.png
[gplot1]:./Plots/gplot1.png
[plot2]:./Plots/plot2.png
[gplot2]:./Plots/gplot2.png
[plot3]:./Plots/plot3.png
[gplot3]:./Plots/gplot3.png
[plot4]:./Plots/plot4.png
[gplot4]:./Plots/gplot4.png
[plot5]:./Plots/plot5.png
[gplot5]:./Plots/gplot5.png
[plot6]:./Plots/plot6.png
[gplot6]:./Plots/gplot6.png


#### END
