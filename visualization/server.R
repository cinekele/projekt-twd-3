library(shiny)
library(dplyr)
library(tidyverse)
library(plotly)
library(chron)
library(ggimage)

shinyServer(function(input, output) {
    data <- read_csv2("data.csv")
    icons <- data.frame(title = c("chrome"),
                        image = c("icons/chrome.png"))
    
    #output$xd <- renderDataTable({
    #filtered_data()
    #})
    
    filtered_data <- reactive({
        data %>% 
            filter(between(date, input$DatesMerge[1], input$DatesMerge[2])) %>%
            mutate(duration = 60*hours(times(time)) + minutes(times(time)) + 1/60*seconds(times(time)))
    })
    
    output$application <- renderPlotly({
        if (is.null(input$nameButton)) return(NULL)
        filtered_data() %>%
            filter(name %in%  input$nameButton) %>%
            left_join(icons, by = "title") %>%
            group_by(title) %>%
            arrange(date) %>%
            mutate(duration = 60*hours(times(time)) + minutes(times(time)) + 1/60*seconds(times(time))) %>%
            transmute(sum_duration = sum(duration), image) %>%
            distinct() %>%
            arrange(desc(sum_duration)) %>%
            head(10) %>%
            plot_ly(y = ~reorder(title, sum_duration), x = ~sum_duration/60, type = "bar", 
                    orientation = 'h', source = "application", marker = list(color = "forestgreen")) %>%
                layout(xaxis = list(title = "Time in hours"),
                       yaxis = list(title = list(text = "Application", standoff = 0)),
                       margin = list(l=350))
        })
    
    application <- reactiveVal()
    
    observeEvent(event_data("plotly_click", source = "application"), {
        application(event_data("plotly_click", source = "application")$y)
    })
    
    output$plot_clicks <- renderPlotly({
        if (is.null(application())) return(NULL)
        if (is.null(input$nameButton)) return(NULL)
        d <- filtered_data() %>%
            filter(name %in% input$nameButton) %>%
            filter(title == application()) %>%
            replace_na(list(keys = 0, lmb = 0, rmb = 0, scrollwheel=0)) %>%
            group_by(date, title) %>%
            summarise(keys = sum(keys), lmb = sum(lmb), rmb = sum(rmb), scrollwheel = sum(scrollwheel)) %>%
            ungroup()%>%
            arrange(date)
        
        plot_ly(d, x = ~date, colors = c("Keys" = "blue",
                                         "LMB" = "red",
                                         "RMB" = "green",
                                         "Scroll" = "yellow")) %>%
            add_trace(y = ~keys, type = "scatter", mode = "markers+lines", color = "Keys") %>%
            add_trace(y = ~lmb, type = "scatter", mode = "markers+lines", color = "LMB") %>%
            add_trace(y = ~rmb, type = "scatter", mode = "markers+lines", color = "RMB") %>%
            add_trace(y = ~scrollwheel, type = "scatter", mode = "markers+lines", color = "Scroll") %>%
            layout(title = list(text = application()), 
                   xaxis = list(type = "date", tickformat = "%d %b (%a)<br>%Y"))
    })
    
    output$app_activity <- renderPlotly({
        if (is.null(application())) return(NULL)
        if (is.null(input$nameButton)) return(NULL)
        d <- filtered_data() %>%
            filter(name %in% input$nameButton) %>%
            filter(title == application()) %>%
            group_by(date, title) %>%
            summarise(duration = sum(duration)) %>%
            ungroup()%>%
            arrange(date)
        plot_ly(d, x = ~date, y = ~duration) %>%
            add_trace(type = "scatter", mode = "markers+lines") %>%
            layout(title = list(text = application()), 
                   xaxis = list(type = "date", tickformat = "%d %b (%a)<br>%Y"))
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
