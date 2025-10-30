###The objective for this script is to do the data analysis for the 2024 immersion times
###experiment. 

#setting the working directory as good practice
setwd('/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments')

#load packages
library(agricolae)

#We will use the clean immersion time data in wide format. This will be retrieved
#from the new file that was made in the cleaning data script. 
immersiontime_wide <- read.csv("immersiontime_wide_clean.csv")

##LET'S CALCULATE AUDPC

#First, calculate dpi
#Make a vector of the dates
dates <- c("03/29/2024", "04/01/2024", "04/04/2024", "04/09/2024", "04/12/2024", "04/15/2024")
#Subtract the inoculation date ( March 22nd, 2024) from each, to get the number of days post inoculation 
dpi <- as.Date(dates, format = "%m/%d/%Y") - as.Date("03/22/2024", format = "%m/%d/%Y")

#Now we will make a new column to the data frame called audpc,
#where we will apply the function audpc from agricolae to all the rows of ratings
immersiontime_wide$audpc <- apply(immersiontime_wide[,3:8], 1, audpc, dates = dpi)
head(immersiontime_wide)

##ANOVA

#Fit linear model --- AUDPC as a function of treatment
immersiontime.lm <- lm(audpc ~ trt, data=immersiontime_wide)

#Analysis of variance
anova(immersiontime.lm)