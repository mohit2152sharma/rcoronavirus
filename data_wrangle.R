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
indiaRecovered = read_csv('./data/india/indiaTimeSeries/indiaRecovered.csv')
indiaDeaths = read_csv('./data/india/indiaTimeSeries/indiaDeaths.csv')

#combining data from jhu and mohfw
indiaCombineConfirmed = combine_jhu_mohfw_data(indiaConfirmed, confirmed)
indiaCombineRecovered = combine_jhu_mohfw_data(indiaRecovered, recovered)
indiaCombineDeaths = combine_jhu_mohfw_data(indiaDeaths, deaths)
