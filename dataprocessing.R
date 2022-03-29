# Creating the initial dataset
library(pageviews)
rm(list = ls())

# Params
start = as.POSIXct("2015/07/01") 
cutoff = as.POSIXct("2022/02/01") - 60*60
get_hourly = FALSE

# Pulling Daily Data
daily_data = project_pageviews(project = "en.wikipedia", platform = "all", user_type = "all", granularity = "daily", start = pageview_timestamps(start), end = pageview_timestamps(cutoff), reformat = TRUE)%>% select(date, views)
daily_data = data.frame(views = daily_data$views, date = daily_data$date)

# Pulling Hourly Data
if (get_hourly) {

hourly_data = project_pageviews(project = "en.wikipedia", platform = "all", user_type = "all", granularity = "hourly", start = pageview_timestamps(start), end = pageview_timestamps(cutoff), reformat = TRUE)
start = start + 5000*60*60
while (start < cutoff) {
  # print(start)
  temp = project_pageviews(project = "en.wikipedia", platform = "all", user_type = "all", granularity = "hourly", start = pageview_timestamps(start), end = cutoff, reformat = TRUE)
  hourly_data = rbind(hourly_data, temp) 
  start = start + 5000*60*60
}

write_csv(hourly_data, 'hourlydata.csv')
}

# Raw data
 write_csv(daily_data, 'dailydata.csv')

