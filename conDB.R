library(RPostgreSQL)

queryTableSurah <- '
CREATE TABLE IF NOT EXISTS surah (
  idsurah integer,
  surahname varchar(25),
  totalverse integer,
  PRIMARY KEY (idsurah)
)
'

drv <- dbDriver("PostgreSQL")

conSurah <- dbConnect(drv,
                 dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"), 
                 host = Sys.getenv("ELEPHANT_SQL_HOST"),
                 port = 5432,
                 user = Sys.getenv("ELEPHANT_SQL_USER"),
                 password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

# Membuat Tabel untuk Pertama Kalinya
dataSurah <- dbGetQuery(conSurah, queryTableSurah)

# Memanggil Tabel, untuk membuat Primary Key nya berurutan.

queryDataSurah <- '
SELECT * FROM surah
'

dataSurah <- dbGetQuery(conSurah, queryDataSurah)

dataSurah

dataSurah <- data.frame(idsurah = c(1:114),
                   surahname = c("Al-Fatihah","Al-Baqarah","Ali 'Imran","An-Nisa'","Al-Ma'idah",
                                 "Al-An'am","Al-A'raf","Al-Anfal","At-Taubah","Yunus","Hud","Yusuf","Ar-Ra'd",
                                 "Ibrahim","Al-Hijr","An-Nahl","Al-Isra'","Al-Kahf","Maryam","Taha","Al-Anbiya'",
                                 "Al-Hajj","Al-Mu'minun","An-Nur","Al-Furqan","Asy-Syu'ara'","An-Naml","Al-Qasas",
                                 "Al-'Ankabut","Ar-Rum","Luqman","As-Sajdah","Al-Ahzab","Saba'","Fatir","Yasin",
                                 "As-Saffat","Sad","Az-Zumar","Gafir","Fussilat","Asy-Syura","Az-Zukhruf",
                                 "Ad-Dukhan","Al-Jasiyah","Al-Ahqaf","Muhammad","Al-Fath","Al-Hujurat","Qaf",
                                 "Az-Zariyat","At-Tur","An-Najm","Al-Qamar","Ar-Rahman","Al-Waqi'ah","Al-Hadid",
                                 "Al-Mujadalah","Al-Hasyr","Al-Mumtahanah","As-Saff","Al-Jumu'ah","Al-Munafiqun",
                                 "At-Tagabun","At-Talaq","At-Tahrim","Al-Mulk","Al-Qalam","Al-Haqqah","Al-Ma'arij",
                                 "Nuh","Al-Jinn","Al-Muzzammil","Al-Muddassir","Al-Qiyamah","Al-Insan","Al-Mursalat",
                                 "An-Naba'","An-Nazi'at","'Abasa","At-Takwir","Al-Infitar","Al-Mutaffifin",
                                 "Al-Insyiqaq","Al-Buruj","At-Tariq","Al-A'la","Al-Gasyiyah","Al-Fajr","Al-Balad",
                                 "Asy-Syams","Al-Lail","Ad-Duha","Asy-Syarh","At-Tin","Al-'Alaq","Al-Qadr","Al-Bayyinah",
                                 "Az-Zalzalah","Al-'Adiyat","Al-Qari'ah","At-Takasur","Al-'Asr","Al-Humazah","Al-Fil",
                                 "Quraisy","Al-Ma'un","Al-Kausar","Al-Kafirun","An-Nasr","Al-Lahab","Al-Ikhlas","Al-Falaq","An-Nas"),
                   totalverse = c(7,286,200,176,120,165,206,75,129,109,123,111,43,52,
                                  99,128,111,110,98,135,112,78,118,64,77,227,93,88,69,60,34,
                                  30,73,54,45,83,182,88,75,85,54,53,89,59,37,35,38,29,18,45,
                                  60,49,62,55,78,96,29,22,24,13,14,11,11,18,12,12,30,52,52,
                                  44,28,28,20,56,40,31,50,40,46,42,29,19,36,25,22,17,19,26,
                                  30,20,15,21,11,8,8,19,5,8,8,11,11,8,3,9,5,4,7,3,6,3,5,4,5,6))

dbWriteTable(conn = conSurah, name = "surah", value = dataSurah, append = TRUE, row.names = FALSE, overwrite=FALSE)

queryTableTweet <- '
CREATE TABLE IF NOT EXISTS tweet (
  idtweet integer,
  surahtweet varchar(25),
  idverse integer,
  versetweet varchar(500),
  PRIMARY KEY (idtweet)
)
'

dataTweet <- dbGetQuery(conSurah, queryTableTweet)

on.exit(dbDisconnect(conSurah)) 
