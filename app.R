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
                        numericInput("month1","Between month:",1,min=1,max=12,step=1),
                        numericInput("month2","And (including) month:",12,min=1,max=12,step=1),
                        textInput("stcode","At Airport (see 'Station Info' tab):",value = "KDEN"),
                        actionButton("button", "Execute!")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        
                        h5("Use this app to compare current temperatures to past averages. Select the current year, and the year and month range to compare to. The plot shows the historical average and stand. dev., and the values from the current year."),
                        h5("Source code is available at https://github.com/andypicke/WeatherComparer"),
                        
                        downloadButton('downloadData', 'Download Current Data'),
                        downloadButton('downloadData_hist', 'Download historical Data'),
                        
                        tabsetPanel(
                                tabPanel("Plot",plotOutput('plot1')),
                                tabPanel("Difference Plot",plotOutput('plot2')),
                                tabPanel("Current Data",dataTableOutput('table')),
                                tabPanel("merge Data",dataTableOutput('tablemerge')),
                                tabPanel("Historical Avg Data",dataTableOutput('table_avg')),
                                tabPanel("Station Info",dataTableOutput('sta_info'))
                        )
                        
                )
        )
)






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SERVER
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

server <- function(input, output) {
        
        output$sta_info <- renderDataTable(sta_df)
        
        observeEvent(input$button,{
                
                # download weather for 'current' year
                dat <- reactive({get_yearly_weather(input$stcode,input$the_year,month_start=input$month1, month_end=input$month2) })
                
                # output data frame as table to view in app
                output$table <- renderDataTable(dat())

                # make table downloadable as csv
                output$downloadData <- downloadHandler(
                        filename = function() { 'current_data.csv' }, content = function(file) {
                                write.csv(dat(), file, row.names = FALSE)
                        })
                
                
                # download weather for all years in range
                dat_all <- reactive({get_all_years(input$year1,input$year2,input$stcode,input$month1,input$month2)})
                
                # make table downloadable as csv
                output$downloadData_hist <- downloadHandler(
                        filename = function() { 'hist_data.csv' }, content = function(file) {
                                write.csv(dat_all(), file, row.names = FALSE)
                        })
                
                
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
                                        geom_ribbon(aes(ymin=sd_low,ymax=sd_high),fill='grey') +
                                        
                                        theme(text = element_text(size = 16)) +
                                        geom_line(size=2) +
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
                                        ylab('Current - average') +
                                        xlab('Yearday') +
                                        ggtitle('Difference between current year and hist avg.') +
                                        geom_col(aes(fill=(mean_temp-tavg)<0)) 
                                        #geom_bar(stat='identity',fill='grey') 
                                        
                                        
                        )

                })
                
        })
}

# Run the application 
shinyApp(ui = ui, server = server)

