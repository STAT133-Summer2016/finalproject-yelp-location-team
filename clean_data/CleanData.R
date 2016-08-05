library(jsonlite)
library(dplyr)
library(readr)

# Read in raw data convert to data frames
business <- fromJSON(sprintf("[%s]", 
                             paste(read_lines("../raw_data/yelp_academic_dataset_business.json"), 
                                   collapse = ","))) %>% 
  flatten() %>% 
<<<<<<< HEAD
  data.frame()
=======
  select(business_id, open, categories, review_count, state, stars, 
         `attributes.Noise Level`, `attributes.Attire`, `attributes.Take-out`,
         `attributes.Takes Reservations`, `attributes.Delivery`,
         `attributes.Outdoor Seating`, `attributes.Accepts Credit Cards`,
         `attributes.Happy Hour`) %>% 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
business <- data.frame(lapply(business, as.character), stringsAsFactors=FALSE)
>>>>>>> f2c09d1744a6671f9355ee7b97639d4970a94b7e

reviews <- fromJSON(sprintf("[%s]", 
                    paste(read_lines(
                      "../raw_data/yelp_academic_dataset_review.json"), 
                    collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()

users <- fromJSON(sprintf("[%s]", 
                  paste(read_lines(
                    "../raw_data/yelp_academic_dataset_user.json"), 
                  collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()
users <- data.frame(lapply(users, as.character), stringsAsFactors=FALSE)

# Write data-frames to csvs
write_csv(business, "yelp_business.csv")
write_csv(reviews, "yelp_reviews.csv")
write_csv(users, "yelp_users.csv")