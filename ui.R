fluidPage(
    theme=shinytheme("lumen"),
    tags$head(
        tags$style(HTML(".navbar .navbar-nav {float: right;
        font-size:20px }
                        "))
    ),
    
    # Navigation bar that is always on the top of the screen
    navbarPage(
        title="Happiness Scores Around the World: 2015-2019",
        id="nav",
        position="static-top",
        
        # World Map page
        tabPanel("WORLD MAP", icon=icon('globe'),
                 fluidRow(
                     h3('Happiness Scores Around the World'),
                     h4('Breakdown of each score measures how each criteria makes each country happier than Dystopia.'),
                     br(),
                     h4('Data is taken from:'),
                     tags$a(href="https://worldhappiness.report", "World Happiness Report")
                 ),
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
                                             'Social Support' = 'Social.support'),
                                selected = c('GDP.per.capita','Healthy.life.expectancy','Freedom.to.make.life.choices','Generosity','Perceptions.of.corruption','Social.support')
                                )
                            ),
                     
                     column(8,
                            plotlyOutput('worldmap'))
                     ),
                 fluidRow(
                     DT::dataTableOutput("data_happiness")
                     )
                 ),
        
        # Explore Page
        tabPanel("EXPLORE",icon = icon("poll"),
                 tabsetPanel(type='tabs', id='chart_tabs',
                             
                             # Variables tab within Explore Page
                             tabPanel("VARIABLES",
                                      fluidRow(
                                          br(),
                                          column(3,
                                                 sliderInput(
                                                   inputId = 'variables_year',
                                                   label = 'Select Years:',
                                                   min=2015, max=2019,
                                                   value=c(2015,2019),
                                                   sep=''
                                                   ),
                                                 selectizeInput(
                                                     inputId = "var1",
                                                     label = h5(strong("Select a variable for x-axis:")),
                                                     choices = scatter_choices
                                                     ),
                                                 selectizeInput(
                                                     inputId = "var2",
                                                     label = h5(strong("Select a variable for y-axis:")),
                                                     choices = scatter_choices
                                                     ),
                                                 h4(strong(htmlOutput("correlation")))
                                                 ),
                                          column(9,
                                                 plotlyOutput('scatter'))
                                          )
                                      ),
                             
                             # Trends tab within Explore Page
                             tabPanel("TRENDS",
                                      fluidRow(
                                          br(),
                                          column(3,
                                                 sliderInput(
                                                     inputId = 'trends_variables_year',
                                                     label = 'Select Years:',
                                                     min=2015, max=2019,
                                                     value=c(2015,2019),
                                                     sep=''
                                                 ),
                                                 selectizeInput(
                                                     inputId="countries",
                                                     label="Select countries:",
                                                     multiple = TRUE,
                                                     choices = sort(unique(happiness$Country))
                                                 ),
                                                 selectizeInput(
                                                     inputId = 'trend_variable',
                                                     label= 'Select variable:',
                                                     choices = c('Score','Rank'),
                                                     selected = 'Score'
                                                 )
                                          ),
                                          column(9,
                                                 plotlyOutput('trend'),
                                                 br(),
                                                 h3(strong("Happiness Score Increase in Selected Time Range")),
                                                 DT::dataTableOutput("trend_table")
                                                 )
                                        )
                                      ),
                             tabPanel("REGIONS",
                                      fluidRow(
                                          br(),
                                          column(3,
                                                 selectizeInput(
                                                     inputId = "region_or_continent",
                                                     label = h5(strong("Select Regions or Continents")),
                                                     choices = c('region','continent')
                                                 )
                                          ),
                                          column(9,
                                                 DT::dataTableOutput("regional_scores")
                                          )
                                          
                                      )
                                      
                             ),
                             # Explore suicide data with happiness dataset
                             tabPanel("SUICIDE",
                                      fluidRow(
                                          br(),
                                          column(3,
                                                 selectizeInput(
                                                     inputId = "var3",
                                                     label = h5(strong("Select a variable for x-axis:")),
                                                     choices = scatter_choices
                                                 ),
                                                 h4(strong(htmlOutput("suicide_correlation")))
                                            ),
                                          column(9,
                                                 plotlyOutput('suicide')
                                            )
                                          
                                      )
                                 
                             )
                             
                        )
                 ),
        tabPanel("ABOUT ME",
                 icon = icon('handshake'),
                 fluidRow(
                     br(),
                     img(src = "brandon.png", width = "17%", style = "display: block; margin-left: auto; margin-right: auto;")
                 ),
                 fluidRow(
                     h3(strong("Brandon Ryu"), style = "text-align: center"),
                     h5("Brandon.C.Ryu@gmail.com", style = "text-align: center")
                 ),
                 fluidRow(
                     tags$div(style = 'text-align: center',
                         tags$a(
                             href = 'https://www.linkedin.com/in/brandon-ryu-5002898a/',
                             img(
                                 src = 'LinkedIn.png',
                                 title = "My LinkedIn",
                                 height = "50px",
                                 style = "display: inline-block; margin-left: auto; margin-right: auto;"
                             )
                         ),
                         tags$a(
                             href = 'https://github.com/brandoncryu/happiness_dashboard',
                             img(
                                 src = 'github.jpg',
                                 title = "My Github",
                                 height = "50px",
                                 style = "display: inline-block; margin-left: auto; margin-right: auto;"
                             )
                         )
                     )
                 ),
                 fluidRow(
                     tags$div(style = 'text-align: center; width: 50%; margin-left: auto; margin-right: auto;',
                              h4('Brandon is a passionate Data Scientist with a strong technical background and demonstrated experience in guiding healthcare products that improve patient care around the world. He is a strong interdisciplinary professional with a proven track record of collaborating with users, stakeholders and R&D to spearhead projects.'),
                              h4('Brandon has previously worked as a Solutions Engineer at Epic Systems and Formulation Scientist at Fresenius Kabi.'),
                              h4('He holds a B.S. in Chemical Engineering from Northwestern University.')
                        )
                     
                 )
            
        )
    )
)