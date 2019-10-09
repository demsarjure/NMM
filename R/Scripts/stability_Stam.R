# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(dplyr)

# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df_stability <- data.frame(fread("stability/Stam_extensive.csv", sep = ",", header = FALSE))
names(df_stability) <- c("instability", "a_sdp", "a_gdp")

df_mean <- df_stability %>%
  group_by(a_sdp, a_gdp) %>%
  summarize(mean=mean(instability),
            low=quantile(instability, 0.025),
            high=quantile(instability, 1-0.025))

ggplot(df_mean, aes(y = mean, x = a_sdp)) +
  geom_ribbon(aes(ymin=low, ymax = high), fill="#3182bd", alpha=0.4) +
  geom_line(size = 1, color="#3182bd") +
  theme_minimal() +
  scale_x_continuous(breaks=c(0.0001, 0.0025, 0.005, 0.0075, 0.01),
                     labels=c("0.0001/0.00001",
                              "0.0025/0.00025",
                              "0.005/0.0005",
                              "0.0075/0.00075",
                              "0.01/0.001")) +
  labs(x = expression(a[sdp] / a[gdp]), y = "Instability") +
  theme(legend.title = element_blank(), text = element_text(size = 18)) +
  ylim(0, 1)

  