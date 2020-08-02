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
        position="static-top",
        collapsible=TRUE,
        
        tabPanel("WORLD MAP", icon=icon('globe'),
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
                                             "Healthy Life Expectancy"="Healthy.life.expectancy",
                                             "Freedom to Make Life Choices"="Freedom.to.make.life.choices",
                                             "Generosity"="Generosity",
                                             "Perception of Corruption" = 'Perceptions.of.corruption',
                                             'Social Support' = 'Social.support',
                                             'Dystopia residual' = 'Dystopia.Residual'),
                                selected = c('GDP.per.capita','Healthy.life.expectancy','Freedom.to.make.life.choices','Generosity','Perceptions.of.corruption','Social.support','Dystopia.Residual')
                                )
                            ),
                     
                     column(8,
                            plotlyOutput('worldmap'))
                 ),
                 fluidRow(
                     DT::dataTableOutput("data_happiness")
                 )
            ),
        
        tabPanel("EXPLORE",icon = icon("poll"),
                 tabPanel("VARIABLES",
                          fluidRow(
                              column(4,
                                     selectizeInput(
                                         inputId = "var1",
                                         label = h5(strong("Select a variable:")),
                                         choices = scatter_choices
                                     ),
                                     selectizeInput(
                                         inputId = "var2",
                                         label = h5(strong("Select a variable:")),
                                         choices = scatter_choices
                                     )
                                ),
                              column(8,
                                     plotlyOutput('scatter'))
                          
                          ),
                    )
            )
    )
)

# colnames(happiness)
