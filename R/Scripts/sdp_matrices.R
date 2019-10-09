#
# Plots a grid of matrices

# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(tidyverse)
library(cowplot)
library(data.table)
library(dplyr)

matrixPlot <- function(filename, title = "", legend = FALSE) {
  # connectivity matrix
  c <- read.table(filename, header = FALSE, sep = ",")
  
  n <- length(c)
  
  # reshape data
  c <- c %>%
    rownames_to_column("Var1") %>%
    gather(Var2, value, -Var1) %>%
    mutate(
      Var1 = factor(Var1, levels = 1:n),
      Var2 = factor(gsub("V", "", Var2), levels = 1:n)
    )
  
  # plot
  plot <- ggplot(c, aes(Var1, Var2)) +
    geom_tile(aes(fill = value)) +
    scale_fill_gradient2(low = "white", high = "darkblue", guide = "colorbar") +
    theme_minimal() +
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
          axis.text.x = element_blank(), axis.text.y = element_blank(),
          legend.title=element_blank(),
          panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          text = element_text(size = 18)) +
    xlab("") +
    ylab("") +
    ggtitle(title) +
    theme(plot.title = element_text(hjust = 0.5))
  
  if (!legend) {
    plot <- plot + theme(legend.position = "none")
  }
  
  plot
}

# working directory
setwd("D:/Projects/nmm/R/Results")

# connectome plots
p1 <- matrixPlot("sdp/C_1.csv", expression(a[sdp] * " = 0"), FALSE)
p2 <- matrixPlot("sdp/C_2.csv", expression(a[sdp] * " = 0.00005"), FALSE)
p3 <- matrixPlot("sdp/C_3.csv", expression(a[sdp] * " = 0.0001"), FALSE)
p4 <- matrixPlot("sdp/C_4.csv", expression(a[sdp] * " = 0.00015"), FALSE)
p5 <- matrixPlot("sdp/C_5.csv", expression(a[sdp] * " = 0.0002"), FALSE)

plot_grid(p1, p2, p3, p4, p5, ncol = 5, nrow = 1, scale = 0.9)

