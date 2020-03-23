library(plotly)

server <- function(input, output) {
  
  #countryTab
  output$trendPlot = renderPlotly({
    
    df_confirmed = filter_country(input$country, confirmed)
    df_recovered = filter_country(input$country, recovered)
    df_deaths = filter_country(input$country, deaths)
    
    plot_ly(df_confirmed, 
            x=~date, 
            y=~cases, 
            name='Confirmed Cases',
            type='scatter', 
            mode='lines+markers') %>%
      add_trace(y=~df_recovered$cases,
                name='Recovered Cases',
                mode='lines+markers',
                line = list(color='green'),
                marker=list(color='green')) %>%
      add_trace(y=~df_deaths$cases,
                name='Deaths',
                mode='lines+markers',
                line = list(color='red'),
                marker = list(color='red'))

  })
  
  ##total number of confirmed cases
  output$confirmedTotal = renderValueBox({
    
    df = filter_country(input$country, confirmed)
    valueBox(
      df$cases[nrow(df)],
      subtitle='Total Confirmed Cases',
      color='aqua'
    )
    
  })
  
  ##total recovered cases
  output$recoveredTotal = renderValueBox({
    
    df = filter_country(input$country, recovered)
    valueBox(
      df$cases[nrow(df)],
      subtitle='Total Recovered Cases',
      color='green'
    )
    
  })
  
  ##total deaths
  output$deathsTotal = renderValueBox({
    
    df = filter_country(input$country, deaths)
    valueBox(
      df$cases[nrow(df)],
      subtitle='Total Deaths',
      color='red'
    )

  })
  
  #compareTab
  ##compareTab total number of cases
  output$comparePlotNoCases = renderPlotly({
    
    dfConfirmedA = filter_country(input$compareCountryA, confirmed)
    dfConfirmedB = filter_country(input$compareCountryB, confirmed)
    
    
    plot_ly(dfConfirmedA,
            x=~date,
            y=~cases,
            name=input$compareCountryA,
            type='scatter',
            mode='lines+markers') %>%
      add_trace(y=~dfConfirmedB$cases,
                name=input$compareCountryB,
                mode='lines+markers')
      
  })
  
  ##compareTab total number of deaths
  output$compareDeaths = renderPlotly({
    
    dfDeathsA = filter_country(input$compareCountryA, deaths)
    dfDeathsB = filter_country(input$compareCountryB, deaths)
    
    plot_ly(dfDeathsA,
            x=~date,
            y=~cases,
            name=~input$compareCountryA,
            type='scatter',
            mode='lines+markers') %>%
      add_trace(y=~dfDeathsB$cases,
                name=input$compareCountryB,
                mode='lines+markers')
  })
  
  ##compareTab total recovered
  output$compareRecovered = renderPlotly({
    
    dfRecoveredA = filter_country(input$compareCountryA, recovered)
    dfRecoveredB = filter_country(input$compareCountryB, recovered)
    
    plot_ly(dfRecoveredA,
            x=~date,
            y=~cases,
            name=~input$compareCountryA,
            type='scatter',
            mode='lines+markers') %>%
      add_trace(y=~dfRecoveredB$cases,
                name=input$compareCountryB,
                mode='lines+markers')
  })
  
  #india tab
  output$indiaMap = renderLeaflet({
    
    df = indiaConfirmed[, c(1,2,3, ncol(indiaConfirmed))]
    df[c(2:4)] = lapply(df[c(2:4)], as.numeric)
    df = df[-which(is.na(df[,4])),]
    colnames(df)[4] = 'cases'
    df$label = paste(df$States, df$cases, sep=': ')
    
    leaflet(df) %>% 
      setView(lng=78.9629, lat=20.5937, zoom=4) %>% 
      addTiles() %>% 
      addCircleMarkers(lng=~Longitude, lat=~Latitude, radius=~cases/5, color='red', fillOpacity=0.8 , label=~label)
    
  })
  
  todayCases = sum(indiaConfirmed[,ncol(indiaConfirmed)], na.rm=T)
  ydayCases = sum(indiaConfirmed[,ncol(indiaConfirmed)-1], na.rm=T)
  inc = round((todayCases-ydayCases)/ydayCases, 2)*100
  
  maxJump = max(indiaConfirmed[, ncol(indiaConfirmed)] - indiaConfirmed[,ncol(indiaConfirmed)-1], na.rm=T)
  stateMaxJump = indiaConfirmed$States[which(indiaConfirmed[,ncol(indiaConfirmed)] == indiaConfirmed[,ncol(indiaConfirmed)-1] + maxJump)]
  
  output$indiaNewCases = renderText({
    paste('Cases in India increased by ', inc, ' % since yesterday', sep='')
  })
  
  output$stateMaxJump = renderText({
    paste('State with maximum new cases registered: ', stateMaxJump, ', with total ', maxJump, ' new cases', sep='')
  })
  
  output$trajectory = renderPlotly({
    southKorea = filter_country('Korea, South', confirmed) %>% filter(cases >100)
    southKorea$date = 1:nrow(southKorea)
    
    italy = filter_country('Italy', confirmed) %>% filter(cases>100)
    italy$date = 1:nrow(italy)
    
    us = filter_country('US', confirmed) %>% filter(cases > 100)
    us$date = 1:nrow(us)
    
    dfCountry = filter_country(input$trajecotryCountry, confirmed) %>% filter(cases > 100)
    dfCountry$date = 1:nrow(dfCountry)
    
    fig = plot_ly(data =southKorea,
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
      add_lines(data=dfCountry,
                y=~cases,
                x=~date,
                name=input$trajecotryCountry) %>%
      layout(xaxis = list(title='Days since 100th case'),
             yaxis = list(title='log(cases)', type='log')
             )
    fig
  })
}