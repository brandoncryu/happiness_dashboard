fluidPage(
    theme=shinytheme("flatly"),
    tags$head(
        tags$style(HTML("
          .navbar .navbar-header {float: right}
        "))
    ),
    navbarPage(
        title="Happiness Scores Around the World; 2014-2019",
        id="nav",
        position="fixed-top",
        collapsible=TRUE,
        
        tabPanel("WORLD MAP", icon=icon('globe'),
                 br(),
                 br(),
                 br(),
                 fluidRow(
                     column(3,
                            br(),
                            sliderInput(
                                inputId="worldmap_year",
                                label="Select Year:",
                                min=2015, max=2019,
                                value=2019,
                                sep="")
                            ),
                     column(8,
                            plotlyOutput('worldmap'))
                 )
            )
    )
                
)