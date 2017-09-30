library(shiny)
library(plotly)
library(miniUI)

shinyUI(navbarPage("Shiny Project",
  tabPanel("Documentation",
          h3("H3"),
          p("PARAGRAPH 1"), br(),
          p("PARAGRAPH 2"), br(),
          tags$ol(
            tags$li("li1"),
            tags$li("li2"),
            tags$li("li3"),
            tags$li("li4")
          )
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
    fluidRow(column(12, h4("Simulated plot of car drivers injured monthly"), plotlyOutput("plotInjuriesSim"))),
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
