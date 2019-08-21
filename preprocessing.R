library(quanteda)
library(data.table)

##getting the data
setwd("/Users/suey/Desktop/Data Science Coursera/Capstone/data/final/en_US")
blogs <- file("en_US.blogs.txt")
news<- file("en_US.news.txt")
twitter<- file("en_US.twitter.txt")
blog.line<-readLines(blogs,encoding="UTF-8", skipNul = TRUE)
news.line<-readLines(news,encoding="UTF-8", skipNul = TRUE)
twitter.line<-readLines(twitter,encoding="UTF-8", skipNul = TRUE)

##Sample the data: (10% of total)
set.seed(12345)
blogSample <- sample(blog.line, length(blog.line)*.1, replace=FALSE)
newsSample <- sample(news.line, length(news.line)*.1, replace=FALSE)
twitterSample <- sample(twitter.line, length(twitter.line)*.1, replace=FALSE)
data <- c(blogSample, newsSample, twitterSample)

##Cleaning the data:
library(quanteda)
doc.corpus <- corpus(data)
doc.tokens <- tokens(doc.corpus)
doc.tokens <- tokens(doc.tokens, remove_punct = TRUE, remove_numbers = TRUE)
doc.tokens <- tokens(doc.tokens, remove_twitter = TRUE, remove_url=TRUE, 
                     remove_symbols = TRUE)
doc.tokens <- tokens_tolower(doc.tokens)
save(doc.tokens, file="doc.tokens.Rda")
doc.dfm.final <- dfm(doc.tokens)
writeLines(as.character(doc.tokens), con="doctokens.txt")

##Make n-grams
bigram <- tokens_ngrams(doc.tokens, n = 2)
save(bigram, file="bigram.Rda")
dfmBigram <- dfm(bigram)
save(dfmBigram, file="dfmBigram.Rda")
##turn dfm into data table
dtBigram <- data.table(ngram = featnames(dfmBigram), keep.rownames = F, stringsAsFactors = F)
##make a new column with the base
dtBigram[, base := strsplit(ngram, "_[^_]+$")[[1]], by = ngram]
##make a new column with the prediction
dtBigram$prediction <- sub('.*_\\s*', '', dtBigram$ngram)
dtBigram[, frequency := colSums(dfmBigram)]
dtBigram <- dtBigram[rev(order(dtBigram$frequency)),]
save(dtBigram, file="dtBigram.Rda")

##trigram
trigram <- tokens_ngrams(doc.tokens, n = 3)
save(trigram, file="trigram.Rda")
dfmTrigram <- dfm(trigram)
save(dfmTrigram, file="dfmTrigram.Rda")
dtTrigram <- data.table(ngram = featnames(dfmTrigram), keep.rownames = F, stringsAsFactors = F)
dtTrigram[, base := strsplit(ngram, "_[^_]+$")[[1]], by = ngram]
dtTrigram$prediction <- sub('.*_\\s*', '', dtTrigram$ngram)
dtTrigram[, frequency := colSums(dfmTrigram)]
dtTrigram <- dtTrigram[rev(order(dtTrigram$frequency)),]
save(dtTrigram, file="dtTrigram.Rda")

##fourgram
fourgram <- tokens_ngrams(doc.tokens, n = 4)
save(fourgram, file="fourgram.Rda")
dfmFourgram <- dfm(fourgram)
save(dfmFourgram, file="dfmFourgram.Rda")
dtFourgram <- data.table(ngram = featnames(dfmFourgram), keep.rownames = F, stringsAsFactors = F)
dtFourgram[, base := strsplit(ngram, "_[^_]+$")[[1]], by = ngram]
dtFourgram$prediction <- sub('.*_\\s*', '', dtFourgram$ngram)
dtFourgram[, frequency := colSums(dfmFourgram)]
dtFourgram <- dtFourgram[rev(order(dtFourgram$frequency)),]
save(dtFourgram, file="dtFourgram.Rda")

##fivegram
fivegram <- tokens_ngrams(doc.tokens, n = 5)
save(fivegram, file="fivegram.Rda") #
dfmFivegram <- dfm(fivegram)
save(dfmFivegram, file="dfmFivegram.Rda")
dtFivegram <- data.table(ngram = featnames(dfmFivegram), keep.rownames = F, stringsAsFactors = F)
dtFivegram[, base := strsplit(ngram, "_[^_]+$")[[1]], by = ngram]
dtFivegram$prediction <- sub('.*_\\s*', '', dtFivegram$ngram)
dtFivegram[, frequency := colSums(dfmFivegram)]
dtFivegram <- dtFivegram[rev(order(dtFivegram$frequency)),]
save(dtFivegram, file="dtFivegram.Rda")

