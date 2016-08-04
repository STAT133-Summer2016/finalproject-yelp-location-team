library(jsonlite)
library(dplyr)
library(tidyr)
library(readr)
library(tidytext)
library(stringr)

# Read in raw data
business <- fromJSON(sprintf("[%s]", 
                     paste(read_lines("../rawdata/yelp_academic_dataset_business.json"), 
                     collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()

reviews <- fromJSON(sprintf("[%s]", 
                    paste(read_lines("../rawdata/yelp_academic_dataset_business.json", 
                                     n_max = 500000), 
                    collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()

users <- fromJSON(sprintf("[%s]", 
                  paste(read_lines("../rawdata/yelp_academic_dataset_users.json"), 
                  collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()

## Sentiment Analysis tidying

# unnest_tokens splits column into tokens using tokenizers package
# splits "text" column into individual words to analyze sentiment for further
# exploration
reviews_text <- reviews %>% 
  select(business_id, review_id, stars, text) %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  arrange(review_id)

# rank words from -5 (negativity) to 5 (positivity) using AFINN lexicon
# sentiments: 
#   data frame with 4 variables: word, sentiment, lexicon, score
# lexicon can be "nrc", "bing", or "AFINN"
valence_score <- sentiments %>% 
  filter(lexicon == "AFINN") %>% 
  select(word, score)

# calculate mean for each group of stars
# Tidied csv: review_id, star rating, average sentiment score
review_scores <- reviews_text %>% 
  inner_join(valence_score, by = "word") %>% 
  group_by(review_id, stars) %>% 
  summarise(sentiment = mean(score))

# create summary of words and their average sentiment score in each unique
# review and filter for >= 500 reviews and >= 10 businesses
# Tidied csv: word, # of businesses word appears, # of reviews word appears,
# # of different uses of word, average stars of word
review_words <- reviews_text %>% 
  count(review_id, business_id, stars, word) %>% 
  ungroup()
summaries <- review_words %>% 
  group_by(word) %>% 
  summarise(business = n_distinct(business_id),
            reviews = n(),
            use = sum(n),
            average_star = mean(stars)) %>% 
  ungroup() %>% 
  filter(reviews >= 500, business >= 10) %>% 
  inner_join(valence_score, by = "word")

# WRITE ALL CSV FILES HERE
write_csv(review_scores, "review_scores.csv")
write_csv(review_words, "review_words.csv")