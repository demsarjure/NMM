# run min_gdp_gdp frst to get the data frame!

# filter
df <- df_all
df <- df[df$a_sdp >= 0.0003 & df$a_sdp <= 0.0006,]
df <- df[df$b_sdp >= 10 & df$b_sdp <= 18,]
df <- df[df$c_gdp >= 0.2 & df$c_gdp <= 0.4,]

# melt
df <- melt(df)

p_l <- ggplot(df[df$variable == "l", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = l, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Characteristic path", y = "") +
  ylim(0, 20)

p_c <- ggplot(df[df$variable == "c", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = c, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Clustering coefficient", y = "") +
  ylim(0, 1)

p_q <- ggplot(df[df$variable == "q", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = q, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Weighted modularity", y = "") +
  ylim(0, 1)

p_r <- ggplot(df[df$variable == "r", ], aes(x = variable, y = value)) +
  geom_boxplot(colour = "grey25", fill = "#beaed4") +
  geom_hline(yintercept = r, color="grey50", linetype="11", size = 1) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(x = "Assortativity coefficient", y = "") +
  ylim(-1, 1)

# p_deg <- ggplot(df[df$variable == "deg", ], aes(x = variable, y = value)) +
#   geom_boxplot(colour = "grey25", fill = "#beaed4") +
#   geom_hline(yintercept = deg, color="grey50", linetype="11", size = 1) +
#   theme_minimal() +
#   theme(axis.text.x = element_blank()) +
#   labs(x = "Mean network degree", y = "") +
#   ylim(0, 30)

plot_grid(p_l, p_c, p_q, p_r, ncol = 4, nrow = 1, scale = 0.9)
