library(plotly)

server <- function(input, output) {
  
  #countryTab
  output$trendPlot = renderPlotly({
    
    if(input$country != 'India'){
      
      plot_trendPlot(df_confirmed = filter_country(input$country, confirmed), 
                     #df_recovered = filter_country(input$country, recovered), 
                     df_deaths = filter_country(input$country, deaths))
      
    }else{
      plot_trendPlot(df_confirmed = indiaCombineConfirmed,
                     #df_recovered = indiaCombineRecovered,
                     df_deaths = indiaCombineDeaths)
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
  # output$recoveredTotal = renderValueBox({
  #   if(input$country!= 'India'){
  #     plot_valuebox_recovered(df = filter_country(input$country, recovered))
  #   }else{
  #     plot_valuebox_recovered(df=indiaCombineRecovered)
  #   }
  # })
  
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
  # output$compareRecovered = renderPlotly({
  #   
  #   if(input$compareCountryA == 'India' && input$compareCountryB != 'India'){
  #     dfA = indiaCombineRecovered
  #     dfB = filter_country(input$compareCountryB, recovered)
  #   }else if(input$compareCountryA != 'India' && input$compareCountryB == 'India' ){
  #     dfB = indiaCombineRecovered
  #     dfA = filter_country(input$compareCountryA, recovered)
  #   }else if(input$compareCountryA == 'India' && input$compareCountryB == 'India'){
  #     dfA = indiaCombineRecovered
  #     dfB = indiaCombineRecovered
  #   }else{
  #     dfA = filter_country(input$compareCountryA, recovered)
  #     dfB = filter_country(input$compareCountryB, recovered)
  #   }
  #   
  #   plot_compare(dfA = dfA, 
  #                countryA=input$compareCountryA, 
  #                dfB = dfB,
  #                countryB = input$compareCountryB)
  # })
  
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
      addCircleMarkers(lng=~Longitude, lat=~Latitude, radius=~cases/5, color='red', fillOpacity=0.8 , label=~label)
    
  })
  
  # ##news
  # todayCases = sum(indiaConfirmed[,ncol(indiaConfirmed)], na.rm=T)
  # ydayCases = sum(indiaConfirmed[,ncol(indiaConfirmed)-1], na.rm=T)
  # inc = round((todayCases-ydayCases)/ydayCases, 2)*100
  # 
  # maxJump = max(indiaConfirmed[, ncol(indiaConfirmed)] - indiaConfirmed[,ncol(indiaConfirmed)-1], na.rm=T)
  # stateMaxJump = indiaConfirmed$States[which(indiaConfirmed[,ncol(indiaConfirmed)] == indiaConfirmed[,ncol(indiaConfirmed)-1] + maxJump)]
  # 
  # output$indiaNewCases = renderText({
  #   paste('Cases in India increased by ', inc, ' % since yesterday', sep='')
  # })
  # 
  # output$stateMaxJump = renderText({
  #   paste('State with maximum new cases registered: ', stateMaxJump, ', with total ', maxJump, ' new cases', sep='')
  # })
  # 
  ##new cases
  output$indiaDailyNewCases = renderPlotly({
    df = indiaCombineConfirmed %>%  filter(cases > 0) %>% mutate(diff=cases - lag(cases))
    
    plot_ly(data=df,
            x=~date,
            y=~diff,
            type='bar') %>%
      layout(xaxis=list(title='Date'),
             yaxis=list(title='No. of new cases'))
  })
  
  ##stateheatmap
  output$indiaStateHeatMap = renderPlotly({
    
    df = indiaConfirmed %>% 
      pivot_longer(-c(States, Latitude, Longitude), names_to='date', values_to='cases')
    
    df$date = dmy(df$date)
    df[is.na(df$cases), 'cases'] = 0
    
    gg = ggplot(df, aes(x=date, y=States)) +
      geom_tile(aes(fill=cases), color='grey') +
      scale_fill_gradient(low='white', high='red')
    ggplotly(gg)
    
  })
  
  
  #trajectory tab
  output$trajectory = renderPlotly({
    southKorea = filter_country('Korea, South', confirmed) %>% filter(cases >100)
    southKorea$date = 1:nrow(southKorea)
    
    italy = filter_country('Italy', confirmed) %>% filter(cases>100)
    italy$date = 1:nrow(italy)
    
    us = filter_country('US', confirmed) %>% filter(cases > 100)
    us$date = 1:nrow(us)
    
    
    if(input$trajecotryCountry != 'India'){
    
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
    }else{
      dfCountry = indiaCombineConfirmed %>% filter(cases > 100)
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
                  name='India') %>%
        layout(xaxis = list(title='Days since 100th case'),
               yaxis = list(title='log(cases)', type='log')
        )
      fig
    }
  })
}