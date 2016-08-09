# Header
# This script tidies the raw JSON data and writes the tidied data into CSV file
# formats

# libraries
library(jsonlite)
library(dplyr)
library(readr)

# Data: 
# Read in raw data convert to data frames
business <- fromJSON(sprintf("[%s]", 
                     paste(read_lines(
                       "../raw_data/yelp_academic_dataset_business.json"), 
                     collapse = ","))) %>% 
  flatten() %>% 
  data.frame() %>% 
  select(business_id, open, categories, review_count, state, stars, 
         `attributes.Noise.Level`, `attributes.Attire`, `attributes.Take.out`,
         `attributes.Takes.Reservations`, `attributes.Delivery`,
         `attributes.Outdoor.Seating`, `attributes.Accepts.Credit.Cards`,
         `attributes.Happy.Hour`) %>% 
  filter(open == TRUE, "Restaurants" %in% categories, state %in% state.abb)
business <- data.frame(lapply(business, as.character), stringsAsFactors=FALSE)

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

# ------------------- Mutating Data for Sentiment Graphs Below -----------------------
review_sample <- read_csv("yelp_reviews.csv") %>% 
  sample_n(500000)
reviews_text <- review_sample %>% 
  select(business_id, review_id, stars, text) %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  arrange(review_id)

write_csv(reviews_text, "reviews_text.csv")

# rank words from -5 (negativity) to 5 (positivity) using AFINN lexicon
# sentiments: 
#   data frame with 4 variables: word, sentiment, lexicon, score
# lexicon can be "nrc", "bing", or "AFINN"
valence_score <- sentiments %>% 
  filter(lexicon == "AFINN") %>% 
  select(word, score)

# calculate mean for each review
# Tidied: review_id, star rating, average sentiment score
review_scores <- reviews_text %>% 
  inner_join(valence_score, by = "word") %>% 
  group_by(review_id, stars) %>% 
  summarise(sentiment = mean(score))
write_csv(review_scores, "review_scores.csv")

review_words <- reviews_text %>% 
  count(review_id, business_id, stars, word) %>% 
  ungroup()
summaries <- review_words %>% 
  group_by(word) %>% 
  summarise(business = n_distinct(business_id),
            reviews = n(),
            average_star = mean(stars)) %>% 
  ungroup() %>% 
  filter(reviews >= 500, business >= 10) %>% 
  inner_join(valence_score, by = "word")
head(summaries, n = 10)
write_csv(summaries, "summaries.csv")