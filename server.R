function(input, output, session) {
  
  observeEvent(input$worldmap_year, {
    cat(input$worldmap_year)
  })
  observeEvent(input$happiness_features, {
    cat(input$happiness_features)
  })
  
  observeEvent(input$worldmap_year, {
    if (input$worldmap_year %in% c(2015,2016,2017)) {
      updateCheckboxGroupInput(session, 'happiness_features',
                               label="Select Data:",
                               list("GDP per Capita"="GDP.per.capita",
                                    "Health/Life Expectancy"="Healthy.life.expectancy",
                                    "Freedom to Make Life Choices"="Freedom.to.make.life.choices",
                                    "Generosity"="Generosity",
                                    "Perception of Corruption" = 'Perceptions.of.corruption',
                                    'Family' = 'Family',
                                    'Dystopia residual' = 'Dystopia.Residual'),
                               selected = c('GDP.per.capita','Healthy.life.expectancy','Freedom.to.make.life.choices','Generosity','Perceptions.of.corruption','Family','Dystopia.Residual')
      )
    } else {
      updateCheckboxGroupInput(session, 'happiness_features',
                               label="Select Data:",
                               choices=list("GDP per Capita"="GDP.per.capita",
                                            "Health/Life Expectancy"="Healthy.life.expectancy",
                                            "Freedom to Make Life Choices"="Freedom.to.make.life.choices",
                                            "Generosity"="Generosity",
                                            "Perception of Corruption" = 'Perceptions.of.corruption',
                                            'Social Support' = 'Social.support'),
                               selected = c('GDP.per.capita','Healthy.life.expectancy','Freedom.to.make.life.choices','Generosity','Perceptions.of.corruption','Social.support')
      )
    }
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
  
  map_top10 <- reactive({
    react_data() %>%  
      top_n(10) %>%
      select(Country)
  })
  
  output$data_happiness = DT::renderDataTable({
    react_data()
  })
    
}


