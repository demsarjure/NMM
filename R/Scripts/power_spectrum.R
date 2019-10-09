#
# plot power spectrum

# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(plyr)
library(cowplot)

# working directory
setwd("D:/Projects/nmm/R/Results/")

plot_power_spectrum <- function(file_pre, file_post, title)
{
  scaling <- 1000000 #10^-6
  max_y <- 5
  max_x <- 50
  
  df_pre <- data.frame(t(fread(file_pre)))
  names(df_pre) <- c("f", "p")
  df_pre$p <- log10(df_pre$p * scaling)
  df_pre$injury <- "Pre-injury"
  
  df_post <- data.frame(t(fread(file_post)))
  names(df_post) <- c("f", "p")
  df_post$p <- log10(df_post$p * scaling)
  df_post$injury <- "Post-injury"
  
  df <- rbind(df_pre, df_post)
  df$injury = factor(df$injury, levels=c("Pre-injury", "Post-injury"))
  
  df$p <- ifelse(df$p > max_y, max_y, df$p)
  
  ggplot(data = df, aes(x = f, y = p, colour = injury, fill = injury)) +
    geom_line(size = 1) +
    theme_minimal() +
    labs(x = "Frequency [Hz]", y = "log10 Power") +
    facet_grid(rows = vars(injury)) +
    scale_colour_manual(values = c("#beaed4", "#cc2714")) +
    scale_fill_manual(values = c("#beaed4", "#cc2714")) +
    theme(legend.title = element_blank(),
          legend.position = "none",
          text = element_text(size = 18)) +
    guides(colour = guide_legend(override.aes = list(colour = NA, alpha = 1))) +
    ggtitle(title) +
    theme(plot.title = element_text(hjust = 0.5)) +
    xlim(0, max_x) +
    ylim(-1, max_y)
}

p1 <- plot_power_spectrum("injury/PS_model_pre.csv", "injury/PS_model_post.csv", "Our model")
p2 <- plot_power_spectrum("injury/PS_stam_pre.csv", "injury/PS_stam_post.csv", "Stam et al.")

plot_grid(p1, p2, ncol = 2, nrow = 1, scale = 0.9)
