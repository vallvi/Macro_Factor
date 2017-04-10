library(httr)
library(jsonlite)
library(lubridate)

url_eai <- "http://api.eia.gov/series/?api_key=e68cbc39eaf4d0a7722c4ee62491ac7d&series_id=PET.RWTC.D&out=json"
# url_eai <- "http://api.eia.gov"
Oil_eia <- GET(url = url_eai)

Oil_eia_content <- rawToChar(Oil_eia$content)

nchar(Oil_eia_content)
substr(Oil_eia_content, 1, 200)

oil_from_JSON <- fromJSON(Oil_eia_content)
View(oil_from_JSON$series$data)

oil_df <- do.call(what = "rbind",
                           args = lapply(oil_from_JSON$series$data, as.data.frame))

oil_df$V1 <- ymd(oil_df$V1)
oil_df$unitsshort <- oil_from_JSON$series$unitsshort
oil_df$Units <- oil_from_JSON$series$units
oil_df$updated <- oil_from_JSON$series$updated
oil_df$description <- oil_from_JSON$series$description
oil_df$source <- oil_from_JSON$series$source
names(oil_df)[1:2] <- c("Date", "Price")
