# WeatherComparer

A Shiny App to compare weather from one year to a historical average over several years.

I'm a bit of weather geek and I often find myself saying "this January seems warmer than normal" or something similar (<https://andypicke.github.io/Summer-In-February/>). So I decided to make a Shiny app that will let you explore this type of question for different cities, months, and years.

Check it out at : <https://andypicke.shinyapps.io/WeatherComparer/>

You can also download *scripts.R* and *app.R* and run locally on your own machine in RStudio.

Right now it only does temperature, but I am planning to expand it for other variables.

Data is from weather underground website. After clicking through to download some data once, it was easy to figure out the API from the url and modify it for different locations and time ranges.

## To-Do
- Add a leaflet map to let you find stations and their codes
- Query data from database instead of downloading. Right now, it downloads the yearly weather files from the wunderground website each time it is run, so it is slow (especially if you go back more than a few years). I'm working on downloading all the weather data into a sql database that the app can query instead.
- Add other variables (max,min temps, precipiation, wind, etc.)
- Do by date rather than yearday? I like yearday for easily lining up data, but it occurred to me that maybe using yearday and averaging over years that include leap years is not quite correct?
