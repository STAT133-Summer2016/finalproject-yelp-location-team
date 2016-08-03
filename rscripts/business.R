library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggmap)
library(maps)
library(jsonlite)

business <- fromJSON(sprintf("[%s]", 
                             paste(readLines("yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  flatten() %>% 
  select(open, categories, review_count, state, stars, `attributes.Noise Level`, `attributes.Attire`, `attributes.Take-out`, `attributes.Takes Reservations` `attributes.Delivery`, `attributes.Outdoor Seating`, `attributes.Accepts Credit Cards`,`attributes.Happy Hour`) %>% 
  # should filter for restaurants 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
names(business) <- c("open", "categories", "count", "long", "lat", "state", "stars", "noise", "attire")
states <- map_data('state')
# Show data from all over US
us_business <- filter(business, count > 300)
ggplot(states) + 
  geom_polygon(aes(x = long, 
                   y = lat, 
                   group = group), 
               fill = "grey80", 
               color = "white") + 
  coord_fixed(1.3) + 
  geom_point(data = us_business, 
             aes(long, 
                 lat, 
                 color = factor(stars), 
                 size = count), 
             alpha = 0.7) + 
  guides(colour = guide_legend("Star Rating"), 
         size = guide_legend("Review Counts")) + 
  labs(title = "Restaurant Reviews in United States") +
  theme_nothing(legend = TRUE)
# Show number of businesses in each state (popularity) 
top_data <- us_business %>% 
  group_by(state) %>% 
  tally()

big_cities <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ" | state == "NC" | state == "PA")
# Focusing on attribute noise level
noise_data <- big_cities %>% 
  group_by(state, noise) %>% 
  summarise(star = mean(stars)) 
noise_data$noise_factored <- factor(noise_data$noise, 
                                labels=c("quiet",
                                         "average",
                                         "loud", 
                                         "very_loud"))  
ggplot(data=noise_data, aes(x=noise_factored, y=star, fill=state)) +
  geom_bar(stat="identity", position = "dodge") +
  scale_x_discrete(labels=c("Quiet", "Average", "Loud", "Very Loud")) +
  labs(title = "How Noise Level Influences Average Star Ratings") + 
  xlab("Noise Level") + 
  ylab("Average Star Ratings") +
  guides(fill = guide_legend("Region"))

# Focusing on attribute attire
attire_data <- big_cities %>% 
  group_by(state, attire) %>% 
  summarise(star = mean(stars))
ggplot(data=attire_data, aes(x=attire, y=star, fill=state)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "How Attire Influences Average Star Ratings") + 
  xlab("Attire") + 
  ylab("Average Star Ratings") + 
  guides(fill = guide_legend("Region"))

