
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script contains various functions used in the WeatherComparer app.
# I put them here to make the app.R file cleaner and more readable.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load dataframe w/ list of airport stations and codes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sta_df <- read.csv('USAirportWeatherStations.csv')



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# function to download cleaned weather data for a station
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_weather_cleaned <- function(st_code){
        url_base <- 'https://s3-us-west-2.amazonaws.com/wundergrounddaily/cleaned/'
        s3_url <- paste0(url_base, st_code, '_cleaned.csv')
        wea<-read.csv(s3_url)
        wea$date <- lubridate::ymd(wea$date)
        wea
}

get_weather_cleaned_oneyear <- function(st_code,the_year,month_start,month_end){
        url_base <- 'https://s3-us-west-2.amazonaws.com/wundergrounddaily/cleaned/'
        s3_url <- paste0(url_base, st_code, '_cleaned.csv')
        wea<-read.csv(s3_url)
        wea$date <- lubridate::ymd(wea$date)
        wea <- wea %>% filter(year==the_year) %>%
                filter(month>=month_start & month<=month_end)
        wea
}


get_all_years <- function(year1,year2,st_code,month_start,month_end){
        url_base <- 'https://s3-us-west-2.amazonaws.com/wundergrounddaily/cleaned/'
        s3_url <- paste0(url_base, st_code, '_cleaned.csv')
        wea<-read.csv(s3_url)
        wea$date <- lubridate::ymd(wea$date)
        wea <- wea %>%
                filter(year>=year1 & year<=year2) %>%
                filter(month>=month_start & month<=month_end)
        wea
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# function to return data for only 'current' year
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_current_year <- function(wea,the_year){
        wea_current <- wea %>%
                filter(year==the_year)
        wea_current
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# compute daily averages and standard deviation over all years
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_avg_temps <- function(wea){
        wea_avg <- wea %>%
                group_by(yday) %>%
                summarise(tavg=mean(mean_temp,na.rm=TRUE),
                          sd_low=tavg-sd(mean_temp,na.rm=TRUE),
                          sd_high=tavg+sd(mean_temp,na.r=TRUE))
        wea_avg
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
