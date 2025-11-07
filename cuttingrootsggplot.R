#making the immersion time experiment's plot using ggplot2

#loading the libraries
library(dplyr)
library(ggplot2)
library(patchwork)

#for using ggplot we need the data in long format
cuttingroots <- read.csv("cuttingroots_long_clean.csv")

#creating a column with dpi
cuttingroots$dpi <- as.Date(cuttingroots$date, format = "%m/%d/%Y") - as.Date("3/22/24", format = "%m/%d/%Y")

#making trt a factor
cuttingroots$trt <- as.factor(cuttingroots$trt)

#making the plot with ggplot, aes makes the grid and it is where we determine the looks of the graph
plot4 <- cuttingroots %>%
  ggplot(aes(x = dpi, y = disease_percentage, color = trt, group = trt)) + #ggplot does the graph as multiple layers
  stat_summary(geom = "point", position = "dodge") + #geom point plots every single data point
  stat_summary(geom = "line", position = "dodge") + #stat_summary adds a layer with a summary statistic of the data, not the raw data
  stat_summary(geom = "errorbar", position = "dodge") +
  labs(x = "DPI", y = "% Chlorosis", title = "Cutting the Roots", color = "")

print(plot4)
