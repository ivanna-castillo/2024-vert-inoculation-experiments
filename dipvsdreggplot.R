#making the dip vs dre experiment's plot using ggplot2

#loading the libraries
library(dplyr)
library(ggplot2)
library(patchwork)

#for using ggplot we need the data in long format
dipvsdre <- read.csv("dipvsdre_long_clean.csv")

#creating a column with dpi
dipvsdre$dpi <- as.Date(dipvsdre$date, format = "%d/%m/%Y") - as.Date("22/03/2024", format = "%d/%m/%Y")

#making trt a factor
dipvsdre$trt <- as.factor(dipvsdre$trt)

#making the plot with ggplot, aes makes the grid and it is where we determine the looks of the graph
plot3 <- dipvsdre %>%
  ggplot(aes(x = dpi, y = disease_percentage, color = trt, group = trt)) + #ggplot does the graph as multiple layers
  stat_summary(geom = "point", position = "dodge") + #geom point plots every single data point
  stat_summary(geom = "line", position = "dodge") + #stat_summary adds a layer with a summary statistic of the data, not the raw data
  stat_summary(geom = "errorbar", position = "dodge") +
  labs(x = "DPI", y = "% Chlorosis", title = "Dipping vs. Drenching the Roots", color = "")

print(plot3)