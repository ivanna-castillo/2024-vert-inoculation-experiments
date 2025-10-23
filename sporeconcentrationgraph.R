setwd('/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments')

sporeconcentration <- read.csv("SPORECONCDATAFINAL.csv", sep = ";")

library(writexl)

write_xlsx(sporeconcentration, "sporeconcentration.xlsx")

sporeconcentrationdata <- read_excel("sporeconcentration.xlsx")

#remove the extra columns
sporeconcentrationdata <- sporeconcentrationdata[, !(names(sporeconcentrationdata) %in% c("total", "wilt", "yellow", "dry"))]

#will make each plot a single row with multiple columns for different dates
library(reshape)

#rearrange the data
sporeconcentration_wide <- cast(sporeconcentrationdata, plot ~ date, value = "disease_percentage")

#We will need a vector of days post inoculation reflecting when we rated
#First let's remove the year from the date so that we can easily subtract the dates
names(sporeconcentration_wide) <- gsub("2024-", "", names(sporeconcentration_wide))

#Include the treatment column:
plot_trt <- unique(sporeconcentrationdata[, c("plot", "trt")])
sporeconcentration_wide <- merge(sporeconcentration_wide, plot_trt, by = "plot", all.x = TRUE)

#Change the order of the columns
new_order <- c("plot", "trt",
               "03-29", "04-01", "04-04",
               "04-09", "04-12", "04-15")

#Reorder the dataframe
sporeconcentration_wide <- sporeconcentration_wide[, new_order]

#Let's turn the column names into dates and subtract the date I inoculated (March 22nd, 2024) 
dates <- names(sporeconcentration_wide)[3:8]
dpi <- as.Date(dates, format="%m-%d") - as.Date("03-22", format="%m-%d")
print(dpi)

#Disease progression over time Plot

#First get entry means per time point
severity_mean <- aggregate(as.matrix(sporeconcentration_wide[,3:8]) ~ sporeconcentration_wide$trt, FUN=mean) 

colors = c("red", "blue", "green")

sporeconcentrationplot <- plot(0, type='n', xlim=range(dpi), ylim=c(0,100), ylab='% Chlorosis', xlab='DPI', 
                    main = "Spore Concentration", cex = 0.9) #Make empty plot
for(i in 1:nrow(severity_mean)){ #Loop through entries and draw a line for each one
  lines(dpi, severity_mean[i,-1])
}
grid()
for (i in 1:nrow(severity_mean)) {
  lines(dpi, as.numeric(severity_mean[i, -1]),
        col = colors[i], lwd = 2)
}

legend(x = 14,
       y = 30, legend = severity_mean$`sporeconcentration_wide$trt`,
       col= colors, lty=1:1, cex=0.8)

##LET'S CALCULATE AUDPC 

#Let's calculate AUDPC
#Load package 'agricolae' (install first if you dont have -- install.packages('agricolae'))
library(agricolae)

#Now we will make a new column to the data frame called audpc,
#where we will apply the function audpc from agricolae to all the rows of ratings
sporeconcentration_wide$audpc <- apply(sporeconcentration_wide[,3:8], 1, audpc, dates = dpi)
head(sporeconcentration_wide)

#### ANOVA

#Fit linear model --- AUDPC as a function of entry and block
sporeconcentration.lm <- lm(audpc ~ trt, data=sporeconcentration_wide)

#Analysis of variance
anova(sporeconcentration.lm)
#Significant effect of entry (meaning not all entries have the same mean)
