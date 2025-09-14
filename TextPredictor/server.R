library(shiny)
library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)

bigram_counts <- readRDS("./data/bigrams.rds")
trigram_counts <- readRDS("./data/trigrams.rds")
fourgram_counts <- readRDS("./data/fourgrams.rds")

predict_next_word <- function(phrase) {
        phrase <- str_to_lower(phrase) %>% str_replace_all("[[:punct:]]", "") %>% str_squish()
        words <- str_split(phrase, " ")[[1]]
        
        if(length(words) >= 3){
                last3 <- tail(words, 3)
                match <- fourgram_counts %>%
                        filter(word1 == last3[1], word2 == last3[2], word3 == last3[3])
                if(nrow(match) > 0) return(match %>% slice_max(n, n=1) %>% pull(word4))
        }
        if(length(words) >= 2){
                last2 <- tail(words, 2)
                match <- trigram_counts %>%
                        filter(word1 == last2[1], word2 == last2[2])
                if(nrow(match) > 0) return(match %>% slice_max(n, n=1) %>% pull(word3))
        }
        if(length(words) >= 1){
                last1 <- tail(words, 1)
                match <- bigram_counts %>%
                        filter(word1 == last1)
                if(nrow(match) > 0) return(match %>% slice_max(n, n=1) %>% pull(word2))
        }
        
        return(NA)  # no match found
}

shinyServer(function(input, output) {
        observeEvent(input$predict, {
                pred <- predict_next_word(input$input_text)[1]
                output$prediction <- renderText(pred)
        })
})
