# MilestoneReport

Capstone project of building a Shiny App with Natural Processing Model (NLP) to predict what user next input word.

The dataset is from SwiftKey (Eng).

## Models which were used in this project:
 - N-gram tokenization (from unigram to pentagram)
  - Stupid-Backoff. 
  
## Files and folders guied:
 - preprocessing.R
 Loading,sampling, cleaning, profanity filtering, stemming, building N-grams.
 - global.R
 Store the functions and Stupid backoff model to be used in the Shinyapp
 - ui.R/server.R
 Shiny App file.
 - ngram.rds
 Cleaned ngrams which will be used by App
 - Sample
10% sample of twitter, blogs, news files

## Links
  - Shiny App: https://xssokolova.shinyapps.io/WordPredictApp/
  - Milestone report on exploratory analysis about the Swift Key dataset:
