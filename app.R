#
# This is a Shiny web application to compare temperatures for one year to the average over a specified year range. Based on my "summer_in_february" blog post.
#
#
# INPUTS
# - station : The station code for an airport to compare at
# - year_to_compare 
# - year1
# - month 1
# - year2
# - month 2
#
# OUTPUTS
# Plots of temp from year_to_compare, with historical average from year_1 to year_2
#
#

# To Do
# Make leaflet map of stations so you can find the station code
# 

library(shiny)
library(dplyr)
library(readr)
library(curl)
library(lubridate)
library(ggplot2)
source("scripts.R")




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UI
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ui <- fluidPage(
        
        # Application title
        titlePanel("It's getting hot (cold) in here"),
        
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        numericInput("the_year","Year To Compare",2017,1970,2017,step=1),
                        numericInput("year1","Compare from year:",2010,1970,2017,step=1),
                        numericInput("year2","To year:",2016,1970,2017,step=1),
                        numericInput("month1","Between month:",1,12,1,step=1),
                        numericInput("month2","And month:",1,12,2,step=1),
                        textInput("stcode","At Airport Station Code:",value = "KDEN"),
                        actionButton("button", "Execute!")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        
                        h5("Use this app to compare current temperatures to past averages. Select the current year, and the year and month range to compare to. The plot shows the historical average and stand. dev., and the values from the current year."),
                        h5("Source code is available at https://github.com/andypicke/WeatherComparer"),
                        
                        tabsetPanel(
                                tabPanel("Plot",plotOutput('plot1')),
                                tabPanel("Plot2",plotOutput('plot2')),
                                tabPanel("Current Data",dataTableOutput('table')),
                                tabPanel("merge Data",dataTableOutput('tablemerge')),
                                tabPanel("Historical Avg Data",dataTableOutput('table_avg'))
                        )
                        
                )
        )
)






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SERVER
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

server <- function(input, output) {
        
        
        observeEvent(input$button,{
                
                # download weather for 'current' year
                dat <- reactive({get_yearly_weather(input$stcode,input$the_year,month_start=input$month1, month_end=input$month2) })
                
                output$table <- renderDataTable(dat())

                # download weather for all years in range
                dat_all <- reactive({get_all_years(input$year1,input$year2,input$stcode,input$month1,input$month2)})
                
                # average temp for each day
                dat_avg <- reactive({get_avg_temps(dat_all())})
                
                output$table_avg <- renderDataTable(dat_avg())
                
                # join current and average so we can plot differences
                dat_merge <- reactive({left_join(dat(),dat_avg())})
                
                output$tablemerge <- renderDataTable(dat_merge())
                
                
                
                # Plot historical average and current data
                output$plot1 <- renderPlot({
                        input$button
                        isolate(
                                ggplot(dat_avg(),aes(yday,tavg))+
                                        theme(text = element_text(size = 16)) +
                                        geom_line(size=2) +
                                        geom_line(aes(yday,sd_low),size=1.5,color='grey',linetype='dashed') +
                                        geom_line(aes(yday,sd_high),size=1.5,color='grey',linetype='dashed') +
                                        geom_point(data=dat(),aes(x=yday, y=mean_temp),size=2, color='red') +
                                        ggtitle(paste("Comparing ",input$the_year,"data to average from ", input$year1,"to",input$year2)) +
                                        ylab("Mean Daily Temperature")+
                                        xlab("Yearday")
                        )
                })
                
                
                # Plot DIFFERENCES between current year and historical averages
                output$plot2 <- renderPlot({
                        input$button
                        isolate(
                                ggplot(dat_merge(),aes(x=yday,y=mean_temp-tavg)) +
                                        theme(text = element_text(size = 16)) +
                                        geom_point()
                        )
                })
                
        })
}

# Run the application 
shinyApp(ui = ui, server = server)

