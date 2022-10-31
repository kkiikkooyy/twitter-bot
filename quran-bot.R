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

html <- paste("https://quran.com/id/", surah$idsurah[1], "/", random_verse, sep = "")
html


library(webshot2)
library(magick)

webshot(html, file = "random-verse.png",  vwidth = 600, vheight =375, selector = ".TranslationViewCell_contentContainer__MzrKa", zoom = 2, expand = c(0, 80, 0, 120))

verse_shot <- image_read(paste(getwd(), "/random-verse.png", sep = ""))

verse_annotate <- image_annotate(verse_shot, paste("QS. ", surah$surahname[1], ":", random_verse, sep = ""), font = 'trebuchet', size = 28, location = "+20+10", kerning = 2, weight = 700, boxcolor = "pink")
image_write(verse_annotate, "media-upload.png", format = "png")


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

twitteR::updateStatus(
  paste("QS. ", surah$surahname[1], ":", random_verse, " #QuranDaily", sep = ""),
  mediaPath = paste(getwd(), "/media-upload.png", sep = "")
)
