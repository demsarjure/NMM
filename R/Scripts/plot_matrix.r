#
# Plots a connectome

# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(tidyverse)
library(data.table)
library(dplyr)

# working directory
setwd("D:/Projects/nmm/R/Results/")

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

# connectome plots
matrixPlot("matrices/C_h.csv", legend=FALSE)
ggsave("matrices/C_h.pdf", width = 4, height = 4.4)

matrixPlot("matrices/C_f.csv", legend=FALSE)
ggsave("matrices/C_f.pdf", width = 4, height = 4.4)
matrixPlot("matrices/L_f.csv", legend=FALSE)
ggsave("matrices/L_f.pdf", width = 4, height = 4.4)

matrixPlot("matrices/C_d.csv", legend=FALSE)
ggsave("matrices/C_d.pdf", width = 4, height = 4.4)
matrixPlot("matrices/L_d.csv", legend=FALSE)
ggsave("matrices/L_d.pdf", width = 4, height = 4.4)
