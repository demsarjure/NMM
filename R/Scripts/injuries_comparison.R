# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(dplyr)
library(tidyr)


# working directory
setwd("D:/Projects/nmm/R/Results")

# load values
df_healthy <- data.frame(fread("injury/metrics_connectome.csv", sep = ",", header = FALSE))
names(df_healthy) <- c("Characteristic path", "Clustering coefficient", "Weighted modularity", "Assortativity coefficient", "deg")
df_healthy$Type <- "Healthy"

df_focal <- data.frame(fread("injury/metrics_focal.csv", sep = ",", header = FALSE))
names(df_focal) <- c("Characteristic path", "Clustering coefficient", "Weighted modularity", "Assortativity coefficient", "deg")
df_focal$Type <- "Focal"

df_diffuse <- data.frame(fread("injury/metrics_diffuse.csv", sep = ",", header = FALSE))
names(df_diffuse) <- c("Characteristic path", "Clustering coefficient", "Weighted modularity", "Assortativity coefficient", "deg")
df_diffuse$Type <- "Diffuse"

# drop degree
df_healthy <- df_healthy %>% select(-deg)
df_focal <- df_focal %>% select(-deg)
df_diffuse <- df_diffuse %>% select(-deg)

# format
df_all <- rbind(df_focal, df_diffuse, df_healthy)

df_all <- df_all %>% gather(Metric, Value, "Characteristic path", "Clustering coefficient", "Weighted modularity", "Assortativity coefficient")

# plot
ggplot(data=df_all, aes(x=Type, y=Value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  facet_wrap(. ~ Metric, scales="free", nrow=1) +
  theme_minimal() +
  xlab("") +
  theme(panel.spacing = unit(2, "lines")) +
  theme(text=element_text(size=14))
  
       