library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggmap)
library(maps)

business <- fromJSON(sprintf("[%s]", 
                             paste(readLines("yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  flatten() %>% 
  select(open, categories, review_count, longitude, latitude, state, stars, latitude, `attributes.Noise Level`, `attributes.Attire`) %>% 
  # should filter for restaurants 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
names(business) <- c("open", "categories", "count", "long", "lat", "state", "stars", "noise", "attire")
states <- map_data('state')
# Show data from all over US
us_business <- filter(business, review_count > 300)
ggplot(states) + 
  geom_polygon(aes(x = long, 
                   y = lat, 
                   group = group), 
               fill = "grey80", 
               color = "white") + 
  coord_fixed(1.3) + 
  geom_point(data = us_business, 
             aes(longitude, 
                 latitude, 
                 color = stars, 
                 size = review_count), 
             alpha = 0.5)
# Show number of businesses in each state (popularity) 
top_data <- us_business %>% 
  group_by(state) %>% 
  tally()

# Focusing on attribute noise level
noise_data <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ") %>% 
  group_by(state, noise) %>% 
  summarise(star = mean(stars))
ggplot(data=noise_data, aes(x=noise, y=star, fill=state)) +
  geom_bar(stat="identity", position = "dodge") 

# Focusing on attribute attire
attire_data <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ") %>% 
  group_by(state, attire) %>% 
  summarise(star = mean(stars))
ggplot(data=attire_data, aes(x=attire, y=star, fill=state)) +
  geom_bar(stat="identity", position = "dodge") 
