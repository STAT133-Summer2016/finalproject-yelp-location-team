# Library
library(wordcloud)

# Functions:
# Creates word cloud for vector of words, sized and colored by frequency
# Args: words - vector of words 
#       frequency - # of reviews word appears in
#       colors - color scale for word cloud
WordCloud <- function(words, frequency, colors) {
  wordcloud(words, frequency, scale = c(2.75, 0.5),
            random.order = F, random.color = F, use.r.layout = T,
            rot.per = 0.35, colors = colors)
}
