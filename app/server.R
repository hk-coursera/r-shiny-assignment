library(datasets)
library(shiny)
library(plotly)
library(lubridate)
library(caret)
library(quantmod)
library(ElemStatLearn)
library(gbm)

dtSrc <- data.frame(Seatbelts)
dtSrc$t <- date_decimal(as.vector(time(Seatbelts[,0])))

introductionHistorical <- as.POSIXct('1983-01-31', tz = "UTC")
dtSrc$mkm <- dtSrc$kms / 1000
dtSrc$injPkm <- (dtSrc$drivers + dtSrc$front + dtSrc$rear) / dtSrc$mkm
dtSrc$injPkmDrv <- dtSrc$drivers / dtSrc$mkm
dtSrc$killedPkmDrv <- dtSrc$DriversKilled / dtSrc$mkm
dtSrc$month = factor(month(dtSrc$t))
dtSrc$law = dtSrc$law == TRUE

## Models
modelDriversInjured <- train(drivers ~ law * mkm + month, method="gbm", data = dtSrc, verbose = FALSE)
modelDriversKilled <- train(DriversKilled ~ law * mkm + month, method="gbm", data = dtSrc, verbose = FALSE)

shinyServer(function(input, output) {
  rv <- reactiveValues(
    doResim = FALSE,
    dtSim = data.frame()
  )

  observeEvent(input$resim, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    rv$doResim <- input$resim

    rv$dtSim <- data.frame(
      t = dtSrc$t,
      month = dtSrc$month,
      PetrolPrice = dtSrc$PetrolPrice,
      mkm = dtSrc$mkm,
      law = (input$introductionSim < dtSrc$t)
    )
    rv$dtSim <- rv$dtSim[rv$dtSim$law == TRUE,]

    rv$dtSim$drivers <- predict(modelDriversInjured, rv$dtSim)
    #rv$dtSim$injPkmDrv <- rv$dtSim$drivers / rv$dtSim$mkm

    rv$dtSim$DriversKilled <- predict(modelDriversKilled, rv$dtSim)
    #rv$dtSim$killedPkmDrv <- rv$dtSim$DriversKilled / rv$dtSim$mkm
  })

  ## Simulation Tab
  output$plotInjuriesSim <- renderPlotly({
    if (rv$doResim == FALSE) return()
    isolate({
      plot_ly(dtSrc, x = ~t, y = ~drivers, name = 'Historical', type = 'scatter', mode = 'lines+markers', line = list(color='grey')) %>%
        add_trace(x = rv$dtSim$t, y = rv$dtSim$drivers, name = 'Simulated', type = 'scatter', mode = 'lines+markers', line = list(color='black')) %>%
        add_trace(x = input$introductionSim, y=c(0,max(rv$dtSim$drivers, dtSrc$drivers)), name = "Compulsory seat belts", mode = "lines", line = list(color='red')) %>%
        layout(title = '', yaxis = list(title = "drivers killed or seriously injured"), showlegend=FALSE)
    })
  })
  output$plotKilledSim <- renderPlotly({
    if (rv$doResim == FALSE) return()
    isolate({
      plot_ly(dtSrc, x = ~t, y = ~DriversKilled, name = 'Historical', type = 'scatter', mode = 'lines+markers', line = list(color='grey')) %>%
        add_trace(x = rv$dtSim$t, y = rv$dtSim$DriversKilled, name = 'Simulated', mode = 'lines+markers', line = list(color='black')) %>%
        add_trace(x = input$introductionSim, y=c(0,max(rv$dtSim$DriversKilled, dtSrc$DriversKilled)), name = "Compulsory seat belts", mode = "lines", line = list(color='red')) %>%
        layout(title = '', yaxis = list(title = "drivers killed"), showlegend=FALSE)
    })
  })

  ## Historical Tab
  isolate({
    output$plotInjuriesHistoricalPkm <- renderPlotly({
      plot_ly(dtSrc, x = ~t, y = ~drivers/mkm, name = 'drivers', type = 'scatter', mode = 'lines+markers') %>%
        add_trace(y = ~injPkm, name = 'all', mode = 'lines+markers') %>%
        add_trace(y = ~front/mkm, name = 'front-seat passengers', mode = 'lines+markers') %>%
        add_trace(y = ~rear/mkm, name = 'rear-seat passengers', mode = 'lines+markers') %>%
        add_trace(x = introductionHistorical, y=c(0,max(dtSrc$injPkm)), name = "1983-01-31: introduction\nof compulsory seat\nbelts wearing", mode = "lines", line = list(color='red')) %>%
        layout(title = "Killed or seriously injured monthly (per M.km) ", yaxis = list(title = "per M.km"))
    })
    output$plotKilledHistoricalPkm <- renderPlotly({
      plot_ly(dtSrc, x = ~t, y = ~killedPkmDrv, name = 'car drivers killed', type = 'scatter', mode = 'lines+markers') %>%
        add_trace(y = ~VanKilled/mkm, name = 'van drivers killed', mode = 'lines+markers') %>%
        add_trace(x = introductionHistorical, y=c(0,max(dtSrc$killedPkmDrv)), name = "1983-01-31: introduction\nof compulsory seat\nbelts wearing", mode = "lines", line = list(color='red')) %>%
        layout(title = "Killed monthly (per M.km)", yaxis = list(title = "per M.km"))
    })
    output$plotmkmHistorical <- renderPlotly({
      plot_ly(dtSrc, x = ~t, y = ~mkm, name = 'Distance driven', type = 'scatter', mode = 'lines+markers', line = list(color='grey')) %>%
        add_trace(x = introductionHistorical, y=c(0,max(dtSrc$mkm)), name = "1983-01-31: introduction\nof compulsory seat\nbelts wearing", mode = "lines", line = list(color='red')) %>%
        layout(title = "Distance driven (in millions of km)", yaxis = list(title = "M.km"))
    })
    output$plotPetrolPriceHistorical <- renderPlotly({
      plot_ly(dtSrc, x = ~t, y = ~PetrolPrice, name = 'Petrol Price', type = 'scatter', mode = 'lines+markers', line = list(color='grey')) %>%
        add_trace(x = introductionHistorical, y=c(0,max(dtSrc$PetrolPrice)), name = "1983-01-31: introduction\nof compulsory seat\nbelts wearing", mode = "lines", line = list(color='red')) %>%
        layout(title = "Petrol Price", yaxis = list(title = ""))
    })
  })
})

