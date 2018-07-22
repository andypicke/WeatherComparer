# WeatherComparer

A Shiny App to compare weather from one year to a historical average over several years.

I'm a bit of weather geek and I often find myself saying "this January seems warmer than normal" or something similar (<https://andypicke.github.io/Summer-In-February/>). So I decided to make a Shiny app that will let you explore this type of question for different cities, months, and years.

Check it out at : <https://andypicke.shinyapps.io/WeatherComparer/>

You can also download *scripts.R* and *app.R* and run locally on your own machine in RStudio.

Right now it only does temperature, but I am planning to expand it for other variables.

Data is gathered from <https://www.wunderground.com/>, as described in <https://github.com/andypicke/wunderground_data>.

## Using the app

### Input
On the sidebar, you can select several options:
* Year to Compare: This is the data you would like to compare to the historical averages.
* Compare from Year/to year: This is the historical data you will compare to.
* Months to include in comparison.
* Station (airport)

After making selections, click the *execute* button to update the results.

### Output
* Historical temperatures, averaged over the years chosen, is plotted as black line. The gray shading shows +/- 1 standard deviation of the historical temperatures over this time period. Current data is potted as red dots.

* The difference plot makes it easier to see periods where the current temperatures are warmer/colder than the historical average.

* Station info lists all the available weather stations and their codes, which can be intered in the inputs.

* The data is also given in tables for inspection, and is available for download as csv files.s


## Current status

As noted on <https://github.com/andypicke/wunderground_data>, historical weather data is no longer free to download from the wunderground API. Thus, the app currently works only for data through part of 2017. I plan to try find a new method to obtain temperature data for the aiport stations so the app can be used to examine current conditions as well. Stay tuned...s
