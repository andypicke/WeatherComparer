
## various functions used in the WeatherComparer app


#~~~~~~~~~~ download the data for specified years
get_yearly_weather <- function (year,st_code){
        the_url <- paste0("http://www.wunderground.com/history/airport/",st_code,"/",year,"/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=",year,"&req_city=NA&req_state=NA&req_statename=NA&format=1")
        wea <- read_csv(the_url,skip=1,col_types = cols())
        cols <- colnames(wea)
        cols[1]<-"date"
        colnames(wea)<-cols
        wea <- wea %>% 
                mutate(date=as.Date(date))%>%
                mutate(yday=yday(date)) %>%
                mutate(year=year(date)) %>%
                select(date,year,yday,`Max TemperatureF`,`Mean TemperatureF`,`Min TemperatureF`) %>%
                rename(max_temp=`Max TemperatureF`) %>%
                rename(mean_temp=`Mean TemperatureF`) %>%
                rename(min_temp=`Min TemperatureF`) %>%
                filter(max_temp<150) %>%
                filter(max_temp>-50)
        #filter(yday<80)
        wea
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~



# download and combine data for all years in range
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_all_years <- function(year1,year2,st_code){
        require(readr)
        require(lubridate)
        require(dplyr)
        years <- seq(year1,year2)
        dat_all <- data.frame()
        for (i in seq_along(years)){
                print(paste("getting data for ",st_code,"for year",years[i]))
                # download data for one year
                dat <- get_yearly_weather(years[i],st_code)
                # append onto other data we already downloaded
                dat_all <- bind_rows(dat_all,dat)
        }
        # return dat_all
        dat_all
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~



# compute averages for output of get_all_years
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_avg_temps <- function(dat_all){
        dat_all %>% 
                group_by(yday) %>% 
                summarise(tavg=mean(max_temp,na.rm=TRUE))
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~





