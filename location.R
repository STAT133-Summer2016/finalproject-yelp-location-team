library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggmap)
library(maps)
library(jsonlite)

review <- fromJSON(sprintf("[%s]", 
                           paste(read_lines("yelp_academic_dataset_review.json", 
                                            n_max = 1500000), 
                                 collapse = ","))) %>% 
  select(user_id, review_id, stars, business_id)


user <- fromJSON(sprintf("[%s]", 
                         paste(read_lines("yelp_academic_dataset_user.json",
                                          n_max = 100000), 
                               collapse = ",")))

business_location <- fromJSON(sprintf("[%s]", 
                             paste(readLines("yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  select(business_id, city)

user <- user[order(-user$review_count),] %>% 
  head(15) %>% 
  select(name, user_id, review_count)

# Join user and review by user_id
user_reviews <- left_join(user, review) %>% 
  left_join(business_location) 
  
u <- group_by(user_reviews, user_id, city) %>% 
  tally()

max_reviews <- aggregate(n ~ user_id, u, max) %>% 
  left_join(u) %>% 
  select(-n) %>% 
  mutate(max_review=TRUE)

user_reviews <- left_join(user_reviews, max_reviews) 
user_reviews[is.na(user_reviews)] <- FALSE

user_reviews <- user_reviews %>% 
  group_by(name, max_review) %>% 
  summarise(val = mean(stars)) %>% 
  mutate(count = n()) %>% 
  filter(count == 2)

ggplot(user_reviews, aes(x = max_review,
                         y = val)) +
  geom_bar(stat = "identity", 
           position = "dodge") + 
  facet_wrap(~name) + 
  labs(title = "Reviewers' Behavior Changes When In Unfamilar Locations") +
  xlab("Location") + 
  ylab("Star Ratings") +
  scale_x_discrete(labels=c("Travelling", "Home"))
  scale_x_discrete(labels=c("Travelling", "Home"))