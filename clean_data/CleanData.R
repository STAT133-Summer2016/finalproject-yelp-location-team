business <- fromJSON(sprintf("[%s]", 
                             paste(readLines("yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  flatten() %>% 
  select(open, categories, review_count, longitude, latitude, state, stars, latitude, `attributes.Noise Level`, `attributes.Attire`) %>% 
  # should filter for restaurants 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
names(business) <- c("open", "categories", "count", "long", "lat", "state", "stars", "noise", "attire")

# Business data with review counts exceeding 300.
us_business <- filter(business, count > 300) 
us_business <- data.frame(lapply(us_business, as.character), 
                          stringsAsFactors=FALSE)
write.csv(subset(us_business), "us-business.csv")

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
write.csv(subset(noise_level), "noise-attr.csv")

# Data: Star ratings with attire type attribute
attire_type <- business %>% 
  na.omit() %>% 
  filter(state == "NV" | state == "AZ" | state == "NC" | state == "PA") %>% 
  group_by(state, attire) %>% 
  summarise(star = mean(stars))
write.csv(subset(attire_type), "attire-attr.csv")
