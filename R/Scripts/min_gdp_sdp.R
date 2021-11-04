# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(cowplot)
library(data.table)

# working directory
setwd("D:/Projects/nmm/R/Results")

# real values of metrics
# characteristic path
l <- 4.15
# clustering coefficient
c <- 0.19
# modularity
q <- 0.34
# assortativity coefficient
r <- 0.03
# degree
deg <- 27.6

# folder
fileName <- paste0("real/M_metrics_real.csv")

# data
df <- data.frame(fread(fileName, sep = ",", header = FALSE))
names(df) <- c("a_sdp", "b_sdp", "c_gdp", "l", "c", "q", "r", "deg")

# remove NaNs
df <- df[complete.cases(df), ]

min_diff <- .Machine$double.xmax
a_sdp <- 0
b_sdp <- 0
c_gdp <- 0

# interval ranges
n <- 90
max_l <- n  / 4 # approximal worst case
max_c <- 1
max_q <- 1
max_r <- 1
max_deg <- n - 1

# switches
l_on <- 1
c_on <- 1
q_on <- 1
r_on <- 1
deg_on <- 0

# get number of rows
n <- nrow(df)
for (i in 1:n)
{
  diff <- (abs((df$l[i] - l) / max_l) * l_on +
    abs((df$c[i] - c) / max_c) * c_on +
    abs((df$q[i] - q) / max_q) * q_on +
    abs((df$r[i] - r) / max_r) * r_on +
    abs((df$deg[i] - deg) / max_deg) * deg_on)

  if (is.nan(diff))
    diff <- 1

  df$diff[i] <- diff

  if (diff < min_diff) {
    min_diff <- diff
    a_sdp <- df$a_sdp[i]
    b_sdp <- df$b_sdp[i]
    c_gdp <- df$c_gdp[i]
  }
}

# store in df_all
df_all <- df

# use the metrics_real_range.R script to plot this
