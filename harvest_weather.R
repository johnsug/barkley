
# Load necessary packages
library(httr)
library(jsonlite)
library(lubridate)

# Set up API request parameters
url <- "https://api.openweathermap.org/data/2.5/weather"
city <- "Wartburg"
state <- "Tennessee"
api_key <- "022da18ff799d24697e4806979d88324"

# Define function to get weather data
get_weather_data <- function() {
  params <- list(q = paste(city, state, sep = ","), appid = api_key, units = "imperial")
  response <- GET(url, query = params)
  if (response$status_code == 200) {
    data <- fromJSON(content(response, "text"), flatten = TRUE)
    return(data)
  } else {
    stop("Failed to retrieve weather data.")
  }
}

# Define function to write weather data to file
write_weather_data <- function(data) {
  file_path <- paste0("weather_data_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
  write.table(data, file = file_path, append = TRUE, sep = ",", col.names = !file.exists(file_path))
}

# Harvest weather data every 15 minutes
while (TRUE) {
  data <- get_weather_data()
  write_weather_data(data)
  Sys.sleep(15 * 60) # Wait 15 minutes before next request
}
