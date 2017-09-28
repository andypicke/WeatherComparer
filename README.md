# WeatherComparer

A Shiny App to compare weather from one year to a historical average over several years.

I'm a bit of weather geek and I often find myself saying "this January seems warmer than normal" or something similar (<https://andypicke.github.io/Summer-In-February/>). So I decided to make a Shiny app that will let you explore this type of question for different cities, months, and years.

Check it out at : <https://andypicke.shinyapps.io/WeatherComparer/>

You can also download *scripts.R* and *app.R* and run locally on your own machine in RStudio.

Right now it only does temperature, but I am planning to expand it for other variables.

Data is gathered from <https://www.wunderground.com/>, as described in <https://github.com/andypicke/wunderground_data>.

## To-Do
- Add a leaflet map to let you find stations and their codes
- Add other variables (max,min temps, precipiation, wind, etc.)
- Do by date rather than yearday? I like yearday for easily lining up data, but it occurred to me that maybe using yearday and averaging over years that include leap years is not quite correct?
