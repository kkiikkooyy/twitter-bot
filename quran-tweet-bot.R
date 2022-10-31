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

querySelectSurah <- paste("SELECT * FROM surah where idsurah =", random_surah,  sep = " ")

surah <- dbGetQuery(conSurah, querySelectSurah)

random_verse <- sample(1:surah$totalverse[1],1)

url <- paste("https://quran.com/id/", surah$idsurah[1], "/", random_verse, sep = "")

page <- read_html(url)

verse <- page %>% 
  html_nodes(".TranslationText_ltr__146rZ") %>% 
  html_text(trim = TRUE)

queryInputRandomSurah <- '
SELECT * FROM tweet
'

dataInputTweet <- dbGetQuery(conSurah, queryInputRandomSurah)
baris <- nrow(dataInputTweet)

baris
dataInputTweet <- data.frame(idtweet = (baris+1),
                        surahtweet = surah$surahname[1],
                        idverse = random_verse,
                        versetweet = verse)

dbWriteTable(conn = conSurah, name = "tweet", value = dataInputTweet, append = TRUE, row.names = FALSE, overwrite=FALSE)



library(rtweet)

queryAfterInput <- '
SELECT * FROM tweet
'

dataTerupdate <- dbGetQuery(conSurah, queryAfterInput)
baris <- nrow(dataTerupdate)

queryPostTweet <- paste("Select * FROM tweet WHERE idtweet = ", baris, sep = "")

dataPostTweet <- dbGetQuery(conSurah, queryPostTweet)

textTweet <- paste(dataPostTweet$versetweet[1], " (QS. ", dataPostTweet$surahtweet[1], ":", dataPostTweet$idverse[1], ") #QuranDaily", sep = "")

countChar <- nchar(textTweet)
countChar

twitter_token <- rtweet::rtweet_bot(
    api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
    api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
    access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
    access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)
  
# Post tweet
if (countChar < 281){
  rtweet::post_tweet(
  status = textTweet,
  token = twitter_token
  )
}

on.exit(dbDisconnect(conSurah))
