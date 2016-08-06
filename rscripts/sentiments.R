# Sentiment Analysis for Yelp Text Reviews
# Using tidytext and AFINN lexicon, assign valence score to words in text reviews
# to classify star ratings of Yelp businesses
library(jsonlite)
library(readr)
library(httr)
library(stringr)
library(tidytext)
library(dplyr)
library(tidyr)
library(ggplot2)

library(tm)
# users <- fromJSON(sprintf("[%s]", 
#                             paste(readLines("data/yelp_academic_dataset_user.json"), 
#                                   collapse = ",")))
reviews <- fromJSON(sprintf("[%s]", 
                    paste(read_lines("data/yelp_academic_dataset_review.json", 
                                     n_max = 500000), 
                    collapse = ","))) %>% 
  flatten() %>% 
  tbl_df()

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
review_scores <- reviews_text %>% 
  inner_join(valence_score, by = "word") %>% 
  group_by(review_id, stars) %>% 
  summarise(sentiment = mean(score))

write_csv(reviews_text, "data/reviews_text.csv")
write_csv(valence_score, "data/valence_score.csv")

ggplot(review_scores) +
  geom_boxplot(aes(stars, sentiment, group = stars)) +
  labs(x = "Business Rating",
       y = "Average Sentiment Score",
       title = "Average Sentiment Score vs. Business Rating")
  