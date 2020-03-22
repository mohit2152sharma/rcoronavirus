#data loading and wrangling

#global data
confirmed = read_csv('./data/confirmed.csv')
deaths = read_csv('./data/deaths.csv')
recovered = read_csv('./data/recovered.csv')

confirmed = add_global(confirmed)
deaths = add_global(deaths)
recovered = add_global(recovered)

#india data
indiaConfirmed = read_csv('./data/india/indiaTimeSeries/indiaConfirmed.csv')

