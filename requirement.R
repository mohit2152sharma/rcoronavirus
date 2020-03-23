#package required

packages = c('tidyverse', 'lubridate', 'shinydashboard', 
             'plotly', 'shiny', 'rvest', 'stringr', 'readr',
             'leaflet')

new.packages = packages[!(packages %in% installed.packages()[,'Package'])]

if(length(new.packages)){
  install.packages(new.packages)
}

library(tidyverse)
library(lubridate)
library(shinydashboard)
library(plotly)
library(shiny)
library(rvest)
library(leaflet)
