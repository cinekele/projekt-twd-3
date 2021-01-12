library(shiny)
library(DT)
library(png)
library(plotly)

shinyUI(fluidPage(

    titlePanel("My"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("DatesMerge",
                        "Dates:",
                        min = as.Date("2020-12-20","%Y-%m-%d"),
                        max = as.Date("2021-01-21","%Y-%m-%d"),
                        value=c(as.Date("2020-12-21"), as.Date("2020-12-22")),
                        timeFormat="%Y-%m-%d",
                        animate = TRUE),

            fluidRow(
                column(5,imageOutput("mouse", height = 150)),
                column(5,imageOutput("key", height = 150))
            )

        ),

        mainPanel(
            plotOutput("plot_clicks"),
            plotOutput("application", width = 900)
        )
    )
))
