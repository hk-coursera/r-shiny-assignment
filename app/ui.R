library(shiny)
library(plotly)
library(miniUI)

shinyUI(navbarPage("Shiny Project",
  tabPanel("Documentation",
          h3("Effect of seat belts wearing"),
          h4("Historical data"),
          p("Gives the monthly totals of car drivers in Great Britain killed or seriously injured and some other data for time period between Jan 1969 and Dec 1984. Compulsory wearing of seat belts was introduced on 31 Jan 1983."),
          br(),
          h4("Simulation Experiment"),
          p("Allows you to use model, trained on historical data, to simulate introduction of compulsory of seat belts wearing on different date. Simulates the monthly totals of car drivers in Great Britain killed or seriously injured and drivers killed after given date."),
          p("Set new date and click 'simulate' button to update plots.")
  ),

  tabPanel("Historical data",
           fluidRow(plotlyOutput("plotInjuriesHistoricalPkm")),
           tags$hr(),
           fluidRow(plotlyOutput("plotKilledHistoricalPkm")),
           tags$hr(),
           fluidRow(plotlyOutput("plotPetrolPriceHistorical")),
           tags$hr(),
           fluidRow(plotlyOutput("plotmkmHistorical"))
  ),

    tabPanel("Simulation Experiment",
     fluidRow(
      column(4, div(style = "height: 150px")),
      column(4, div(style = "height: 150px")),
      column(4, div(style = "height: 150px"))
    ),
    fluidRow(column(12, h4("Simulated plot of car drivers killed or seriously injured monthly"), plotlyOutput("plotInjuriesSim"))),
    tags$hr(),
    fluidRow(column(12, h4("Simulated plot of car drivers killed monthly"), plotlyOutput("plotKilledSim"))),
    tags$hr(),
    fluidRow(plotlyOutput("plotPetrolPriceSim")),
    absolutePanel(
      top = 50, left = 0, right =0,
      fixed = TRUE,
      wellPanel(
        fluidRow(
          column(1, actionButton("resim", "Simulate")),
          column(3, dateInput("introductionSim", "Simulate introduction of compulsory seat belts wearing in:",
                    value = as.POSIXct('1983-01-31', tz = "UTC"),
                    min = as.POSIXct('1969-01-01', tz = "UTC"),
                    max = as.POSIXct('1984-12-01', tz = "UTC"),
                    format = "yyyy-mm-dd", startview = "month", weekstart = 1, language = "en"))#,
          #column(4, sliderInput("petrolPriceScaleSim", "Scale petrol price:", min = 0.25, max = 4, value = 1, step = 0.25))
          #column(4, sliderInput("mkmScaleSim", "Scale traveled distance:", min = 0.25, max = 4, value = 1, step = 0.25))
        )
      )
    )
  )

))
