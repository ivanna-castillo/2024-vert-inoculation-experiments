##The broad objective of this script is to clean the data before 
##graphing and analyzing the 2024 dipping vs drenching experiment. 

#loading the packages
library(agricolae)
library(reshape2)
library(dplyr)

#setting the directory in R
setwd("/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments")

#load the data
dipvsdre <- read.csv("DIPVSDREDATAFINAL.csv", sep = ";")

#add a column with the disease percentage
dipvsdre$disease_percentage <- (
  (dipvsdre$yellow + dipvsdre$dry) / (dipvsdre$total) *100)

#get rid of the columns that we don't need anymore
dipvsdre$total <- NULL
dipvsdre$wilt <- NULL
dipvsdre$yellow <- NULL
dipvsdre$dry <- NULL
dipvsdre$rep <- NULL

#making each plot a row with a column for each rating so that we can calculate audpc
dipvsdre_wide <- reshape(dipvsdre, 
                                   idvar = c("plot", "trt"), 
                                   timevar = "date", 
                                   direction = "wide",
                                   v.names = "disease_percentage")

#get rid of the "disease_percentage."
names(dipvsdre_wide) <- gsub("disease_percentage.", "", names(dipvsdre_wide))

#change the format of the column names from %d/%m/%y to %m/%d/%y, using rename, first you assign the new name
#and then you say which column it is that you want to rename
dipvsdre_wide <- dipvsdre_wide %>%
  rename("03/29/2024" = "29/3/2024",
         "04/01/2024" = "01/04/2024",
         "04/04/2024" = "04/04/2024",
         "04/09/2024" = "09/04/2024",
         "04/12/2024" = "12/04/2024",
         "04/15/2024" = "15/04/2024")

#Now you get to admire your clean data
View(dipvsdre_wide)

#Making a new file from the clean data for the anova
write.csv(dipvsdre_wide, "dipvsdre_wide_clean.csv", row.names = FALSE)

#Making a new file from the cl"ean data for the ggplot (long format)
write.csv(dipvsdre, "dipvsdre_long_clean.csv", row.names = FALSE)



