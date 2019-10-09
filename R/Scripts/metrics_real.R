# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(cowplot)

# working directory
setwd("D:/Projects/nmm/R/Results")

# real values of metrics
# characteristic path
l_r <- 4.15
# clustering coefficient
c_r <- 0.19
# modularity
q_r <- 0.34
# assortativity coefficient
r_r <- 0.03
# degree
deg_r <- 27.6

# folder
fileName <- paste0("real/M_metrics_real.csv")

# load values
df <- data.frame(fread(fileName, sep = ",", header = FALSE))
names(df) <- c("iteration", "l", "c", "q", "r", "deg")

# melt
df <- melt(df)

# scale_colour_manual(values = c("#beaed4", "#cc2714"))
# scale_fill_manual(values = c("#beaed4", "#cc2714"))

l <- ggplot(df[df$variable == "l", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = l_r, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Characteristic path", y = "") +
  ylim(0, 20)

c <- ggplot(df[df$variable == "c", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = c_r, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Clustering coefficient", y = "") +
  ylim(0, 1)

q <- ggplot(df[df$variable == "q", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = q_r, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Weighted modularity", y = "") +
  ylim(0, 1)

r <- ggplot(df[df$variable == "r", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = r_r, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Assortativity coefficient", y = "") +
  ylim(-1, 1)

# deg <- ggplot(df[df$variable == "deg", ], aes(x = variable, y = value)) +
#   geom_boxplot(colour = "grey25", fill = "#beaed4") +
#   geom_hline(yintercept = deg_r, color="grey50", linetype="11", size = 1) +
#   theme_minimal() +
#   theme(axis.text.x = element_blank()) +
#   labs(x = "Mean network degree", y = "") +
#   ylim(0, 30)

plot_grid(l, c, q, r, ncol = 4, nrow = 1, scale = 0.9)
