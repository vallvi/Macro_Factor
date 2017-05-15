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
# pJS <- phantom(pjs_cmd = "C:\\Users\\Ke2l8b1\\Documents\\Shipping_origin_map\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
pJS <- phantom(pjs_cmd = "C:\\Users\\vi9e5i1\\AppData\\Local\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe")
Sys.sleep(2)
eCap <- list(phantomjs.page.settings.loadImages = FALSE)
remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
Sys.sleep(2)
remDr$open()
Sys.sleep(2)

remDr$navigate("https://www.barchart.com/futures/quotes/CL*0/all-futures")
Sys.sleep(6)

remDr$getCurrentUrl()
# remDr$refresh()
remDr$maxWindowSize()
webElem <- remDr$findElement(value = '//a[@href = "#/login"]')

webElem$getElementAttribute("href")

webElem$clickElement()

webElem <- remDr$findElement(using = "name", "email")
webElem$sendKeysToElement(list('kevin_bonds@gap.com'))

webElem <- remDr$findElement(using = "name", "password")
webElem$sendKeysToElement(list("gapster2"))
webElem$sendKeysToElement(list(key= "enter"))



webElem <- remDr$findElement(using = "class name", " download")
webElem$clickElement()


webElem$screenshot(useView  = TRUE, display = TRUE)



remDr$close()
