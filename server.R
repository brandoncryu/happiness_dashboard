function(input, output) {

    output$worldmap <- renderPlotly({
      happiness %>%
        filter(year == input$worldmap_year) %>%
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

}