# Packages ----

library(dplyr)
library(purrr)
library(tidytext)
library(stringr)
library(readr)

# Barbie + Oppenheimer = BarbieHeimer ----

# list files
dinp <- "barbie"
finp <- list.files(dinp, full.names = TRUE)

dinp2 <- "oppenheimer"
finp2 <- list.files(dinp2, full.names = TRUE)

# read files
barbieheimer <- map_df(
    c(finp, finp2),
    function(x) {
        # x = finp[1]
        print(x)
      
        tibble(
            source = x,
            text = readLines(x)
        ) %>%
        unnest_tokens(word,text) %>%
        anti_join(stop_words)
    }
)

# which sources do I have in the final file?
barbieheimer %>% 
  distinct(source)

# Analysis ----

# which is the frequency for each word?
barbieheimer %>% 
   count(word, sort = TRUE)

barbieheimer %>% 
  count(source, word, sort = TRUE)

# => here we see non-informative words such as movie and film
# but others are informative such as robbie, nolan, etc

# if frequency is not so relevant or informative
# we need another metric
# tf-idf: good metric for word relevance
barbieheimer_tfidf <- barbieheimer %>% 
  count(source, word, sort = TRUE) %>% 
  bind_tf_idf(source, word, n)

0.213  * 2.15
0.458

# arrange from lower to higher
barbieheimer_tfidf %>% 
  arrange(tf_idf)

# => film and movie have a low tf-idf (not surprising)
