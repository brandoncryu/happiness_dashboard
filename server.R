function(input, output, session) {
  


  
  react_data <- reactive({
    map_happiness = happiness %>%
      select(c('year','Score','Country','code',input$happiness_features)) %>%
      filter(year == input$worldmap_year)
    
    map_happiness %>%
      mutate(Score = rowSums(.[5:length(map_happiness)], na.rm=TRUE)) %>%
      arrange(desc(Score))
  })
  
  output$worldmap <- renderPlotly({
    react_data() %>%
      plot_geo() %>%
          add_trace(z = ~Score, 
                    color = ~Score,
                    colors = 'Greens', 
                    text = ~Country, 
                    locations = ~code, 
                    marker = list(line = l)
          ) %>%
          colorbar(title = 'Score') %>%
          layout(title = 'Happiness Score' ,geo = g)
  })
  
  output$data_happiness = DT::renderDataTable({
    react_data() %>%
      select(-year, -code)
  })
  
  
  happiness_scatter = reactive({
    happiness_scatter = happiness %>%
      filter(!is.na(get(input$var1)),
             !is.na(get(input$var2)),
             year %in% as.numeric(input$variables_year)
      )
  })
  
  output$scatter = renderPlotly(
    happiness_scatter() %>%
      plot_ly(x= ~get(input$var1), 
              y= ~get(input$var2),
              color= ~region,
              text= ~paste("Country: ",Country, "\nYear: ",year),
              type='scatter',
              mode='markers'
              ) %>%
      add_trace(x= ~get(input$var1),
                y=fitted(lm(get(input$var2)~get(input$var1), data=happiness_scatter())),
                mode = "lines") %>%
      layout(
        title = paste(input$var1, 'vs', input$var2),
        xaxis = list(title = input$var1),
        yaxis = list(title = input$var2)
      )
  )
  
  output$trend = renderPlotly(
    happiness %>%
      filter(region == input$region,
             Country %in% input$region_country) %>%
      plot_ly(x=~year,
              y=~get(input$trend_variable), 
              color=~Country,
              type='scatter',
              mode='lines',
              text = ~paste("Country: ",Country)) %>%
      layout(
        title = paste('Yearly Trend of',input$trend_variable),
        yaxis = list(title = input$trend_variable),
        xaxis = list(title = 'Year',
                     dtick=1)
      )
      
  )
  
  observeEvent(input$region,
               updateSelectizeInput(session, 'region_country',
                                        choices = c(sort(unique(happiness$Country[happiness$region==input$region])))
               )
  )
    
}