function(input, output, session) {
  
  observeEvent(input$worldmap_year, {
    cat(input$worldmap_year)
  })
  observeEvent(input$vae1, {
    cat(input$var1)
  })
  
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
  
  output$scatter = renderPlotly(
    happiness %>%
      plot_ly(x= ~get(input$var1), 
              y= ~get(input$var2),
              color= ~continent,
              text= ~paste("Country: ",Country),
              type='scatter',
              mode='markers'
              ) %>%
      layout(
        title = paste(input$var1, 'vs', input$var2),
        xaxis = list(title = input$var1),
        yaxis = list(title = input$var2)
      )
  )
    
}

# happiness %>%
#   plot_ly(x=~Score, y=~GDP.per.capita)
