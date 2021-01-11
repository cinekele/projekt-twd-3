#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    data <- read_csv2("../data.csv")

    
    output$xd <- renderDataTable({
        data %>% 
            filter(between(date, input$DatesMerge[0], input$DatesMerge[1]))
    })

})
