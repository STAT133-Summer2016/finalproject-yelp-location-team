library(wordcloud)

word_cloud <- function(words, frequency, colors) {
  wordcloud(words, frequency, scale = c(4, 0.5),
            random.order = F, random.color = F, use.r.layout = T,
            rot.per = 0.35, colors = colors)
}