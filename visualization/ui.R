library(shiny)
library(shinyWidgets)
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
            checkboxGroupButtons(
                inputId = "nameButton", label = "Osoby :",
                choices = c("Adam", "Pawel", "Piotr"),
                justified = TRUE, status = "primary",
                checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon")),
                selected = "Adam",
            ),

            fluidRow(
                column(5,imageOutput("mouse", height = 150)),
                column(5,imageOutput("key", height = 150))
            )

        ),

        mainPanel(
            plotlyOutput("application", width = 900),
            plotlyOutput("app_activity"),
            plotlyOutput("plot_clicks")
        )
    )
))
