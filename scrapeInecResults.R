library(tidyverse)
library(httr)
url <- "https://liveresultsapi.civichive.org/api/v1/election/presidential/2023/data"
response <- GET(url)
map_data <- content(response, "text")

library(jsonlite)
parsed_data <- fromJSON(map_data)
states <- parsed_data$data$states
#View(states)

election_results <- unnest(states, parties) |> 
  rename(
    state = alias,
    party = abbr
  )
#write.csv(states_unnested, "2023_results.csv")

# Create a dataframe of Nigerian states and their coordinates
nigeria_coords <- data.frame(
  state = c("abia", "adamawa", "akwa ibom", "anambra", "bauchi", "bayelsa", 
            "benue", "borno", "cross river", "delta", "ebonyi", "edo", 
            "ekiti", "enugu", "gombe", "imo", "jigawa", "kaduna", "kano", 
            "katsina", "kebbi", "kogi", "kwara", "lagos", "nasarawa", 
            "niger", "ogun", "ondo", "osun", "oyo", "plateau", "rivers", 
            "sokoto", "taraba", "yobe", "zamfara"),
  longitude = c(7.4848, 13.2677, 7.8252, 6.9173, 9.8448, 6.2157, 
                8.4943, 13.1514, 8.3349, 5.6246, 8.0833, 5.6166, 
                5.2192, 7.4898, 11.1714, 7.0267, 9.7969, 7.4404, 8.5224, 
                7.5944, 4.1997, 6.7365, 4.5404, 3.3792, 8.5127, 
                6.0733, 3.3573, 4.8361, 4.8343, 4.5560, 8.8912, 7.0819, 
                5.2464, 11.8964, 12.1656, 6.1906),
  latitude = c(5.5428, 10.2679, 4.9760, 6.2104, 10.3113, 4.8990, 
               7.7294, 11.8333, 5.8980, 5.8980, 6.2456, 6.3350, 
               7.6333, 6.4413, 10.2897, 5.4304, 12.7900, 10.5222, 11.9998, 
               12.9855, 12.4500, 7.8206, 8.4797, 6.4551, 8.5687, 
               9.0819, 7.3876, 7.0737, 7.5264, 8.1374, 9.0108, 4.8193, 
               13.0587, 8.4966, 8.2634, 11.7454)
)

# Print the resulting dataframe
nigeria_coords

election_results <- left_join(election_results, nigeria_coords, by="state") |> 
  select(1:7,10:11)