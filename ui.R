source('requirement.R')
source('helper_functions.R')
#source('get_data.R')
source('data_wrangle.R')


countries = sort(unique(confirmed$`Country/Region`), decreasing=TRUE)

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
}

dashboardHeader = dashboardHeader(
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
)

dashboardSideBar = dashboardSidebar(
  sidebarMenu(
    id='tabs',
    convertMenuItem(
      menuItem(
        text='Country',
        tabName='tabCountry',
        selectInput(
          inputId='country',
          choices=countries,
          selected='Global',
          label='Select Country'
        )
      ),
      tabName='tabCountry'
    ),
    convertMenuItem(
      menuItem(
        text='Compare',
        tabName='tabCompareCountry',
        selectInput(
          inputId='compareCountryA',
          choices=countries,
          selected='Global',
          label='Select Country A'
        ),
        selectInput(
          inputId='compareCountryB',
          choices=countries,
          selected='China',
          label='Select Country B'
        )
      ),
      tabName='tabCompareCountry'
    ),
    convertMenuItem(
      menuItem(
        text='India',
        tabName='india'
      ),
      tabName='india'
    )
  )
)

dashboardBody = dashboardBody(
  
  tabItems(
    
    #country tab
    tabItem(
      tabName = 'tabCountry',
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
    ),
    
    #compare country tab
    tabItem(
      tabName='tabCompareCountry',
      fluidRow(
        tabBox(
          title='Compare Countries',
          tabPanel(
            'Confirmed Cases',
            plotlyOutput('comparePlotNoCases')
          ),
          tabPanel(
            'Recovered Cases',
            plotlyOutput('compareRecovered')
          ),
          tabPanel(
            'Deaths',
            plotlyOutput('compareDeaths')
          ),
          width=12
        )
      )
    ),
    
    #india tab
    tabItem(
      tabName='india',
      fluidRow(
        tabBox(
          title='India',
          tabPanel(
            'Map',
            leafletOutput('indiaMap')
          ),
          width=12
        )
      )
    )
  )
)

ui <- dashboardPage(
  #---header----
  dashboardHeader,
  #-----sidebar----add country list-----
  dashboardSideBar,
  #----body----
  dashboardBody
)


  
