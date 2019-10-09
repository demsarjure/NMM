# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)

# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df_model <- data.frame(fread("stability/model.csv", sep = ",", header = FALSE))
names(df_model) <- c("weight")
df_model$type <- "Our model"
df_model$index <- seq(2000)

df_stam <- data.frame(fread("stability/stam.csv", sep = ",", header = FALSE))
names(df_stam) <- c("weight")
df_stam$type <- "Stam et al."
df_stam$index <- seq(2000)

df <- rbind(df_model, df_stam)

palette <- c("#3182bd","#ff4e3f")

ggplot(df, aes(x = index, y = weight, colour = type)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(x = "Time", y = "Connection weight") +
  scale_colour_manual(values = palette) +
  theme(legend.title = element_blank(), text = element_text(size = 18)) +
  ylim(0, 1)
