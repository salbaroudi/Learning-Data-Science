## Johns Hopkins University -  Data Science Specialization
### Getting and Cleaning Data - Course Project:

### Introduction:

At the end of the Getting and Cleaning Data course, a final project is given to students to illustrate the usage of various packages and methodologies that were taught. These include:

* The ideas of Tidy Data and the _reshape2_ package.
* The _dplyr_ package.
* Functional programming techniques (anonymous functions, apply functions instead of loops).
* Standard data cleaning techniques (string splitting, REGEX, data sorting, etc).

This repo holds my project work. 

### File and Folder Structure:

* **run_analysis.R**: Our main script for cleaning and transforming data.
* **codebook.md**: Markdown file that describes our data set, variables and transformations done to achieve our outputs.
* **README.md**: You are reading this right now.
* **./output**: holds examples of the output data frames in .csv format.

### Running the Scripts:
1. Clone this github repo
2. Download the [Human Activity Recognition Using Smartphones][ziplink]
3. Extract the contents of the zip folder into the top level folder of the repo

### Script Output:

The **run_analysis.R** script will output **tidy.csv** and **wide.csv**

**run_analysis.R** expects to see a _./UCI HAR Dataset_ folder. 


[ziplink]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

**END**



