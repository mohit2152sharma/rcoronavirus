#data loading and wrangling

#data update timestamp
dataUpdateTime = read_lines('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/dataUpdateTime.txt')

#global data
confirmed = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/confirmed.csv', 
                     col_types = cols(.default = 'i', 
                                                              'Lat' = 'd', 
                                                              'Long' = 'd', 
                                                              `Province/State`='c', 
                                                              `Country/Region`='c'))

deaths = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/deaths.csv', 
                  col_types = cols(.default = 'i', 
                                                        'Lat' = 'd', 
                                                        'Long' = 'd', 
                                                        `Province/State`='c', 
                                                        `Country/Region`='c'))

recovered = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/recovered.csv', 
                     col_types = cols(.default = 'i', 
                                                              'Lat' = 'd', 
                                                              'Long' = 'd', 
                                                              `Province/State`='c', 
                                                              `Country/Region`='c'))

confirmed = add_global(confirmed)
deaths = add_global(deaths)
recovered = add_global(recovered)

#india data
indiaConfirmed = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/india/indiaTimeSeries/indiaConfirmed.csv', 
                          col_types = cols('States' = 'c', 
                                           'Latitude' = 'd', 
                                           'Longitude' = 'd', 
                                           .default = 'i'))

indiaRecovered = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/india/indiaTimeSeries/indiaRecovered.csv',
                          col_types = cols('States' = 'c', 
                                           'Latitude' = 'd', 
                                           'Longitude' = 'd', 
                                           .default = 'i'))

indiaDeaths = read_csv('https://raw.githubusercontent.com/mohit2152sharma/rcoronavirus/master/data/india/indiaTimeSeries/indiaDeaths.csv', 
                       col_types = cols('States' = 'c', 
                                        'Latitude' = 'd', 
                                        'Longitude' = 'd', 
                                        .default = 'i'))

#combining data from jhu and mohfw
indiaCombineConfirmed = combine_jhu_mohfw_data(indiaConfirmed, confirmed)
indiaCombineRecovered = combine_jhu_mohfw_data(indiaRecovered, recovered)
indiaCombineDeaths = combine_jhu_mohfw_data(indiaDeaths, deaths)
