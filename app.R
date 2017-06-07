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


# Define UI for application that draws a histogram
ui <- fluidPage(
        
        # Application title
        titlePanel("Weather Comparer"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        numericInput("the_year","Year To Compare",2016,1970,2017,step=1),
                        numericInput("year1","Year 1",2015,1970,2017,step=1),
                        numericInput("year2","Year 2",2016,1970,2017,step=1),
                        numericInput("month1","Month 1",1,12,1,step=1),
                        numericInput("month2","Month 2",1,12,2,step=1),
                        textInput("stcode","Airport Station Code",value = "KDEN"),
                        actionButton("button", "An action button")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        plotOutput('plot1'),
                        dataTableOutput('table')
                )
        )
)


# Define server logic 

library(shiny)
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)
source("scripts.R")

server <- function(input, output) {
        
        
        dat <- reactive({get_yearly_weather(input$stcode,input$the_year,month_start=input$month1, month_end=input$month2) })
        output$table <- renderDataTable(dat())
        
        # download weather for all years in range
        observeEvent(input$button,{
                
                dat_all <- reactive({get_all_years(input$year1,input$year2,input$stcode,input$month1,input$month2)})

                # average temp for each day
                #dat_avg <- reactive({get_avg_temps(dat_all())})
                #dat_avg <-get_avg_temps(dat_all)
                dat_avg <- reactive({get_avg_temps(dat_all())})
                
                
                
                
#                output$plot1 <- renderPlot({
#                        input$button
#                        isolate(ggplot(dat(),aes(yday,max_temp))+
#                                        geom_point())
#                })
                
                output$plot1 <- renderPlot({
                        input$button
                        isolate(
                                ggplot(dat_avg(),aes(yday,tavg))+
                                        geom_line()+
                                        geom_point(data=dat(),aes(yday,max_temp))+
                                        ggtitle(paste(input$year1,"to",input$year2))
                        )
                })
                
                
        })
}

# Run the application 
shinyApp(ui = ui, server = server)

