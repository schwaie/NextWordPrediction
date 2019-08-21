## load dtNgrams
load("dtBigram.Rda")
load("dtTrigram.Rda")
load("dtFourgram.Rda")
load("dtFivegram.Rda")
library(quanteda)
library(data.table)

## clean up word(s) and separate them with "_"
getWords <- function(words) {
        cleanWords <- tokens(words, remove_punct = TRUE, remove_numbers = TRUE)
        cleanWords <- tokens_tolower(cleanWords)
        cleanWords <- as.character(cleanWords)
        length <- length(cleanWords)
        
        if(length == 1) {cleanWords <- as.character(tail(cleanWords, 1)); bigramFunction(cleanWords)}
        
        else if (length == 2) {cleanWords <- as.character(tail(cleanWords, 2)); 
        cleanWords <- paste(cleanWords, collapse="_"); trigramFunction(cleanWords)}
        
        else if (length == 3) {cleanWords <- as.character(tail(cleanWords, 3)); 
        cleanWords <- paste(cleanWords, collapse="_"); fourgramFunction(cleanWords)}
        
        else if (length >= 4) {cleanWords <- as.character(tail(cleanWords, 4)); 
        cleanWords <- paste(cleanWords, collapse="_"); fivegramFunction(cleanWords)}
}

# if 1, go to bigram function
bigramFunction <- function(cleanWords) {
        ##search base for match
        match <- as.character(head(dtBigram[dtBigram$base == cleanWords, 3], 1))
        if (identical(match, "character(0)")){
                print ("I got nothing")
        }
        else{ 
                as.character(head(dtBigram[dtBigram$base == cleanWords, 3], 1))
        }
}

# if 2 go to trigram function
# search base for match, if none, grab last word and go to bigram function, if match, return top word in frequency of prediction
trigramFunction <- function(cleanWords) {
        ##search base for match
        match <- as.character(head(dtTrigram[dtTrigram$base == cleanWords, 3], 1))
        if (identical(match, "character(0)")) { 
                cleanWords <- gsub("_", " ", cleanWords)
                cleanWords <- as.character(tokens(cleanWords))
                cleanWords <- as.character(tail(cleanWords, 1)); 
                bigramFunction(cleanWords)
                }
        else{
        as.character(head(dtTrigram[dtTrigram$base == cleanWords, 3], 1))
        }
}

# if 3 go to fourgram function
# search base for match, if match, return top word in frequency of prediction
fourgramFunction <- function(cleanWords) {
        match <- as.character(head(dtFourgram[dtFourgram$base == cleanWords, 3], 1)) 
        if (identical(match, "character(0)")) {
                cleanWords <- gsub("_", " ", cleanWords)
                cleanWords <- as.character(tokens(cleanWords))
                cleanWords <- as.character(tail(cleanWords, 2)); 
                cleanWords <- paste(cleanWords, collapse="_"); trigramFunction(cleanWords)
        }
        else{
                as.character(head(dtFourgram[dtFourgram$base == cleanWords, 3], 1))
        }
}
## if four go to fivegram function
fivegramFunction <- function(cleanWords) {
        match <- as.character(head(dtFivegram[dtFivegram$base == cleanWords, 3], 1)) 
        if (identical(match, "character(0)")) {
                cleanWords <- gsub("_", " ", cleanWords)
                cleanWords <- as.character(tokens(cleanWords))
                cleanWords <- as.character(tail(cleanWords, 3)); 
                cleanWords <- paste(cleanWords, collapse="_"); fourgramFunction(cleanWords)
        }
        else{
                as.character(head(dtFivegram[dtFivegram$base == cleanWords, 3], 1))
        }
}

