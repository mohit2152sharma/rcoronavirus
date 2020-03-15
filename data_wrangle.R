#data wrangling
library(tidyverse)
library(lubridate)

confirmed = read_csv('./data/confirmed.csv')
deaths = read_csv('./data/deaths.csv')
recovered = read_csv('./data/recovered.csv')

#overall confirmed
overall_confirmed = data.frame('date' = colnames(confirmed)[5:ncol(confirmed)],
                     'cases' = colSums(confirmed[,-c(1:4)]),
                     row.names = NULL)
#convert to date column
overall_confirmed$date = mdy(overall_confirmed$date)

#overall deaths
overall_deaths = data.frame('date' = colnames(deaths)[5:ncol(deaths)],
                            'cases' = colSums(deaths[,-c(1:4)]),
                            row.names = NULL)
overall_deaths$date = mdy(overall_deaths$date)

#overall recovered
overall_recovered = data.frame('date' = colnames(recovered)[5:ncol(recovered)],
                               'cases' = colSums(recovered[,-c(1:4)]),
                               row.names = NULL)
overall_recovered$date = mdy(overall_recovered$date)
