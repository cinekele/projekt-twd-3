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
    
    rv <- reactiveValues(
        appName = "firefox"
    )

    
    output$xd <- renderDataTable({
        data %>% 
            filter(between(date, input$DatesMerge[1], input$DatesMerge[2]))
    })
    
    output$plot_clicks <- renderPlot({
        d <- data %>% 
            filter(between(date, input$DatesMerge[1], input$DatesMerge[2])) %>%
            filter(title == rv[["appName"]]) %>%
            replace_na(list(keys = 0, lmb = 0, rmb = 0, scrollwheel=0))
        ggplot(d) +
            geom_line(aes(x=date, y=keys), size=2, color = "blue") +
            geom_line(aes(x=date, y=lmb), size=2, color = "red") +
            geom_line(aes(x=date, y=rmb), size=2, color = "green") +
            geom_line(aes(x=date, y=scrollwheel), size=2, color = "yellow") +
            scale_x_date(date_breaks = "days", date_labels = "%d %b")+
            ylim(0,NA)
    })

    output$mouse <- renderImage({
            return(list(
                src = "../img/mouse.png",
                filetype = "image/png",
                alt = "Mouse"
            ))
        
    }, deleteFile = FALSE)
    output$key <- renderImage({
        return(list(
            src = "../img/key.png",
            filetype = "image/png",
            alt = "Key"
        ))
        
    }, deleteFile = FALSE)
})
