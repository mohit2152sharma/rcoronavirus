
#filtering result base on country input
filter_country = function(country,df){
  df_filter = df %>% filter(`Country/Region` == country)
  df_filter  = data.frame('date' = colnames(df_filter)[5:ncol(df_filter)],
                          'cases' = colSums(df_filter[,-c(1:4)]),
                          row.names = NULL)
  df_filter$date = as.Date(df_filter$date, '%m/%d/%y')
  
  return(df_filter)
}

#add global as a country to overall dataframe
add_global = function(df){
  addGlobal = df %>%
    bind_rows(summarise_all(., list(~ifelse(is.numeric(.),sum(., na.rm=T),NA))))
  
  addGlobal$`Country/Region`[nrow(addGlobal)] = 'Global'
  addGlobal$Lat[nrow(addGlobal)] = NA
  addGlobal$Long[nrow(addGlobal)] = NA
  
  return(addGlobal)
}

#extract india state data from url
state_data = function(url){
  
  nodes = html_nodes(read_html(url), '.table-responsive')
  nodeLength = length(nodes)
  stateData = nodes[nodeLength] %>% html_children() %>% html_table()
  stateData = as.data.frame(stateData)
  colnames(stateData) = c('s.no','state', 'totalConfirmedCases', 'recovered', 'deaths')
  #stateData$totalConfirmedCases = as.numeric(stateData[,3]) + as.numeric(stateData[,4])
  stateData$`s.no` = NULL
  return(stateData)
}

##get update data for india data from url
update_date = function(){
  updateDate = strftime(Sys.Date(), '%d.%m.%Y')
  return(updateDate)
}

##write function to add datewise data to latitude and longitude csv file
add_date_data_india = function(csvfile, dateData, date){
  #dateData: column with state names
  df = read_csv(csvfile)
  if(date %in% colnames(df)){
    df[, which(colnames(df) == date)] = NULL
  }
  df = left_join(df, dateData, by = c('States' = 'state'))
  colnames(df)[ncol(df)] = date
  write_csv(df, csvfile)
}

##combine latitude and longitude information with report
combine_latlong = function(df){
  latlong = read_csv('./data/india/indiaLatLong.csv')
  tempDf = left_join(latlong, df, by = c('States' = 'state'))
  return(tempDf)
}

#combine jhu and mohfw data
combine_jhu_mohfw_data = function(indiadf, df){
  tempdf1 = filter_country('India', df)
  tempdf1 = tempdf1[1:which(tempdf1$date == as.Date('2020-03-21', '%Y-%m-%d')), ]
  indiadf = indiadf %>% mutate_at(vars(4:ncol(indiadf)), as.numeric)
  tempdf = data.frame('date' = colnames(indiadf)[4:ncol(indiadf)],
                      'cases' = colSums(indiadf[, -c(1:3)], na.rm=T),
                      row.names = NULL)
  #tempdf$date = dmy(tempdf$date)
  tempdf$date = as.Date(tempdf$date, '%d.%m.%Y')
  tempdf1 = rbind.data.frame(tempdf1, tempdf)
  
  rm(tempdf)
  
  return(tempdf1)
}

#plotting functions
plot_trendPlot = function(df_confirmed, df_recovered, df_deaths){
  plot_ly(df_confirmed, 
          x=~date, 
          y=~cases, 
          name='Confirmed Cases',
          type='scatter', 
          mode='lines+markers') %>%
    add_trace(data=df_recovered,
              x=~date,
              y=~cases,
              name='Recovered Cases',
              mode='lines+markers',
              line = list(color='green'),
              marker=list(color='green')) %>%
    add_trace(data=df_deaths,
              x=~date,
              y=~cases,
              name='Deaths',
              mode='lines+markers',
              line = list(color='red'),
              marker = list(color='red'))
}

daily_df = function(df){
  df = df %>% filter(cases>0)
  if(nrow(df)==0){
    return(df)
  }else{
    df = df %>% mutate(diff = cases-lag(cases))
    return(df)
  }
}

plot_daily = function(df, yaxislabel){
  plot_ly(data=df,
          x=~date,
          y=~diff,
          type='bar') %>%
    layout(xaxis=list(title='Date'),
           yaxis=list(title=paste('No. of ', yaxislabel, sep='')))
}

plot_compare_daily = function(dfA, dfB, countryA, countryB, yaxislabel){
  plot_ly(data=dfA,
          x=~date,
          y=~diff,
          name=countryA,
          type='bar') %>%
    add_trace(data=dfB,
              x=~date,
              y=~diff,
              name=countryB) %>%
    layout(xaxis=list(title='Date'),
           yaxis=list(title=paste('No of', yaxislabel)),
           barmode='group')
}

plot_valuebox_confirmed = function(df){
  valueBox(
    df$cases[nrow(df)],
    subtitle='Total Confirmed Cases',
    color='aqua'
  )
}

plot_valuebox_recovered = function(df){
  valueBox(
    df$cases[nrow(df)],
    subtitle='Total Recovered Cases',
    color='green'
  )
}

plot_valuebox_deaths = function(df){
  valueBox(
    df$cases[nrow(df)],
    subtitle='Total Deaths',
    color='red'
  )
}

plot_compare = function(dfA, countryA, dfB, countryB){
  plot_ly(dfA,
          x=~date,
          y=~cases,
          name=countryA,
          type='scatter',
          mode='lines+markers') %>%
    add_trace(data=dfB,
              x=~date,
              y=~cases,
              name=countryB,
              mode='lines+markers')
}

traj_df = function(countryName, dfType, nCases){
  df = filter_country(countryName, dfType) %>% filter(cases>nCases)
  if(nrow(df)==0){
    return(df)
  }else{
    df$date = 1:nrow(df)
    return(df)
  }
}

plot_trajectory = function(dfSelected, countryName, southKorea, italy, us, nCases){
  plot_ly(data =southKorea,
          x=~date,
          y=~cases,
          name='South Korea') %>% 
    add_lines() %>%
    add_lines(data=italy,
              y=~cases,
              x=~date,
              name='Italy') %>%
    add_lines(data=us,
              y=~cases,
              x=~date,
              name='USA') %>%
    add_lines(data=dfSelected,
              y=~cases,
              x=~date,
              name=countryName) %>%
    layout(xaxis = list(title= paste('Days since, ', nCases,'th case', sep='')),
           yaxis = list(title='log(cases)', type='log')
    ) 
}

#filter india state
filter_state = function(state,df){
  df_filter = df %>% filter(States == state) 
  df_filter  = data.frame('date' = colnames(df_filter)[12:ncol(df_filter)],
                          'cases' = colSums(df_filter[,-c(1:11)]),
                          row.names = NULL)
  df_filter$date = as.Date(df_filter$date, '%d.%m.%y')
  
  return(df_filter)
}

