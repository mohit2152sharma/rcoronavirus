#filtering result base on country input
filter_country = function(country,df){
  df_filter = df %>% filter(`Country/Region` == country)
  df_filter  = data.frame('date' = colnames(df_filter)[5:ncol(df_filter)],
                          'cases' = colSums(df_filter[,-c(1:4)]),
                          row.names = NULL)
  df_filter$date = mdy(df_filter$date)
  
  return(df_filter)
}

