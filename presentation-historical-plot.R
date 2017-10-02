library(datasets)
library(plotly)
library(lubridate)
library(caret)
library(quantmod)

dtSrc <- data.frame(Seatbelts)
dtSrc$t <- date_decimal(as.vector(time(Seatbelts[,0])))
introductionHistorical <- as.POSIXct('1983-01-31', tz = "UTC")

plot <- plot_ly(dtSrc, x = ~t, y = ~drivers, name = 'drivers', type = 'scatter', mode = 'lines+markers') %>%
  add_trace(y = ~front, name = 'front-seat passengers', mode = 'lines+markers') %>%
  add_trace(y = ~rear, name = 'rear-seat passengers', mode = 'lines+markers') %>%
  add_trace(x = introductionHistorical, y=c(0,2500), name = "1983-01-31: introduction\nof compulsory seat\nbelts wearing", mode = "lines", line = list(color='red')) %>%
  layout(title = "Total number of killed or seriously injured monthly", yaxis = list(title = ""))

plot
