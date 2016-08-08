# Function to Computer Mean Star Rating for given sentiment score
# Args: score - sentiment score to subset summaries dataset by

MeanStar <- function(sentiment) {
  valence <- summaries %>% 
    filter(score == sentiment)
  return(mean(valence$average_star))
}