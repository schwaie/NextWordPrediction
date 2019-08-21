library(shiny)
library(shinythemes)
library(quanteda)
library(data.table)
library(markdown)

load("dtBigram.Rda")
load("dtTrigram.Rda")
load("dtFourgram.Rda")

getWords <- function(words) {
    words <- tokens(words, remove_punct = TRUE, remove_numbers = TRUE)
    words <- tokens_tolower(words)
    words <- as.character(words)
    length <- length(words)
    
    if(length == 1) {words <- as.character(tail(words, 1)); bigramFunction(words)}
    
    else if (length == 2) {words <- as.character(tail(words, 2)); 
    words <- paste(words, collapse="_"); trigramFunction(words)}
    
    else if (length >= 3) {words <- as.character(tail(words, 3)); 
    words <- paste(words, collapse="_"); fourgramFunction(words)}
}

bigramFunction <- function(words) {

    match <- as.character(head(dtBigram[dtBigram$base == words, 3], 1))
    if (identical(match, "character(0)")){
        print ("Sorry, I got nothing. Please try again")
    }
    else{ 
        as.character(head(dtBigram[dtBigram$base == words, 3], 1))
    }
}

trigramFunction <- function(words) {
    match <- as.character(head(dtTrigram[dtTrigram$base == words, 3], 1))
    if (identical(match, "character(0)")) { 
        words <- gsub("_", " ", words)
        words <- as.character(tokens(words))
        words <- as.character(tail(words, 1)); 
        bigramFunction(words)
    }
    else{
        as.character(head(dtTrigram[dtTrigram$base == words, 3], 1))
    }
}


fourgramFunction <- function(words) {
    match <- as.character(head(dtFourgram[dtFourgram$base == words, 3], 1)) 
    if (identical(match, "character(0)")) {
        words <- gsub("_", " ", words)
        words <- as.character(tokens(words))
        words <- as.character(tail(words, 2)); 
        words <- paste(words, collapse="_"); trigramFunction(words)
    }
    else{
        as.character(head(dtFourgram[dtFourgram$base == words, 3], 1))
    }
}

shinyServer(function(input, output) {
        output$prediction <- renderText({
            if(input$inputText=="")
                return("You haven't entered anything yet!")
            result <- getWords(input$inputText)
            result
        })
        }
        )