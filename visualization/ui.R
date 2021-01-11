#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(png)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("DatesMerge",
                        "Dates:",
                        min = as.Date("2020-12-20","%Y-%m-%d"),
                        max = as.Date("2021-01-21","%Y-%m-%d"),
                        value=c(as.Date("2020-12-21"), as.Date("2020-12-22")),
                        timeFormat="%Y-%m-%d",
                        animate = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            dataTableOutput("xd"),
            plotOutput("plot_clicks"),
            imageOutput("mouse"),
            imageOutput("key", height = 100)
        )
    )
))
