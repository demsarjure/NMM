#
# Plots a grid of matrices

# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(cowplot)
library(plyr)
library(data.table)

# working directory
setwd("D:/Projects/nmm/R/Results")

# metric plots
df <- data.frame(fread("sdp/M_sdp_model.csv", sep = ",", header = FALSE))
names(df) <- c("iteration", "a_sdp", "l", "c", "q", "r", "deg")

# summarize data
df_mean <- ddply(df, ~ a_sdp , summarize,
                 l_mean = mean(l, na.rm = TRUE), l_low  = quantile(l, 0.025, na.rm = TRUE), l_hi = quantile(l, 0.975, na.rm = TRUE),
                 c_mean = mean(c, na.rm = TRUE), c_low  = quantile(c, 0.025, na.rm = TRUE), c_hi = quantile(c, 0.975, na.rm = TRUE),
                 q_mean = mean(q, na.rm = TRUE), q_low  = quantile(q, 0.025, na.rm = TRUE), q_hi = quantile(q, 0.975, na.rm = TRUE),
                 r_mean = mean(r, na.rm = TRUE), r_low  = quantile(r, 0.025, na.rm = TRUE), r_hi = quantile(r, 0.975, na.rm = TRUE))

#plot
p1 <- ggplot(df_mean, aes(x = a_sdp, y = l_mean)) +
  geom_line(size = 1, colour = "#beaed4") +
  geom_ribbon(aes(ymin = l_low, ymax = l_hi), fill = "#beaed4", alpha = "0.3") +
  theme_minimal() +
  theme(legend.position = "none", text = element_text(size = 18)) +
  labs(x = expression(a[sdp]), y = "Characteristic path") +
  scale_x_continuous(breaks = c(0, 0.0001, 0.0002),
                     labels = function(x) format(x, scientific = FALSE)) +
  ylim(0, 5)

p2 <- ggplot(df_mean, aes(x = a_sdp, y = c_mean)) +
  geom_line(size = 1, colour = "#beaed4") +
  geom_ribbon(aes(ymin = c_low, ymax = c_hi), fill = "#beaed4", alpha = "0.3") +
  theme_minimal() +
  theme(legend.position = "none", text = element_text(size = 18)) +
  labs(x = expression(a[sdp]), y = "Clustering coefficient") +
  scale_x_continuous(breaks = c(0, 0.0001, 0.0002),
                     labels = function(x) format(x, scientific = FALSE)) +
  ylim(0, 1)

p3 <- ggplot(df_mean, aes(x = a_sdp, y = q_mean)) +
  geom_line(size = 1, colour = "#beaed4") +
  geom_ribbon(aes(ymin = q_low, ymax = q_hi), fill = "#beaed4", alpha = "0.3") +
  theme_minimal() +
  theme(legend.position = "none", text = element_text(size = 18)) +
  labs(x = expression(a[sdp]), y = "Weighted modularity") +
  scale_x_continuous(breaks = c(0, 0.0001, 0.0002),
                     labels = function(x) format(x, scientific = FALSE)) +
  ylim(0, 1)

p4 <- ggplot(df_mean, aes(x = a_sdp, y = r_mean)) +
  geom_line(size = 1, colour = "#beaed4") +
  geom_ribbon(aes(ymin = r_low, ymax = r_hi), fill = "#beaed4", alpha = "0.3") +
  theme_minimal() +
  theme(legend.position = "none", text = element_text(size = 18)) +
  labs(x = expression(a[sdp]), y = "Assortativity coefficient") +
  scale_x_continuous(breaks = c(0, 0.0001, 0.0002),
                     labels = function(x) format(x, scientific = FALSE)) +
  ylim(-1, 1)

plot_grid(p1, p2, p3, p4, ncol = 4, nrow = 1, scale = 0.9)

