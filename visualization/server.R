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
    
    output$application <- renderPlot({
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
            ggplot(aes(x =  reorder(title, -sum_duration), y = sum_duration)) +
            geom_col() +
            geom_image(aes(x = title, image = image), y = -3,
                       size = 0.17, hjust = 1, inherit.aes = FALSE) +
            coord_flip(clip = "off", expand = FALSE) + 
            labs(x = "") +
            theme_classic() +
            theme(plot.title = element_text(hjust = 0, size = 26),
                  axis.ticks.y = element_blank(),
                  axis.text.y  = element_blank(),
                  plot.margin = margin(1, 1, 1, 4, "cm"))
        })
    
    rv <- reactiveValues(
        appName = "firefox"
    )
    
    output$plot_clicks <- renderPlot({
        d <- filtered_data() %>%
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
