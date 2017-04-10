library(dplyr)
library(readr)

search_dataframe <- function(x, value_vec){
      my_columns <- unique(grep(paste(value_vec, collapse = "|"), x, ignore.case = TRUE), value = TRUE)
        my_rows <- unique(grep(paste(value_vec, collapse = "|"), x[[my_columns[1]]], ignore.case = TRUE ), value = TRUE)

        my_vec <- c(my_rows[1], my_columns[1])

      return(my_vec)
}

NYvsACotton <- read_csv("NYvsACotton.csv", col_names = FALSE)

Assumption <- read_csv("Spr 18 Athleta Assumptions 2.csv", col_names = FALSE)

Categories <- c("KNITS", "Denim", "Wovens", "Outerwear", "Suiting", "Sweaters", "IP", "Non Apparel")

Categories <- c("KNITS", "Denim", "Wovens", "Outerwear", "Suiting", "Sweaters", "Non Apparel")
Seasons <- c("spring", "summer", "fall", "holiday")

category_find <- search_dataframe(Assumption, Categories)
Season_find <- search_dataframe(Assumption, Seasons)
Year_find <- search_dataframe(Assumption, 2010:2030)

category_find <-  unique(grep(paste(Categories, collapse = "|"), Assumption, ignore.case = TRUE), value = TRUE)
Season_find <-  unique(grep(paste(Seasons, collapse = "|"), Assumption[[8]] , ignore.case = TRUE), value = TRUE)

category_find <-  which(Assumption, arr.ind = TRUE) %in% Categories

# category_find <- mapply(grep, paste(Categories, collapse = "|"), Assumption) 



model_year <- grep("Macro Factor Model", as.data.frame(Assumption), ignore.case = TRUE, value = TRUE)

category_name <- Assumption[2,7]
Brand_season <- Assumption[5:6, 8]

ok <- complete.cases(Assumption[,"X10"])
Assumption <- Assumption[ok, ]

# complete_columns <- !is.na(Assumption[1,])
Assumption <- Assumption[, c(!is.na(Assumption[1,]))]
Assumption <- Assumption[Assumption$X7 != "Total",]
# Assumption <- Assumption
