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

# Start PhantomJS server and log in to metals.com using RSelenium ----
pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")

Sys.sleep(2)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
Sys.sleep(2)
remDr$open()
Sys.sleep(2)

remDr$navigate("https://www.metalprices.com/a/Login")
Sys.sleep(6)

remDr$getCurrentUrl()
# remDr$refresh()

webElem <- remDr$findElement(using = "name", "Username")

webElem$getElementAttribute("id")

#webElem$clickElement()
webElem$sendKeysToElement(list("neha_shah@gap.com"))
webElem$getElementAttribute("value")

#webElem$sendKeysToElement(list(key= "tab"))

webElem <- remDr$findElement(using = "name", "Password")
Sys.sleep(2)
webElem$sendKeysToElement(list("gapster6"))
webElem$getElementAttribute("value")
Sys.sleep(2)
webElem$sendKeysToElement(list(key= "enter"))

# my_source <- remDr$getPageSource()
# webElem$screenshot(useView  = TRUE, display = TRUE)

# copper ----
remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
Sys.sleep(6)
my_source <- remDr$getPageSource()
webElem$screenshot(useView  = TRUE, display = TRUE)

if(grepl("Switch Device", my_source)){ 
  SwitchElem <- remDr$findElement("css", "input")
  SwitchElem$clickElement()
  #remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
}

tableElem <- remDr$findElement("css", "table")
Sys.sleep(2)

copper <-  readHTMLTable(tableElem$getElementAttribute("outerHTML")[[1]])
View(copper)
# clean up copper table ----
copper <- as.data.frame(copper[1])
colnames(copper) <- as.character(unlist(copper[3,]))
copper <- copper[-c(1:3), ]
copper <- droplevels(copper)
levels(copper$Future) <- c("Copper")


# zinc ----
remDr$navigate("https://www.metalprices.com/feeds/shfe/zinc")
Sys.sleep(6)
my_source <- remDr$getPageSource()
webElem$screenshot(useView  = TRUE, display = TRUE)

if(grepl("Switch Device", my_source)){ 
  SwitchElem <- remDr$findElement("css", "input")
  SwitchElem$clickElement()
  #remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
}

tableElem <- remDr$findElement("css", "table")
# tableElem$highlightElement()

zinc <-  readHTMLTable(tableElem$getElementAttribute("outerHTML")[[1]])
View(zinc)
# clean up zinc table ----
zinc <- as.data.frame(zinc[1])
colnames(zinc) <- as.character(unlist(zinc[3,]))
zinc <- zinc[-c(1:3), ]
zinc <- droplevels(zinc)
levels(zinc$Future) <- "Zinc"

# metal table ----
metal <- rbind(copper, zinc)
metal <- droplevels(metal)

# Use if "Switch Element" button shows it's ugly head ----
# SwitchElem <- remDr$findElement("css", "input")
# SwitchElem$clickElement()
remDr$close()
pJS$stop()

# EXP ----
# remDr$navigate("https://www.metalprices.com/a/Logout")
# webElem <- remDr$findElement(using = "css", "input")
# webElem$clickElement()
# remDr$navigate("https://www.metalprices.com/feeds/shfe/copper")
# copper <-  html_session("https://www.metalprices.com/feeds/shfe/copper")
# 
# copper %>% html_node(css = "td:nth-child(4)") %>% html_text() %>% .[1:12] 
# 
# copper_html <- read_html("https://www.metalprices.com/feeds/shfe/copper") %>% 
#   html_node("#td .qFieldChgNone") %>% 
#   html_text()
# 
# library(XML)  
# readHTMLTable(content(copper_response))


remDr$close()
pJS$stop()
