library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)

data_url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
filename <- "Coursera-SwiftKey.zip"
if (!file.exists(filename)) {
        download.file(data_url, destfile=filename, mode = "wb")
}
if (!dir.exists("final")){
        unzip(filename)
}

texts <- c()

files <- c("blogs", "news", "twitter")
for (i in seq_along(files)){
        datapath <- paste("./final/en_US/en_US.", files[i],".txt", sep="")
        texts <- append(texts, readLines(datapath, n=150000, warn=FALSE))
}

text_df <- data.frame(text = texts, stringsAsFactors = FALSE)

create_ngram_counts <- function(df, n){
        df %>%
                unnest_tokens(ngram, text, token = "ngrams", n = n) %>%
                count(ngram, sort = TRUE) %>%
                separate(ngram, into = paste0("word", 1:n), sep = " ")
}

bigram_counts <- create_ngram_counts(text_df, 2)
trigram_counts <- create_ngram_counts(text_df, 3)
fourgram_counts <- create_ngram_counts(text_df, 4)

saveRDS(bigram_counts, file="bigrams.rds")
saveRDS(trigram_counts, file="trigrams.rds")
saveRDS(fourgram_counts, file="fourgrams.rds")