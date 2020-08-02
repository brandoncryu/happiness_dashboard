function(input, output) {

    output$worldmap <- renderPlotly({
        plot_geo(happiness_2019) %>%
            add_trace(z = ~Score, 
                      color = ~Score,
                      colors = 'Greens', 
                      text = ~Country.or.region, 
                      locations = ~code, 
                      marker = list(line = l)
            ) %>%
            colorbar(title = 'Score') %>%
            layout(title = 'Happiness Score' ,geo = g)

    })

}


