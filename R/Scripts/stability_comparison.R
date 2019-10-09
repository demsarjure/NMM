# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(dplyr)

# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df_stam <- data.frame(fread("stability/Stam_extensive.csv", sep = ",", header = FALSE))
names(df_stam) <- c("instability", "a_sdp", "a_gdp")

df_stam <- df_stam %>% filter(a_sdp == 0.01) %>% select("instability")
df_stam$model <- "Stam et al."

df_model <- data.frame(fread("stability/Model_extensive.csv", sep = ",", header = FALSE))
names(df_model) <- c("instability")
df_model$model <- "Our model"

df_stability <- rbind(df_stam, df_model)

df_mean <- df_stability %>%
  group_by(model) %>%
  summarize(mean=mean(instability),
            low=quantile(instability, 0.025),
            high=quantile(instability, 1-0.025))

ggplot(df_mean, aes(y = mean, x = model)) +
  geom_bar(fill="#3182bd", alpha=0.5, stat="identity", width = 0.5) +
  geom_errorbar(aes(ymin = low, ymax = high), width = 0.2, alpha = 0.4, size = 1) +
  theme_minimal() +
  labs(x = "", y = "Instability")


  