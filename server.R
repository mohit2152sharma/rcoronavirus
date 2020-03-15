library(plotly)

server <- function(input, output) {
  
  output$trendPlot = renderPlotly({
    if(input$country == 'Global'){
      plot_ly(
        overall_confirmed,
        x=~date,
        y=~cases,name='Confirmed Cases',
        type='scatter', 
        mode='lines+markers') %>%
        add_trace(y=~overall_recovered$cases,
                  name='Recovered Cases',
                  mode='lines+markers') %>%
        add_trace(y=~overall_deaths$cases,
                  name='Deaths',
                  mode='lines+markers')
    }else{
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
                  mode='lines+markers') %>%
        add_trace(y=~df_deaths$cases,
                  name='Deaths',
                  mode='lines+markers')
    }
  })
  
  #total number of confirmed cases
  output$confirmedTotal = renderValueBox({
    
    if(input$country == 'Global'){
      valueBox(
        overall_confirmed$cases[nrow(overall_confirmed)],
        subtitle='Total Confirmed Cases',
        color='aqua'
      )
    } else{
      df = filter_country(input$country, confirmed)
      valueBox(
        df$cases[nrow(df)],
        subtitle='Total Confirmed Cases',
        color='aqua'
      )
    }
  })
  
  #total recovered cases
  output$recoveredTotal = renderValueBox({
    if(input$country == 'Global'){
      valueBox(
        overall_recovered$cases[nrow(overall_recovered)],
        subtitle='Total Recovered Cases',
        color='green'
      )
    } else{
      df = filter_country(input$country, recovered)
      valueBox(
        df$cases[nrow(df)],
        subtitle='Total Recovered Cases',
        color='green'
      )
    }
  })
  
  #total deaths
  output$deathsTotal = renderValueBox({
    if(input$country == 'Global'){
      valueBox(
        overall_deaths$cases[nrow(overall_deaths)],
        subtitle='Total Deaths',
        color='red'
      )
    } else{
      df = filter_country(input$country, deaths)
      valueBox(
        df$cases[nrow(df)],
        subtitle='Total Deaths',
        color='red'
      )
    }
  })
}