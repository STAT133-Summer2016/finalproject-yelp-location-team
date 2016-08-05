library(jsonlite)
library(dplyr)
library(readr)

# Read in raw data convert to data frames
business <- fromJSON(sprintf("[%s]", 
                     paste(read_lines(
                       "../raw_data/yelp_academic_dataset_business.json"), 
                     collapse = ","))) %>% 
  flatten() %>% 
  data.frame()

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

# Write data-frames to csvs
write_csv(business, "yelp_business.csv")
write_csv(reviews, "yelp_reviews.csv")
write_csv(users, "yelp_users.csv")