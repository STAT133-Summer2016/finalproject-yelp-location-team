# Function
# Determine percent accuracy of sentiment analysis for list of words above
# mean star rating of all reviews
# Args: word - vector of words from reviews

PercentAccuracy <- function(word) {
  above_or_below <- word %>% 
    filter(average_star >= mean(reviews$stars))
  percent <- nrow(above_or_below) / nrow(word)
  return(percent)
}