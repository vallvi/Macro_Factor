library(readr)
library(httr)
library(tidyr)
library(RSelenium)

# ET_dataframe <- read_csv("http://KBONDS:gapster9@www.emergingtextiles.com/?pricesDBsub=F&q=pre&s=monthly-fiber-price-table-csv&t=csv&r=price-database-gap")

pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")

Sys.sleep(2)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
Sys.sleep(2)
remDr$open()
Sys.sleep(2)

remDr$navigate("http://www.emergingtextiles.com")
Sys.sleep(8)

remDr$getCurrentUrl()
remDr$refresh()

webElem <- remDr$findElement(using = "name", "idU")
webElem$getElementText()
webElem$getElementAttribute("value")

# webElem$clickElement()
webElem$sendKeysToElement(list("detalancec"))
# webElem$sendKeysToElement(list(key= "tab"))
# webElem$getElementText()
webElem <- remDr$findElement(using = "name", "idP")
webElem$sendKeysToElement(list("gapster8"))
webElem$getElementAttribute("value")
webElem <- remDr$findElement(using = "name", "rqLOG")
webElem$clickElement()
webElem$screenshot(useView  = TRUE, display = TRUE)

Gap_response <- GET("http://www.emergingtextiles.com/?q=com&s=price-database-gap", verbose(info = ))
rawToChar(content(Gap_response, "raw"))

Gap_csv <- read_csv("http://www.emergingtextiles.com/?aA=03&q=pdb&s=csvFILE.price-database-gap.monthly-fiber-price-table-csv.csv")

remDr$close()
pJS$stop()
