library(rvest)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

conSurah <- dbConnect(drv,
                      dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"), 
                      host = Sys.getenv("ELEPHANT_SQL_HOST"),
                      port = 5432,
                      user = Sys.getenv("ELEPHANT_SQL_USER"),
                      password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

random_surah <- sample(1:114, 1)
random_surah

querySelectSurah <- paste("SELECT * FROM surah where idsurah =", random_surah,  sep = " ")

surah <- dbGetQuery(conSurah, querySelectSurah)
surah

random_verse <- sample(1:surah$totalverse[1],1)
random_verse

url <- paste("https://quran.com/id/", surah$idsurah[1], "/", random_verse, sep = "")
url

page <- read_html(url)
page

verse <- page %>% 
  html_nodes(".TranslationText_ltr__146rZ") %>% 
  html_text(trim = TRUE)
verse

queryInputRandomSurah <- '
SELECT * FROM tweet
'


dataInputTweet <- dbGetQuery(conSurah, queryInputRandomSurah)
baris <- nrow(dataInputTweet)

dataInputTweet <- data.frame(idtweet = (baris+1),
                        surahtweet = surah$surahname[1],
                        idverse = random_verse,
                        versetweet = verse)
dataInputTweet

dbWriteTable(conn = conSurah, name = "tweet", value = dataInputTweet, append = TRUE, row.names = FALSE, overwrite=FALSE)

library(twitteR)

api_key <- Sys.getenv("TWITTER_CONSUMER_API_KEY")
api_secret <- Sys.getenv("TWITTER_CONSUMER_API_SECRET")
access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN")
access_secret <- Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")

setup_twitter_oauth(
  api_key,
  api_secret,
  access_token = access_token,
  access_secret = access_secret
)

baris <- nrow(dataInputTweet)
baris

queryPostTweet <- paste("Select * FROM tweet WHERE idtweet = ", baris, sep = "")
queryPostTweet

dataPostTweet <- dbGetQuery(conSurah, queryPostTweet)
dataPostTweet

twitteR::updateStatus(
  paste(dataPostTweet$versetweet[1], " (QS. ", dataPostTweet$surahtweet[1], ":", dataPostTweet$idverse[1], ") #QuranDaily", sep = "")
)
