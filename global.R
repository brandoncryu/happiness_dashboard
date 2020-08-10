library(shiny)
library(shinythemes)
library(plotly)
library(googleVis)
library(tidyverse)
library(DT)
library(countrycode)

# import happiness csv by year
happiness_2019 = read.csv("./data/happiness_2019.csv")
happiness_2018 = read.csv("./data/happiness_2018.csv")
happiness_2017 = read.csv("./data/happiness_2017.csv")
happiness_2016 = read.csv("./data/happiness_2016.csv")
happiness_2015 = read.csv("./data/happiness_2015.csv")

# add column year to each dataframe
happiness_2019$year = 2019
happiness_2018$year = 2018
happiness_2017$year = 2017
happiness_2016$year = 2016
happiness_2015$year = 2015


# rename columns to merge into 1 dataframe
happiness_2015 = happiness_2015 %>%
  rename(
    Rank = Happiness.Rank,
    Score = Happiness.Score, 
    GDP.per.capita = Economy..GDP.per.Capita.,
    Healthy.life.expectancy = Health..Life.Expectancy.,
    Freedom.to.make.life.choices = Freedom, 
    Perceptions.of.corruption = Trust..Government.Corruption.,
    Social.support = Family
  )

happiness_2016 = happiness_2016 %>%
  rename(
    Rank = Happiness.Rank,
    Score = Happiness.Score, 
    GDP.per.capita = Economy..GDP.per.Capita.,
    Healthy.life.expectancy = Health..Life.Expectancy.,
    Freedom.to.make.life.choices = Freedom, 
    Perceptions.of.corruption = Trust..Government.Corruption.,
    Social.support = Family
  )

happiness_2017 = happiness_2017 %>%
  rename(
    Rank = Happiness.Rank,
    Score = Happiness.Score, 
    GDP.per.capita = Economy..GDP.per.Capita.,
    Healthy.life.expectancy = Health..Life.Expectancy.,
    Freedom.to.make.life.choices = Freedom, 
    Perceptions.of.corruption = Trust..Government.Corruption.,
    Social.support = Family
  )

happiness_2018$Perceptions.of.corruption = as.numeric(happiness_2018$Perceptions.of.corruption)
happiness_2018 = happiness_2018 %>%
  rename(
    Rank = Overall.rank,
    Country = Country.or.region
  )%>%
  mutate(Dystopia.Residual = Score-rowSums(.[4:9], na.rm=TRUE))

happiness_2019 = happiness_2019 %>%
  rename(
    Rank = Overall.rank,
    Country = Country.or.region
  ) %>%
  mutate(Dystopia.Residual = Score-rowSums(.[4:9], na.rm=TRUE))

# remove unnecessary columns
  
happiness_2017 = happiness_2017[-c(4,5)]
happiness_2016 = happiness_2016[-c(2,5,6)]
happiness_2015 = happiness_2015[-c(2,5)]


# bind rows of yearly datasets
happiness = bind_rows(happiness_2015,happiness_2016,happiness_2017,happiness_2018,happiness_2019)

# create continent and country code columns
happiness$region = countrycode(happiness$Country, origin = 'country.name', destination='region')
happiness$code = countrycode(happiness$Country, origin='country.name',destination='iso3c', custom_match = c(Kosovo = "KSV"))
happiness$continent = countrycode(happiness$Country, origin = 'country.name', destination='continent')

# reorder columns in happiness dataframe
column_order = c('year','region','continent','Country','code','Rank','Score', 'GDP.per.capita', 'Healthy.life.expectancy' ,'Freedom.to.make.life.choices', 'Generosity', 'Perceptions.of.corruption','Social.support',"Dystopia.Residual" )
happiness = happiness[,column_order]



# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)
# specify map projection/options
g <- list(showframe = FALSE,showcoastlines = FALSE,
          projection = list(type = 'Mercator'))

# Choices used for input
scatter_choices = list("Happiness Score" = 'Score',
                       "GDP per Capita"="GDP.per.capita",
                       "Healthy Life Expectancy"="Healthy.life.expectancy",
                       "Freedom to Make Life Choices"="Freedom.to.make.life.choices",
                       "Generosity"="Generosity",
                       "Perception of Corruption" = 'Perceptions.of.corruption',
                       'Social Support' = 'Social.support',
                       'Dystopia residual' = 'Dystopia.Residual')


# Merging suicide data frame
suicide = read.csv("./data/suicide.csv")

suicide = suicide %>%
  mutate(code = countrycode(suicide$country, origin = 'country.name', destination='iso3c')) %>%
  filter(year >=2015) %>%
  select(code,year,suicides.100k.pop,gdp_per_capita....,population) %>%
  group_by(code,year) %>%
  summarise(suicides.100k.pop = sum(suicides.100k.pop),
            gdp.per.capita = mean(gdp_per_capita....),
            population = sum(population))

happiness_suicide = happiness %>%
  merge(suicide)


#
happiness_suicide %>%
  group_by(region) %>%
  summarise(Score = sum(Score*population)/sum(population))

test1 = happiness %>%
  filter(year == 2015) %>%
  select('Score','code','Country')

test2 = happiness %>%
  filter(year == 2019) %>%
  select('Score','code','Country')

merge(test1, test2, by='code') %>%
  mutate(diff=Score.x-Score.y) %>%
  arrange(desc(diff))
