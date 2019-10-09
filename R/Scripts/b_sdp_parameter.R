library(ggplot2)

a_sdp <- 0.0001
b_sdp <- 2
h_sdp <- 1^b_sdp

df <- NULL
for (b_sdp in seq(0.5, 8, 0.5)) {
  for (c in seq(-1, 1, 0.01)) {
    r <- (c + 1)^b_sdp
    w <- a_sdp * ((r / (r + h_sdp)) - 0.5)
    
    df <- rbind(df, data.frame(c=c, w=w, b_sdp=paste0("b_sdp = ", b_sdp)))
  }
}

ggplot(data = df, aes(x = c, y = w)) +
  geom_line(size = 1, colour = "#beaed4") +
  theme_minimal() +
  labs(x = "Correlation", y = "Weight change") +
  facet_wrap(~ b_sdp, ncol = 4) +
  scale_y_continuous(limits = c(-0.00005, 0.00005),
                     breaks = c(-0.00005, 0, 0.00005),
                     labels = function(x) format(x, scientific = FALSE))
  
