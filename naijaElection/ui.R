library(tidyverse)
library(httr)
url <- "https://liveresultsapi.civichive.org/api/v1/election/presidential/2023/data"
response <- GET(url)
map_data <- content(response, "text")

library(jsonlite)
parsed_data <- fromJSON(map_data)
states <- parsed_data$data$states
#View(states)

states_unnested <- unnest(states, parties)

library(shiny)
library(dplyr)
library(leaflet)


fluidPage(
  titlePanel("Nigeria Election Results"),
  sidebarLayout(
    sidebarPanel(
      # Create a dropdown for selecting the party name
      selectInput("party", "Select Party:",
                  choices = unique(state_unnested$`Party name`)),
      # Create a slider for filtering by the number of local governments
      sliderInput("lgas", "Number of Local Governments:",
                  min = 1, max = max(state_unnested$`Number of Local Governments`), value = 10)
    ),
    mainPanel(
      # Create a map showing the total votes by state
      leafletOutput("map")
    )
  )
)