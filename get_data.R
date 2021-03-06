#get data from jhu and save it locally

#for batch file- load rscripts
source('requirement.R')
source('helper_functions.R')

url_filename = list(
  'confirmed' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv',
                 'confirmed'),
  'deaths' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv',
               'deaths'),
  'recovered' = c('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv',
                  'recovered'))

save_file = function(url_filename, destination='./data/'){
  for(uf in url_filename){
    df = read_csv(uf[[1]])
    write_csv(df, paste(destination,uf[[2]],'.csv', sep=''))
  }
}

save_file(url_filename)

#adding india state data
stateData = state_data('https://www.mohfw.gov.in/')
##extract update date from url
updateDate = update_date()

##add time series data to india csv file
add_date_data_india('./data/india/indiaTimeSeries/indiaConfirmed.csv', stateData[, c(1, which(colnames(stateData) == 'totalConfirmedCases'))], updateDate)
add_date_data_india('./data/india/indiaTimeSeries/indiaRecovered.csv', stateData[, c(1,which(colnames(stateData) == 'recovered'))], updateDate)
add_date_data_india('./data/india/indiaTimeSeries/indiaDeaths.csv', stateData[, c(1,which(colnames(stateData) == 'deaths'))], updateDate)

stateData = combine_latlong(stateData)
write_csv(stateData, paste('./data/india/indiaDailyReports/',updateDate,'.csv', sep=''))

#record data update time
write.table(paste(Sys.time(), 'IST', sep=' '), './data/dataUpdateTime.txt', row.names=F, col.names=F)


print('Data update successful!!!')