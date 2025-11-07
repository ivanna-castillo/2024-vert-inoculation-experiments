#making a grid of the plots and saving the jpeg file

#loading the libraries
library(patchwork)
library(jpeg)

#assembling the plots and adding a main title
grid <- ((plot1 + plot2) / (plot3 + plot4)) +
  plot_annotation(title = "Preliminary experiments for Verticillium wilt inoculation")

#making it a jpeg file
jpeg(filename = "2024_vert_experiments.jpeg", width = 1000, height = 750, units = "px", quality = 100)

# draw the grid into the jpeg file
print(grid)

# close the device and save the file
dev.off()
