library(datasets)
library(plotly)
library(lubridate)

library(caret)
library(quantmod)
library(ElemStatLearn)

dtSrc <- data.frame(Seatbelts)
dtSrc$t <- date_decimal(as.vector(time(Seatbelts[,0])))

introductionHistorical <- as.POSIXct('1983-01-31', tz = "UTC")
dtSrc$mkm <- dtSrc$kms / 1000
dtSrc$month = factor(month(dtSrc$t))
dtSrc$law = dtSrc$law == TRUE

## Models
modelDriversInjured <- train(drivers ~ law * mkm + month, method="gbm", data = dtSrc, verbose = FALSE)

introductionSim <- as.POSIXct('1978-01-31', tz = "UTC")

dtSim <- data.frame(
  t = dtSrc$t,
  month = dtSrc$month,
  PetrolPrice = dtSrc$PetrolPrice,
  mkm = dtSrc$mkm,
  law = (introductionSim < dtSrc$t)
)
dtSim <- dtSim[dtSim$law == TRUE,]

dtSim$drivers <- predict(modelDriversInjured, dtSim)

plot <- plot_ly(dtSrc, x = ~t, y = ~drivers, name = 'Historical', type = 'scatter', mode = 'lines+markers', line = list(color='grey')) %>%
  add_trace(x = dtSim$t, y = dtSim$drivers, name = 'Simulated', type = 'scatter', mode = 'lines+markers', line = list(color='black')) %>%
  add_trace(x = introductionSim, y=c(0,max(dtSim$drivers, dtSrc$drivers)), name = "Compulsory seat belts (simulated)", mode = "lines", line = list(color='red')) %>%
  layout(title = "Total number of drivers killed or seriously injured monthly", yaxis = list(title = "drivers killed or seriously injured"), showlegend=TRUE)

plot
