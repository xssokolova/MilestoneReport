#This file is preprocessing of data, including sampling, cleaning and tokenization.

#Load data and sample 1 percent of whole dataset (blogs, news, twitter).
## Files' addreses
blogs.file <- "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/en_US.blogs.txt"
twitter.file <- "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/en_US.twitter.txt"
news.file <- "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/en_US.news.txt"

## Load original data

con <- file(twitter.file, "r")
tw <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file(blogs.file, "r")
bl <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file(news.file, "rb")
nw <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# sampling, size = 10% of the Original data
set.seed(123)
SampleSize <- 0.1

ts <- sample(length(tw),length(tw)*SampleSize)
twSample <- tw[ts]

ns <- sample(length(nw),length(nw)*SampleSize)
nwSample <- nw[ns]

bs <- sample(length(bl),length(bl)*SampleSize)
blSample <- bl[bs]

# save sample
writeLines(twSample,"C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/sample/twitter.txt")
writeLines(nwSample,"C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/sample/news.txt")
writeLines(blSample,"C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/sample/blogs.txt")

rm(bl, nw, tw) # to clean RAM

#sample cleaning

library("quanteda")
require(readtext)

sample <- corpus(readtext("C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/sample/*.txt"))

# Tokenise corpus, removing puntuation, numbers,
# hyphens (combining compound words into single word),
# and twitter symbols like @#
tokenized <- tokens(x = tolower(sample), what = "word1", 
                    remove_numbers = TRUE, 
                    remove_punct = TRUE,
                    remove_symbols = TRUE, 
                    remove_separators = TRUE,
                    remove_twitter = TRUE, 
                    split_hyphens = TRUE, 
                    remove_url = TRUE,
                    verbose = FALSE)

# remove profane words
badwords <- readLines("C:/Users/xssok/Documents/badwords.txt", encoding = "UTF-8", skipNul = TRUE)
badwordsdict <- dictionary(list(bad_words=badwords))
removedbw <- tokens_remove(tokenized, badwordsdict) 

# stem all tokens before creating frequency matrix
unigram <- tokens_wordstem(removedbw,language = "english")

# Create n-grams for n = 2,3
bigram <- tokens_ngrams(unigram,n = 2)
trigram <- tokens_ngrams(unigram,n = 3)
quadrogram <- tokens_ngrams(unigram,n = 4)
fivegram <- tokens_ngrams(unigram,n = 5)

# Create frequency matrix for unigram, bigram and trigram
dfm1 <- dfm(unigram, tolower = FALSE) # since already lowered before
dfm2 <- dfm(bigram, tolower = FALSE)
dfm3 <- dfm(trigram, tolower = FALSE)
dfm4 <- dfm (quadrogram, tolower=FALSE)
dfm5 <- dfm (fivegram, tolower=FALSE)

# trim the DFMs for count less than 2, essentially reducing
# file size from hundreds of MBs to less than 50MB for each.
dfmr1 <- dfm_trim(dfm1,2)
dfmr2 <- dfm_trim(dfm2,2)
dfmr3 <- dfm_trim(dfm3,2)
dfmr4 <- dfm_trim(dfm4,2)
dfmr5 <- dfm_trim(dfm5,2)

save(dfmr1,dfmr2,dfmr3,dfmr4,dfmr5, file = "Reduced DFMs.Rdata")

# CREATE DATA TABLES'S OF N-GRAM MODELS

library("quanteda")
load("Reduced DFMs.Rdata") # loaded as dfmr1,dfmr2,dfmr3
# reduce them to named vectors gram1,2,3
gram1 <- colSums(dfmr1)
gram2 <- colSums(dfmr2)
gram3 <- colSums(dfmr3)
gram4 <- colSums(dfmr4)
gram5 <- colSums(dfmr5)

# clean these to remove words with only _ (there are some somehow)
gram1 <- gram1[-grep("^[^a-z]",names(gram1),perl = TRUE)]
gram2 <- gram2[-grep("^[^a-z]",names(gram2),perl = TRUE)]
gram3 <- gram3[-grep("^[^a-z]",names(gram3),perl = TRUE)]
gram4 <- gram4[-grep("^[^a-z]",names(gram4),perl = TRUE)]
gram5 <- gram5[-grep("^[^a-z]",names(gram5),perl = TRUE)]

require(data.table)

# For unigrams
ngram1 <- data.table(w1=names(gram1),freq = gram1)

# For bigrams 
# first separate words (they are concatenated by '_')
bgramWords <- strsplit(names(gram2),"_",fixed = TRUE)
fw <- sapply(bgramWords,'[[',1)
sw <- sapply(bgramWords,'[[',2)
ngram2 <- data.table(w1=fw,w2=sw,freq = gram2)

# For trigrams
# first separate words (separated by '_')
triwords <- strsplit(names(gram3),"_",fixed = TRUE)
fw <- sapply(triwords,'[[',1)
sw <- sapply(triwords,'[[',2)
tw <- sapply(triwords,'[[',3)
ngram3 <- data.table(w1 = fw, w2 = sw, w3 = tw, freq = gram3)

# For quadrograms
# first separate words (separated by '_')
fourwords <- strsplit(names(gram4),"_",fixed = TRUE)
fw <- sapply(fourwords,'[[',1)
sw <- sapply(fourwords,'[[',2)
tw <- sapply(fourwords,'[[',3)
ffw <- sapply(fourwords,'[[',4)
ngram4 <- data.table(w1 = fw, w2 = sw, w3 = tw, w4 = ffw, freq = gram4)

# For fivegrams
# first separate words (separated by '_')
fivewords <- strsplit(names(gram5),"_",fixed = TRUE)
fw <- sapply(fivewords,'[[',1)
sw <- sapply(fivewords,'[[',2)
tw <- sapply(fivewords,'[[',3)
ffw <- sapply(fivewords,'[[',4)
fffw <- sapply(fivewords,'[[',5)
ngram5 <- data.table(w1 = fw, w2 = sw, w3 = tw, w4 = ffw, w5=fffw, freq = gram5)


#save ngrams as Rdata files for further use.
saveRDS(ngram5, "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/WordPredictApp/ngram5.rds") 
saveRDS(ngram4, "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/WordPredictApp/ngram4.rds")
saveRDS(ngram3, "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/WordPredictApp/ngram3.rds")
saveRDS(ngram2, "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/WordPredictApp/ngram2.rds")
saveRDS(ngram1, "C:/Users/xssok/Documents/Coursera-SwiftKey/final/en_US/WordPredictApp/ngram1.rds")

