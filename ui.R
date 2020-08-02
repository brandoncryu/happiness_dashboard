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
                                sep=""),
                            checkboxGroupInput(
                                inputId="happiness_features",
                                label="Select Data:",
                                choices=list("GDP per Capita"="GDP.per.capita",
                                             "Health/Life Expectancy"="Healthy.life.expectancy",
                                             "Freedom to Make Life Choices"="Freedom.to.make.life.choices",
                                             "Generosity"="Generosity",
                                             "Perception of Corruption" = 'Perceptions.of.corruption',
                                             'Social Support' = 'Social.support'),
                                selected = c('GDP.per.capita','Healthy.life.expectancy','Freedom.to.make.life.choices','Generosity','Perceptions.of.corruption','Social.support')
                                )
                            ),
                     column(8,
                            plotlyOutput('worldmap'))
                 )
            )
    )
)

# colnames(happiness)
