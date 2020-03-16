#get data and save it locally
library(readr)

url_filename = list(
  'confirmed' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv',
                 'confirmed'),
  'deaths' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv',
               'deaths'),
  'recovered' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv',
                  'recovered'))

save_file = function(url_filename, destination='./data/'){
  for(uf in url_filename){
    df = read_csv(uf[[1]])
    write_csv(df, paste(destination,uf[[2]],'.csv', sep=''))
  }
}

save_file(url_filename)
