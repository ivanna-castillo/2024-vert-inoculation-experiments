##The broad objective of this script is to clean the data before 
##graphing and analyzing the 2024 cutting roots experiment. 

#loading the packages
library(agricolae)
library(reshape2)
library(dplyr)

#setting the directory in R
setwd("/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments")

#load the data
cuttingroots <- read.csv("cuttingrootsFINAL.csv")

#add a column with the disease percentage
cuttingroots$disease_percentage <- (
  (cuttingroots$yellow + cuttingroots$dry) / (cuttingroots$total) *100)

#get rid of the columns that we don't need anymore
cuttingroots$total <- NULL
cuttingroots$wilt <- NULL
cuttingroots$yellow <- NULL
cuttingroots$dry <- NULL
cuttingroots$rep <- NULL

#making each plot a row with a column for each rating so that we can calculate audpc
cuttingroots_wide <- reshape(cuttingroots, 
                                   idvar = c("plot", "trt"), 
                                   timevar = "date", 
                                   direction = "wide",
                                   v.names = "disease_percentage")

#get rid of the "disease_percentage."
names(cuttingroots_wide) <- gsub("disease_percentage.", "", names(cuttingroots_wide))

#change the format of the column names from %d/%m/%y to %m/%d/%y, using rename, first you assign the new name
#and then you say which column it is that you want to rename
cuttingroots_wide <- cuttingroots_wide %>%
  rename("03/29/2024" = "3/29/24",
         "04/01/2024" = "4/1/24",
         "04/04/2024" = "4/4/24",
         "04/09/2024" = "4/9/24",
         "04/12/2024" = "4/12/24",
         "04/15/2024" = "4/15/24")

#Now you get to admire your clean data
View(cuttingroots_wide)

#Making a new file from the clean data for the anova
write.csv(cuttingroots_wide, "cuttingroots_wide_clean.csv", row.names = FALSE)

#Making a new file from the cl"ean data for the ggplot (long format)
write.csv(cuttingroots, "cuttingroots_long_clean.csv", row.names = FALSE)