#package required

packages = c('tidyverse', 'lubridate', 'shinydashboard', 'plotly', 'shiny')

new.packages = packages[!(packages %in% installed.packages()[,'Package'])]

if(length(new.packages)){
  install.packages(new.packages)
}