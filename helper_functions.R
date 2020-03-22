
#filtering result base on country input
filter_country = function(country,df){
  df_filter = df %>% filter(`Country/Region` == country)
  df_filter  = data.frame('date' = colnames(df_filter)[5:ncol(df_filter)],
                          'cases' = colSums(df_filter[,-c(1:4)]),
                          row.names = NULL)
  df_filter$date = mdy(df_filter$date)
  
  return(df_filter)
}

#add global as a country to overall dataframe
add_global = function(df){
  addGlobal = df %>%
    bind_rows(summarise_all(., list(~ifelse(is.numeric(.),sum(.),NA))))
  
  addGlobal$`Country/Region`[nrow(addGlobal)] = 'Global'
  addGlobal$Lat[nrow(addGlobal)] = NA
  addGlobal$Long[nrow(addGlobal)] = NA
  
  return(addGlobal)
}

#extract india state data from url


state_data = function(url){
  stateData = html_nodes(read_html(url),'.table-responsive')[2] %>% html_children() %>% html_table()
  stateData = as.data.frame(stateData)
  colnames(stateData) = c('s.no','state', 'confirmedCasesIndia', 'confirmedCasesForeign', 'recovered', 'deaths')
  stateData$totalConfirmedCases = as.numeric(stateData[,3]) + as.numeric(stateData[,4])
  stateData$`s.no` = NULL
  return(stateData)
}

##get update data for india data from url
update_date = function(url){
  updateDate = read_html(url) %>% html_nodes('p') %>% html_text()
  updateDate = str_extract(updateDate[which(str_detect(text, '\\.*including foreign nationals\\.*'))], '\\.*(\\d{2}.\\d{2}.\\d{4})\\.*')
  
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

