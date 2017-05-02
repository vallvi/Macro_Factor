library(httr)
library(jsonlite)
library(lubridate)
library(xml2)
library(curl)
library(rvest)
library(dplyr)
library(tidyr)
library(XML)
library(RSelenium)

# copper_login <- POST("https://www.metalprices.com/a/Login", authenticate("neha_shah@gap.com", "gapster6"))
# copper_response <- GET("https://www.metalprices.com/feeds/shfe/copper", verbose(info = ))
# 
# rawToChar(copper_login$content)
# 
# stringi::stri_enc_detect(content(copper_response, "raw"))
# 
# copper <- rawToChar(content(copper_response, "raw"))
# 
# copper_read <- read_html(copper_response)
# 
# req <- curl_fetch_memory("https://www.metalprices.com/feeds/shfe/copper")
# 
# 
# 
# #### rvest
# 
# copper_html <- read_html("https://www.metalprices.com/feeds/shfe/copper")
# copper_html %>% 
#   html_node("#Username") %>% 
#   html_text()

#### RSelenium

pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")

Sys.sleep(2)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
Sys.sleep(2)
remDr$open()
Sys.sleep(2)

remDr$navigate("https://www.metalprices.com/a/Login")
Sys.sleep(8)

remDr$getCurrentUrl()
# remDr$refresh()


#webElem <- remDr$findElement(using = "css", "input#Username.login.valid")

#webElem <- remDr$findElement(using = "class name", "login")
webElem <- remDr$findElement(using = "name", "Username")

webElem$getElementAttribute("id")

#webElem$clickElement()
webElem$sendKeysToElement(list("neha_shah@gap.com"))
webElem$getElementAttribute("value")

#webElem$sendKeysToElement(list(key= "tab"))

webElem <- remDr$findElement(using = "name", "Password")
webElem$sendKeysToElement(list("gapster6"))
webElem$getElementAttribute("value")
webElem$sendKeysToElement(list(key= "enter"))
# webElem$getElementAttribute("value")
# webElem <- remDr$findElement(using = "class", "input.Login")
my_source <-  remDr$getPageSource
webElem$screenshot(useView  = TRUE, display = TRUE)

remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
tableElem <- remDr$findElement("css", "table")
# tableElem$highlightElement()

res <-  readHTMLTable(tableElem$getElementAttribute("outerHTML")[[1]])
View(res)
# clean up table ----
res <- as.data.frame(res[1])
colnames(res) <- as.character(unlist(res[3,]))
res <- res[-c(1:3), ]

# Use if "Switch Element" button shows it's ugly head ----
# SwitchElem <- remDr$findElement("css", "input")
# SwitchElem$clickElement()

remDr$navigate("https://www.metalprices.com/a/Logout")
webElem <- remDr$findElement(using = "css", "input")
webElem$clickElement()
remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
copper <-  html_session("https://www.metalprices.com/feeds/shfe/copper")

copper %>% html_node(css = "td:nth-child(4)") %>% html_text() %>% .[1:12] 

copper_html <- read_html("https://www.metalprices.com/feeds/shfe/copper") %>% 
  html_node("#td .qFieldChgNone") %>% 
  html_text()

library(XML)  
readHTMLTable(content(copper_response))


remDr$close()
pJS$stop()
