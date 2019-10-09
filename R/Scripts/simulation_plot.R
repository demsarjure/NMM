# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)

# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df <- data.frame(fread("simulation/M_t_model.csv", sep = ",", header = FALSE))
names(df) <- c("index", "l", "c", "q", "r", "deg")

# phase length
phase <- 500000

ggplot(df, aes(x = index, y = l)) +
  annotate("rect", xmin = 0, xmax = phase, ymin = 0, ymax = Inf, alpha = 0.20, fill = "grey75") +
  annotate("rect", xmin = phase, xmax = 2 * phase, ymin = 0, ymax = Inf, alpha = 0.60, fill = "grey75") +
  geom_line(size = 1, colour = "#beaed4") +
  theme_minimal() +
  theme(text = element_text(size = 18)) +
  labs(x = "Time", y = "Characteristic path") +
  scale_x_continuous(labels = function(x) format(x, scientific = FALSE)) +
  ylim(0, 10)
