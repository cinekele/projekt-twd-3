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
            filter(between(date, input$DatesMerge[1], input$DatesMerge[2]))
    })
    
    output$application <- renderPlotly({
        filtered_data() %>%
            filter(name == "Adam") %>%
            left_join(icons, by = "title") %>%
            group_by(title) %>%
            arrange(date) %>%
            mutate(duration = 60*hours(times(time)) + minutes(times(time)) + 1/60*seconds(times(time))) %>%
            transmute(sum_duration = sum(duration), image) %>%
            distinct() %>%
            arrange(desc(sum_duration)) %>%
            head(5) %>%
            # ggplot(aes(x =  reorder(title, -sum_duration), y = sum_duration)) +
            # geom_col() +
            # geom_image(aes(x = title, image = image), y = -3,
            #            size = 0.17, hjust = 1, inherit.aes = FALSE) +
            # coord_flip(clip = "off", expand = FALSE) + 
            # labs(x = "") +
            # theme_classic() +
            # theme(plot.title = element_text(hjust = 0, size = 26),
            #       axis.ticks.y = element_blank(),
            #       axis.text.y  = element_blank(),
            #       plot.margin = margin(1, 1, 1, 4, "cm"))
            plot_ly(y = ~reorder(title, sum_duration), x = ~sum_duration, type = "bar", 
                    orientation = 'h', source = "application") %>%
                layout(xaxis = list(title = "Time in minutes"),
                       yaxis = list(title = list(text = "Application", standoff = 0)))
        })
    
    application <- reactiveVal()
    
    observeEvent(event_data("plotly_click", source = "application"), {
        application(event_data("plotly_click", source = "application")$y)
    })
    
    output$plot_clicks <- renderPlotly({
        if (is.null(application())) return(NULL)
        d <- filtered_data() %>%
            filter(name == "Adam") %>%
            filter(title == application()) %>%
            replace_na(list(keys = 0, lmb = 0, rmb = 0, scrollwheel=0))
        plot_ly(d, x = ~reorder(date, date), colors = c("Keys" = "blue",
                                                        "LMB" = "red",
                                                        "RMB" = "green",
                                                        "Scroll" = "yellow")) %>%
            add_trace(y = ~keys, type = "scatter", mode = "markers+lines", color = "Keys") %>%
            add_trace(y = ~lmb, type = "scatter", mode = "markers+lines", color = "LMB") %>%
            add_trace(y = ~rmb, type = "scatter", mode = "markers+lines", color = "RMB") %>%
            add_trace(y = ~scrollwheel, type = "scatter", mode = "markers+lines", color = "Scroll") %>%
            layout(title = list(text = application()))
            # scale_x_date(date_breaks = "days", date_labels = "%d %b") %>%
            # ylim(0,NA)
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
