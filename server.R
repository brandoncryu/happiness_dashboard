function(input, output, session) {
  
  # World Map page
  # Create reactive data frame to use for world map and data table
  react_data <- reactive({
    map_happiness = happiness %>%
      select(c('year','Score','Country','code',input$happiness_features,'Dystopia.Residual')) %>%
      filter(year == input$worldmap_year)
    
    map_happiness %>%
      mutate(Score = rowSums(.[5:length(map_happiness)], na.rm=TRUE)) %>%
      arrange(desc(Score))
  })
  
  # Create output plot of world map
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
  
  # Create output data table from reactive data frame
  output$data_happiness = DT::renderDataTable({
    react_data() %>%
      select(-year, -code)
  })
  
  
  
  # Explore page -> VARIABLES tab
  # Create reactive data frame for scatter plots
  happiness_scatter = reactive({
    happiness_scatter = happiness %>%
      filter(!is.na(get(input$var1)),
             !is.na(get(input$var2)),
             year %in% as.numeric(input$variables_year)
      )
  })
  
  # Create output scatter plot 
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
                color='',
                mode = "lines",
                name = 'Predicted') %>%
      layout(
        title = paste(input$var1, 'vs', input$var2),
        xaxis = list(title = input$var1),
        yaxis = list(title = input$var2)
      )
  )
  
  # output for correlation
  output$correlation = renderText({
    x=happiness_scatter() %>%
      select(input$var1)
    y=happiness_scatter() %>%
      select(input$var2)
    corr = round(cor(x, y), digits = 5)
    
    paste('Correlation:',as.character(corr))
  })
  
  # Explore page -> TREND tab
  # Create output line graph for yearly trend
  output$trend = renderPlotly(
    happiness %>%
      filter(Country %in% input$countries,
             year %in% as.numeric(input$trends_variables_year)) %>%
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
  output$trend_table = DT::renderDataTable({
    start = happiness %>%
      filter(year == input$trends_variables_year[1]) %>%
      select('Score','code','Country')
    
    end = happiness %>%
      filter(year == tail(input$trends_variables_year,n=1)) %>%
      select('Score','code','Country')
    
    merge(start, end, by='code') %>%
      mutate(Increase=round(Score.y-Score.x,5)) %>%
      select(Country.x,Increase) %>%
      rename(Country = Country.x) %>%
      arrange(desc(Increase))
  })
  
  # Regional data table
  output$regional_scores = DT::renderDataTable({
    happiness_suicide %>%
      group_by_(input$region_or_continent) %>%
      summarise(Score = round(sum(Score*population)/sum(population),3)) %>%
      arrange(desc(Score))
  })

  
  
  # Observe relationship of happiness scores and suicides
  output$suicide = renderPlotly(
    happiness_suicide %>%
      plot_ly(
        x= ~get(input$var3),
        y= ~suicides.100k.pop,
        type='scatter'
      ) %>%
      layout(
        title = paste(input$var3, 'vs Suicide Rates'),
        xaxis = list(title = input$var3)
      )
  )
  # output for suicide correlation
  output$suicide_correlation = renderText({
    x=happiness_suicide %>%
      select(input$var3)
    y=happiness_suicide %>%
      select(suicides.100k.pop)
    corr = round(cor(x, y), digits = 5)
    
    paste('Correlation:',as.character(corr))
  })
}