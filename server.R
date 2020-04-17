
server <- function(input, output) {
  
  #countryTab
  output$trendPlot = renderPlotly({
    
    if(input$country != 'India'){
      
      plot_trendPlot(df_confirmed = filter_country(input$country, confirmed), 
                     df_recovered = filter_country(input$country, recovered), 
                     df_deaths = filter_country(input$country, deaths))
      
    }else{
      plot_trendPlot(df_confirmed = indiaCombineConfirmed,
                     df_recovered = indiaCombineRecovered,
                     df_deaths = indiaCombineDeaths)
    }

  })
  
  ##daily cases
  output$countryDailyNewCases = renderPlotly({
    
    if(input$country != 'India'){
      df=daily_df(filter_country(input$country, confirmed))
      validate(
        need(nrow(df)>0, paste(input$country,'has not registered a case yet'))
      )
      
      plot_daily(df=df,
                 yaxislabel='New Cases')

    }else{
      
      df = daily_df(indiaCombineConfirmed)
      plot_daily(df, yaxislabel='New Cases')
      
    }
  })
  
  ##daily deaths
  output$countryDailyDeaths = renderPlotly({
    if(input$country != 'India'){
      df=daily_df(filter_country(input$country, deaths))
      validate(
        need(nrow(df>0), paste(input$country, 'has no deaths'))
      )
      plot_daily(df=df,
                 yaxislabel='Deaths')
      
    }else{
      
      df = daily_df(indiaCombineDeaths)
      plot_daily(df=df,
                 yaxislabel='Deaths')
      
    }
  })
  
  ##total number of confirmed cases
  output$confirmedTotal = renderValueBox({
    
    if(input$country != 'India'){
      plot_valuebox_confirmed(df=filter_country(input$country, confirmed))
    }else{
      plot_valuebox_confirmed(df=indiaCombineConfirmed)
    }
    
  })
  
  ##total recovered cases
  output$recoveredTotal = renderValueBox({
    if(input$country!= 'India'){
      plot_valuebox_recovered(df = filter_country(input$country, recovered))
    }else{
      plot_valuebox_recovered(df=indiaCombineRecovered)
    }
  })
  
  ##total deaths
  output$deathsTotal = renderValueBox({
    
    if(input$country != 'India'){
      plot_valuebox_deaths(df = filter_country(input$country, deaths))
    }else{
      plot_valuebox_deaths(df = indiaCombineDeaths)
    }
  })
  
  #compareTab
  ##compareTab total number of cases
  output$comparePlotNoCases = renderPlotly({
 
    if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
      dfA = indiaCombineConfirmed
      dfB = filter_country(input$compareCountryB, confirmed)
    }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
      dfB = indiaCombineConfirmed
      dfA = filter_country(input$compareCountryA, confirmed)
    }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
      dfA = indiaCombineConfirmed
      dfB = indiaCombineConfirmed
    }else{
      dfA = filter_country(input$compareCountryA, confirmed)
      dfB = filter_country(input$compareCountryB, confirmed)
    }
    
    plot_compare(dfA = dfA, 
                 countryA=input$compareCountryA, 
                 dfB = dfB,
                 countryB = input$compareCountryB)
    
  })
  
  ##compareTab total number of deaths
  output$compareDeaths = renderPlotly({
    
    if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
      dfA = indiaCombineDeaths
      dfB = filter_country(input$compareCountryB, deaths)
    }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
      dfB = indiaCombineDeaths
      dfA = filter_country(input$compareCountryA, deaths)
    }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
      dfA = indiaCombineDeaths
      dfB = indiaCombineDeaths
    }else{
      dfA = filter_country(input$compareCountryA, deaths)
      dfB = filter_country(input$compareCountryB, deaths)
    }
    
    plot_compare(dfA = dfA, 
                 countryA=input$compareCountryA, 
                 dfB = dfB,
                 countryB = input$compareCountryB)
  })
  
  ##compareTab total recovered
  output$compareRecovered = renderPlotly({

    if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
      dfA = indiaCombineRecovered
      dfB = filter_country(input$compareCountryB, recovered)
    }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
      dfB = indiaCombineRecovered
      dfA = filter_country(input$compareCountryA, recovered)
    }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
      dfA = indiaCombineRecovered
      dfB = indiaCombineRecovered
    }else{
      dfA = filter_country(input$compareCountryA, recovered)
      dfB = filter_country(input$compareCountryB, recovered)
    }

    plot_compare(dfA = dfA,
                 countryA=input$compareCountryA,
                 dfB = dfB,
                 countryB = input$compareCountryB)
  })
  
  ##compareTab daily new cases
  output$compareDailyNewCases = renderPlotly({
    if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
      dfA = indiaCombineConfirmed
      dfB = filter_country(input$compareCountryB, confirmed)
    }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
      dfB = indiaCombineConfirmed
      dfA = filter_country(input$compareCountryA, confirmed)
    }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
      dfA = indiaCombineConfirmed
      dfB = indiaCombineConfirmed
    }else{
      dfA = filter_country(input$compareCountryA, confirmed)
      dfB = filter_country(input$compareCountryB, confirmed)
    }
    
    dfA=daily_df(dfA)
    dfB=daily_df(dfB)
    
    plot_compare_daily(dfA=dfA,
                       dfB=dfB,
                       countryA=input$compareCountryA,
                       countryB=input$compareCountryB,
                       yaxislabel='New Cases')
  })
  
  ##compareTab daily new deaths
  output$compareDailyNewDeaths = renderPlotly({
    if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
      dfA = indiaCombineDeaths
      dfB = filter_country(input$compareCountryB, deaths)
    }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
      dfB = indiaCombineDeaths
      dfA = filter_country(input$compareCountryA, deaths)
    }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
      dfA = indiaCombineDeaths
      dfB = indiaCombineDeaths
    }else{
      dfA = filter_country(input$compareCountryA, deaths)
      dfB = filter_country(input$compareCountryB, deaths)
    }
    
    dfA=daily_df(dfA)
    dfB=daily_df(dfB)
    
    plot_compare_daily(dfA=dfA,
                       dfB=dfB,
                       countryA=input$compareCountryA,
                       countryB=input$compareCountryB,
                       yaxislabel='Deaths')
  })
  
  #india tab
  ##map
  output$indiaMap = renderLeaflet({
    
    df = indiaConfirmed[, c(1,2,3, ncol(indiaConfirmed))]
    df[c(2:4)] = lapply(df[c(2:4)], as.numeric)
    df = df[-which(is.na(df[,4])),]
    colnames(df)[4] = 'cases'
    df$label = paste(df$States, df$cases, sep=': ')
    
    leaflet(df) %>% 
      setView(lng=78.9629, lat=20.5937, zoom=4) %>% 
      addTiles() %>% 
      addCircleMarkers(lng=~Longitude, lat=~Latitude, radius=~cases/200, color='red', fillOpacity=0.8 , label=~label)
    
  })
  
  ##new cases
  output$indiaDailyNewCases = renderPlotly({
    df = daily_df(indiaCombineConfirmed)
    plot_daily(df, yaxislabel='New Cases') %>%
      layout(annotations = list(x = 1, 
                                y = -0.15, 
                                text = '*Due to technical error, data of 29th March and 31st March was not recorded', 
                                showarrow = F, 
                                xref='paper', 
                                yref='paper', 
                                xanchor='right', 
                                yanchor='auto', 
                                xshift=0, 
                                yshift=0,
                                font=list(size=9, color="red")))
  })

  #trajectory tab
  output$trajectory = renderPlotly({
    
    nCases = as.numeric(input$NoOfCases)
    southKorea = traj_df('Korea, South', confirmed, nCases)
    italy = traj_df('Italy', confirmed, nCases)
    us = traj_df('US', confirmed, nCases)
    
    if(input$trajecotryCountry != 'India'){
      
      dfCountry = traj_df(input$trajecotryCountry, confirmed, nCases)
      validate(
        need(nrow(dfCountry) >0, paste('Please select other country this country has not crossed, ', as.character(nCases), ' cases yet', sep=''))
      )
      
      plot_trajectory(dfSelected=dfCountry,
                      countryName=input$trajecotryCountry,
                      southKorea=southKorea,
                      italy=italy,
                      us=us,
                      nCases=nCases)
    }else{
      dfCountry = indiaCombineConfirmed %>% filter(cases > nCases)
      validate(
        need(nrow(dfCountry) >0, paste('Please select other country this country has not crossed, ', as.character(nCases), ' cases yet', sep=''))
      )
      
      dfCountry$date = 1:nrow(dfCountry)
      
      plot_trajectory(dfSelected=dfCountry,
                      countryName='India',
                      southKorea=southKorea,
                      italy=italy,
                      us=us,
                      nCases=nCases)
    }
  })
  
  #compare Indian states tab
  output$compareStatesConfirm = renderPlotly({
    stateA = input$compareIndiaStatesA
    stateB = input$compareIndiaStatesB
    
    dfA = filter_state(stateA, indiaConfirmed)
    dfB = filter_state(stateB, indiaConfirmed)
    
    plot_compare(dfA = dfA,
                 countryA = stateA,
                 dfB = dfB,
                 countryB = stateB) %>%
      layout(annotations = list(x = 1, 
                                y = -0.15, 
                                text = '*Data since April 1st, 2020', 
                                showarrow = F, 
                                xref='paper', 
                                yref='paper', 
                                xanchor='right', 
                                yanchor='auto', 
                                xshift=0, 
                                yshift=0,
                                font=list(size=9, color="red")))
  })
  
  output$compareStatesRecover = renderPlotly({
    stateA = input$compareIndiaStatesA
    stateB = input$compareIndiaStatesB
    
    dfA = filter_state(stateA, indiaRecovered)
    dfB = filter_state(stateB, indiaRecovered)
    
    plot_compare(dfA = dfA,
                 countryA = stateA,
                 dfB = dfB,
                 countryB = stateB) %>%
      layout(annotations = list(x = 1, 
                                y = -0.15, 
                                text = '*Data since April 1st, 2020', 
                                showarrow = F, 
                                xref='paper', 
                                yref='paper', 
                                xanchor='right', 
                                yanchor='auto', 
                                xshift=0, 
                                yshift=0,
                                font=list(size=9, color="red")))
  })
  
  output$compareStatesDeath = renderPlotly({
    stateA = input$compareIndiaStatesA
    stateB = input$compareIndiaStatesB
    
    dfA = filter_state(stateA, indiaDeaths)
    dfB = filter_state(stateB, indiaDeaths)
    
    plot_compare(dfA = dfA,
                 countryA = stateA,
                 dfB = dfB,
                 countryB = stateB) %>%
      layout(annotations = list(x = 1, 
                                y = -0.15, 
                                text = '*Data since April 1st, 2020', 
                                showarrow = F, 
                                xref='paper', 
                                yref='paper', 
                                xanchor='right', 
                                yanchor='auto', 
                                xshift=0, 
                                yshift=0,
                                font=list(size=9, color="red")))
  })
  
  
  #india state plot
  output$statesLinePlot = renderPlotly({
    df = indiaConfirmed %>%
      pivot_longer(-c(States, Latitude, Longitude), names_to = 'date', values_to = 'cases')
    
    df$date = as.Date(df$date, '%d.%m.%Y')
    df = df[which(df$date > as.Date('01.04.2020', '%d.%m.%Y')), ]
    
    plot_ly(df,
            x = ~date,
            y = ~cases,
            color = ~as.factor(States),
            type = 'scatter',
            mode = 'lines+markers') %>%
      layout(annotations = list(x = 1, 
                                y = -0.15, 
                                text = '*Data since April 1st, 2020', 
                                showarrow = F, 
                                xref='paper', 
                                yref='paper', 
                                xanchor='right', 
                                yanchor='auto', 
                                xshift=0, 
                                yshift=0,
                                font=list(size=9, color="red")))
  })
}