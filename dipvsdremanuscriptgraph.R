###In this script I will plot the data for the dipping vs drenching
###experiment. The graph will be a Disease progression with error bars.

#setting the working directory as good practice
setwd('/Users/ikc6/Library/CloudStorage/OneDrive-CornellUniversity/Research_PhD/2024 inoculation experiments')

#Disease progression over time Plot

#First get entry means per time point
severity_mean <- aggregate(as.matrix(dipvsdre_wide[,3:8]) ~ dipvsdre_wide$trt, FUN=mean) 

#making a basic color palette for each treatment
colors = c("red", "blue", "green")

#the layout plot
dipvsdreplot <- plot(0, type='n', xlim=range(dpi), ylim=c(0,100), ylab='% Chlorosis', xlab='DPI', 
                         main = "Dipping vs. Drenching", cex = 0.9) #Make empty plot
for(i in 1:nrow(severity_mean)){ #Loop through entries and draw a line for each one
  lines(dpi, severity_mean[i,-1])
}
grid()
for (i in 1:nrow(severity_mean)) {
  lines(dpi, as.numeric(severity_mean[i, -1]),
        col = colors[i], lwd = 2)
}

#adding a legend and locating it 
legend(x = 17,
       y = 40, legend = severity_mean$`dipvsdre_wide$trt`,
       col= colors, lty=1:1, cex=0.75)