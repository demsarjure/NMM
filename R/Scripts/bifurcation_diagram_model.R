# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(pracma)

# working directory
setwd("D:/Projects/nmm/R/Results/")

# data
parameters <- data.frame(t(fread("bifurcation/bifurcation_parameters.csv", sep = ",", header = FALSE)))
names(parameters) <- c("mu")

e <- data.frame(fread("bifurcation/E_model.csv", sep = ",", header = FALSE))

df <- data.frame(mu = numeric(), y = numeric(), type = character())

# calculate and prep data for plotting
iterations <- nrow(parameters)
for (i in 1:iterations) {
  data_vector <- as.vector(t(e[i, ]))
  if (!any(is.na(data_vector))) {
    peaks <- findpeaks(data_vector)[, 1]
    if (is.null(peaks)) {
      peaks <- rep(max(data_vector), 1000)
      troughs <- rep(0, 1000)
    }
    else
      troughs <- -findpeaks(-data_vector)[, 1]
    df <- rbind(
      df,
      data.frame(
        mu = parameters$mu[i],
        y = c(peaks, troughs)
      )
    )
  }
}

# plot
ggplot(df, aes(x = mu, y = y)) +
  geom_point(colour = "#3182bd", alpha = 0.05, size = 3, stroke = 0, shape = 16) +
  ylim(0, 0.1) +
  theme_minimal() +
  labs(x = expression(mu), y = "Node activity") +
  theme(panel.spacing = unit(4, "lines")) +
  theme(text = element_text(size = 18))
