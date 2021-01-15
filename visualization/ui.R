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
                selected = c("Adam", "Pawel", "Piotr"),
            ),

            fluidRow(
                column(6, align="center", imageOutput("mouse", height = 350)),
                column(6, align="center", imageOutput("key", height = 350))
            ),
            plotlyOutput("plot_clicks"),
            width = 6

        ),

        mainPanel(
            plotlyOutput("application", width = 900, height = 500),
            plotlyOutput("app_activity"),
            width = 6
        )
    )
))
