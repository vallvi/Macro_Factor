library(dplyr)
library(tidyr)
library(ggplot2)
library(stats)
library(zoo)

save(oil_df, file = "Oil_df.rda")

oil_df$Price <-  as.numeric(levels(oil_df$Price))[oil_df$Price]

oil_df$Month <- as.Date(as.yearmon(oil_df$Date))

futures_df <- oil_df[1:4000,] %>%
  group_by(Month) %>% 
  summarise("Monthly Average" = mean(Price)) %>% 
  ggplot(aes(`Month`, `Monthly Average`))+
  geom_point()+
  xlim(as.Date('2017-01-01'), as.Date('2017-10-01')) +
  stat_smooth(aes(x = `Month`, y = `Monthly Average`), method = "auto", col = "red", fullrange = TRUE)+
  geom_line(aes(x = `Month`, y = fit1$fitted)) +
  theme(axis.text = element_text(angle = 90, hjust = 1))

futures_df$future <- 1:nrow(futures_df)

fit1 <- loess(futures_df$`Monthly Average` ~ futures_df$future)

smooth_future <- predict(fit1)
