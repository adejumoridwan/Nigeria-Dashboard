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

# Define the server
server <- function(input, output) {
  
  # Filter the data based on the party name and number of local governments
  filtered_data <- reactive({
    state_unnested %>%
      filter(`Party name` == input$party, `Number of Local Governments` >= input$lgas)
  })
  
  # Create the map
  output$map <- renderLeaflet({
    # Aggregate the data by state
    state_data <- filtered_data() %>%
      group_by(State) %>%
      summarize(`Total Votes` = sum(`Number of votes`))
    
    # Create a leaflet map
    leaflet(state_data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = 8, lat = 9, zoom = 6) %>%
      addMarkers(lng = ~mean(c(-14, 14)), lat = ~mean(c(4, 16)), popup = ~paste0("<b>", State, "</b><br>Total Votes: ", `Total Votes`))
  })
}