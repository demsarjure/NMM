# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(dplyr)

# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df_stability <- data.frame(fread("stability/a_ss_stability.csv", sep = ",", header = FALSE))
names(df_stability) <- c("instability", "a_ss")

df_mean <- df_stability %>%
  group_by(a_ss) %>%
  summarize(mean=mean(instability),
            low=quantile(instability, 0.025),
            high=quantile(instability, 1-0.025))

ggplot(df_stability, aes(y = instability, x = a_ss)) +
  geom_point(alpha=0.4, shape=16) +
  geom_smooth(method="loess", color="#3182bd", fill="#3182bd", alpha=0.2) +
  theme_minimal() +
  labs(x = expression(a[ss]), y = "Instability") +
  coord_cartesian(ylim = c(0,1))
