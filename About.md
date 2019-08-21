## Predict The Next Word App 
*by Schwaie, August 21 2019*

This app predicts the next word given an input of a string of words. It was  developed as the final project for the Coursera JHU Data Science specialization Capstone project and is carried out in conjunction with Swiftkey.

### Natural language processing

The field of Natural language processing (NLP) applies algorithms to identify and extract the natural language rules into a form that computers can understand. This is extremely useful for the fields of AI, as well as for this project. Currently, NLP makes use of machine learning and statistics.

For this project, text files from US twitter feeds, blogs and news sites were downloaded from [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).

Due to the large datasize, only 10% of the data was used. Initially, 25% of the data was used, but this led to large file sizes and slow computation times. 

### Text mining

NLP requires that the text be thoroughly processed before making predictions. This is called text mining, which can consist of the following steps: 
* removal of punctuation,
* removal of numbers, 
* stopword removal (such as "the", "and", etc.),
* converting to lower case,
* stemming, in which word suffixes are erased to retrieve the radicals, which reduces complexity without any severe loss of information, 
* whitespace elimination and lower case conversion, 
* dealing with synonyms, 
* part of speech tagging. 

Not all of these steps were used in this project, however. For this app, the text is mined by removing punctuation, numbers, special characters (such as hash tags), numbers, punctuation, converting to lower case, and removing whitespace. Stopwords were retained and stemming was not carried out in order to make the next word prediction more accurate. 

For text mining, many different R packages are available. I opted to use Quanteda because it significantly reduced processing times. Quanteda allows users to first convert text documents to a corpus, which can then be mined to generate a clean data set. 

### Generating n-grams

The next step in creating the app was generating various n-grams. According to wikipedia, "an n-gram is a contiguous sequence of n items from a given sample of text or speech". For this app, I generated bigrams, trigrams, fourgrams and fivegrams using the Quanteda package. The n-grams were converted into a document feature matrix (`dfm`). According to wikipedia, a dfm is a "mathematical matrix that describes the frequency of terms that occur in a collection of documents". The dfm can then be turned into a datatable using the data.table package, which allows for the various n-grams to be sorted according to their frequency. In the interest of memory, all n-grams occuring with a frequency of only 1 were removed from the n-gram datasets. 

### Building an algorithm that predicts the next word

To predict the next word, the strings defining the various n-grams were split into a `base` and a `prediction`. Essentially, the last word of the string was defined as the "prediction" and the remaining string was defined as the `base`. 

The algorithm I developed works in the following way:
* it takes as input a string of words, cleans the words (remove punctuation, numbers, convert to lower case)
* it counts the amount of words. If the length is 1, it searches for the word in the `base` column of the bigram datatable and returns the `prediction` that occurs with the most frequency 
* If the length is 2, it searches for the string of words in the `base` column of the trigram datatable and returns the `prediction` that occurs with the most frequency. If there is no hit, the last word of the string is then searched for in the `base` column of the bigram. 
* If the length is 3 or higher, it searches for the string of words in the `base` column of the fourgram datatable and returns the `prediction` that occurs with the most frequency. If there is no hit, the last 2 words of the string is then searched for in the `base` column of the trigram. 

## Files

The files for the app, pitch, and all the scripts for loading and cleaning the data can be found [here](https://github.com/schwaie/NextWordPrediction).



