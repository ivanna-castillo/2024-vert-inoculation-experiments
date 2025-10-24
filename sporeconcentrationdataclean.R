##The broad objective of this script is to clean the data before 
##graphing and analyzing the 2024 spore concentration experiment. 

#loading the packages
library(agricolae)
library(reshape2)
library(dplyr)

#setting the directory in R
setwd("/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments")

#load the data
sporeconcentration <- read.csv("SPORECONCDATAFINAL.csv", sep = ";")

#add a column with the disease percentage
sporeconcentration$disease_percentage <- (
  (sporeconcentration$yellow + sporeconcentration$dry) / (sporeconcentration$total) *100)

#make it become an integer so that it does not have decimal places
sporeconcentration$disease_percentage <- as.integer(sporeconcentration$disease_percentage)

#get rid of the columns that we don't need anymore
sporeconcentration$total <- NULL
sporeconcentration$wilt <- NULL
sporeconcentration$yellow <- NULL
sporeconcentration$dry <- NULL
sporeconcentration$rep <- NULL

#making each plot a row with a column for each rating so that we can calculate audpc
sporeconcentration_wide <- reshape(sporeconcentration, 
                                   idvar = c("plot", "trt"), 
                                   timevar = "date", 
                                   direction = "wide",
                                   v.names = "disease_percentage")

#get rid of the "disease_percentage."
names(sporeconcentration_wide) <- gsub("disease_percentage.", "", names(sporeconcentration_wide))

#change the format of the column names from %d/%m/%y to %m/%d/%y, using rename, first you assign the new name
#and then you say which column it is that you want to rename
sporeconcentration_wide <- sporeconcentration_wide %>%
  rename("03/29/2024" = "29/03/2024",
         "04/01/2024" = "01/04/2024",
         "04/04/2024" = "04/04/2024",
         "04/09/2024" = "09/04/2024",
         "04/12/2024" = "12/04/2024",
         "04/15/2024" = "15/04/2024")

#Now you get to admire your clean data
View(sporeconcentration_wide)



