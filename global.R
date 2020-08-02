library(shiny)
library(shinythemes)
library(plotly)
library(googleVis)
library(tidyverse)
library(DT)
library(countrycode)

happiness_2019 = read.csv("./data/happiness_2019.csv")

happiness_2019$code = countrycode(happiness_2019$Country.or.region, origin='country.name',destination='iso3c')

# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)
# specify map projection/options
g <- list(showframe = FALSE,showcoastlines = FALSE,
          projection = list(type = 'Mercator'))

