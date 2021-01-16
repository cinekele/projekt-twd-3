library(shiny)
library(shinyWidgets)
library(DT)
library(png)
library(plotly)

shinyUI(fluidPage(

    titlePanel("My"),

    fluidRow(
        column(
            sliderInput("DatesMerge",
                        "Dates:",
                        min = as.Date("2020-12-20","%Y-%m-%d"),
                        max = as.Date("2021-01-15","%Y-%m-%d"),
                        value=c(as.Date("2020-12-21"), as.Date("2021-01-10")),
                        timeFormat="%Y-%m-%d",
                        animate = TRUE,
                        width = 900),
            checkboxGroupButtons(
                inputId = "nameButton", label = "Osoby :",
                choiceNames = c(HTML("<p style=\"color:black;font-size:20px;background-color:blue\">Adam</p>"),
                                HTML("<p style=\"color:black;font-size:20px;background-color:brown\">Paweł</p>"),
                                HTML("<p style=\"color:black;font-size:20px;background-color:green\">Piotr</p>")),
                choiceValues = c("Adam", "Pawel", "Piotr"),
                justified = TRUE, status = "primary",
                checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon")),
                selected = c("Adam", "Pawel", "Piotr"),
            ),

            fluidRow(
                column(6, align="center", imageOutput("mouse", height = 350, click = "mouse_click")),
                column(6, align="center", imageOutput("key", height = 350, click = "key_click"))
            ),
            plotlyOutput("plot_clicks"),
            width = 6

        ),

        column(
            plotlyOutput("application", height = 500),
            plotlyOutput("app_activity"),
            width = 6
        )
    )
))
