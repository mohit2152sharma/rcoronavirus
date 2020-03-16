source('get_data.R')
source('data_wrangle.R')
source('helper_functions.R')

library(plotly)
library(shinydashboard)
library(shiny)

countries = sort(unique(confirmed$`Country/Region`), decreasing=TRUE)
countries[length(countries)+1] = 'Global'

ui <- dashboardPage(
  #---header----
  dashboardHeader(
    title = 'Covid19-Cases',
    dropdownMenu(
      type='notifications',
      icon=icon('question'),
      headerText = 'Help',
      notificationItem(
        text='Know more about coronoavirus',
        href='https://www.who.int/news-room/q-a-detail/q-a-coronaviruses'
      ),
      notificationItem(
        text='Project Readme',
        icon=icon('question'),
        href='https://github.com/mohit2152sharma/rcoronavirus'
      )
    ),
      tags$li(
        a(
          HTML("<img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=2' border='0' alt='Buy Me a Coffee at ko-fi.com' />"),
          href="https://ko-fi.com/J3J61I856",
          title='',
          target='_blank'
        ),
        class='dropdown'
      )
  ),
  
  #-----sidebar----add country list-----
  dashboardSidebar(
    selectInput(
      inputId='country',
      choices=countries,
      selected='Global',
      label='Select Country'
    )
  ),
  
  #----body----
  dashboardBody(
    fluidRow(
      box(
        title='Number of Cases',
        solidHeader = TRUE,
        status='primary',
        plotlyOutput('trendPlot', height = "400px", width = "900px"),
        width=12
      )
    ),
    
    fluidRow(
      valueBoxOutput("confirmedTotal"),
      valueBoxOutput("recoveredTotal"),
      valueBoxOutput("deathsTotal")
    )
  )
)


  
