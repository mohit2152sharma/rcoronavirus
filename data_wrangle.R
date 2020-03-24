#data loading and wrangling

#data update timestamp
dataUpdateTime = read_lines('./data/dataUpdateTime.txt')

#global data
confirmed = read_csv('./data/confirmed.csv')
deaths = read_csv('./data/deaths.csv')
recovered = read_csv('./data/recovered.csv')

confirmed = add_global(confirmed)
deaths = add_global(deaths)
recovered = add_global(recovered)

#india data
indiaConfirmed = read_csv('./data/india/indiaTimeSeries/indiaConfirmed.csv')

#combining data from jhu and mohfw
indiaCombineConfirmed = filter_country('India', confirmed)

indiaCombineConfirmed = indiaCombineConfirmed[1:which(indiaCombineConfirmed$date == ymd('2020-03-21')), ]

tempdf  = data.frame('date' = colnames(indiaConfirmed)[4:ncol(indiaConfirmed)],
                        'cases' = colSums(indiaConfirmed[,-c(1:3)], na.rm=T),
                        row.names = NULL)
tempdf$date = dmy(tempdf$date)

indiaCombineConfirmed = rbind.data.frame(indiaCombineConfirmed, tempdf)

rm(tempdf)
