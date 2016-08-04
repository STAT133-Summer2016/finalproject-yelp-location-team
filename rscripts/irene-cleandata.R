business <- fromJSON(sprintf("[%s]", 
                             paste(read_lines("yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  flatten() %>% 
  select(open, categories, review_count, longitude, 
         latitude, state, stars, latitude, `attributes.Noise Level`, 
         `attributes.Attire`) %>% 
  # should filter for restaurants 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
names(business) <- c("open", "categories", "count", "long", 
                     "lat", "state", "stars", "noise", "attire")

# Business data with review counts exceeding 300.
us_business <- filter(business, count > 300) 
us_business <- data.frame(lapply(us_business, as.character), 
                          stringsAsFactors=FALSE)
write_csv(subset(us_business), "us-business.csv")

# Data: Star ratings with noise level attribute
noise_level <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ" | state == "NC" | state == "PA") %>% 
  group_by(state, noise) %>% 
  summarise(star = mean(stars)) 
noise_level$noise_factored <- factor(noise_level$noise, 
                                     labels=c("quiet",
                                              "average",
                                              "loud", 
                                              "very_loud"))  
write_csv(subset(noise_level), "noise-attr.csv")

# Data: Star ratings with attire type attribute
attire_type <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ" | state == "NC" | state == "PA") %>% 
  group_by(state, attire) %>% 
  summarise(star = mean(stars))
write.csv(subset(attire_type), "attire-attr.csv")

# Data: 
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
                                      paste(read_lines(
                                        "yelp_academic_dataset_business.json"), 
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

write_csv(subset(user_reviews), "user-reviews.csv")