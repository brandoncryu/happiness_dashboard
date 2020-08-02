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
                 fluidRow(
                     column(8,
                            plotlyOutput('worldmap'))
                 )
            )
    )
                
)