source('requirement.R')
source('helper_functions.R')
#source('get_data.R')
source('data_wrangle.R')

countries = sort(unique(confirmed$`Country/Region`), decreasing=FALSE)

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
      text=paste('Last Updated: ', dataUpdateTime, sep='')
    )
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
    ),
    convertMenuItem(
      menuItem(
        text='Trajectory',
        tabName='trajectory',
        selectInput(
          inputId='trajecotryCountry',
          choices=countries,
          selected='India',
          label='Select Country'
        )
      ),
      tabName='trajectory'
    ),
    convertMenuItem(
      menuItem(
        text='About',
        tabName='about'
      ),
      tabName='about'
    )
  )
)

dashboardBody = dashboardBody(
  
  tags$head(includeHTML('google-analytics.html')),
  
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
          tabPanel(
            'Daily New Cases',
            plotlyOutput('indiaDailyNewCases')
          ),
          tabPanel(
            'States New Cases',
            plotlyOutput('indiaStateHeatMap')
          ),
          width=12
        )
      )
    ),
    
    #trajectory tab
    tabItem(
      tabName='trajectory',
      fluidRow(
        box(
          title='Compare Trajectory of selected Country',
          solidHeader = TRUE,
          status='primary',
          plotlyOutput('trajectory'),
          width=12
        )
      )
    ),
    
    #about tab
    tabItem(
      tabName='about',
      fluidRow(
        box(
          title=strong('About',style='font-size:25px;'),
          strong('Data', style='font-size:20px;'),
          br(),
          tags$li(
            a('The data associated with countries (tab: country, compare and trajectory) is taken from Jhon Hopkins covid 19 github repo', href='https://github.com/CSSEGISandData/COVID-19', title='')
          ),
          tags$li(
            a('The data under India tab is taken from Ministry of health and family welfare, Government of India', href='https://www.mohfw.gov.in/', title='')
          ),
          br(),
          strong('Data Update', style='font-size:20px;'),
          tags$li(
            'The data is updated daily at around 6 pm IST, including from both the data sources as listed above'
          ),
          br(),
          strong('Support', style='font-size:20px;'),
          tags$li(
            a('If you find this site useful, consider donating, as it will allow me to move it to dedicated hosting service', href='https://paypal.me/mohit2013')
          ),
          tags$li(
            a('Project on github', href='https://github.com/mohit2152sharma/rcoronavirus')
          ),
          tags$li(
            'For suggestions and collaboration: mohitlakshya@gmail.com'
          ),
          br(),
          strong('Developed By', style='font-size:20px;'),
          tags$li(
            'Mohit'
          ),
          width=12,
          style='font-size:20px;'
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


  
