## Install Rselenium
### update Java Run Time to version 8
#### instal Rtools, add to sys path
### add SQL server driver to ODBC and configure with USerid, pwd, database name etc, give the driver name "SDSChild"
### might have to change firefox settings first time. 
## must have a credentials.yml file on desktop

library(RODBC)
library(RSelenium)
library(lubridate)
library(yaml)
library(dplyr)
path <- Sys.getenv("USERPROFILE")
credentials <- yaml.load_file(paste0(path, "\\Desktop\\credentials.yml"))


extraCapabilities <- makeFirefoxProfile(list(browser.download.dir ="c:\\downloads", browser.helperApps.neverAsk.saveToDisk = "text/csv,application/vnd.ms-excel", 
                                             browser.helperApps.neverAsk.openFile = "text/csv,application/vnd.ms-excel",browser.download.manager.showWhenStarting = "false"))


##### oil futures
rD <- rsDriver(browser = "firefox",extraCapabilities = extraCapabilities )
remDr <- rD[["client"]]

remDr$navigate("https://www.barchart.com/futures/quotes/CL*0/all-futures")

remDr$maxWindowSize()
webElem <- remDr$findElement(value = '//a[@href = "#/login"]')

webElem$getElementAttribute("href")

webElem$clickElement()

webElem <- remDr$findElement(using = "name", "email")
webElem$sendKeysToElement(list('kevin_bonds@gap.com'))

webElem <- remDr$findElement(using = "name", "password")
webElem$sendKeysToElement(list("gapster2"))
webElem$sendKeysToElement(list(key= "enter"))
Sys.sleep(6)
file.remove(paste0(path, "\\Downloads\\all-futures-contracts-intraday-", format(today(),"%m-%d-%Y"), ".csv"))

webElem <- remDr$findElement(using = "class name", "download")
webElem$clickElement()
Sys.sleep(20)

oil <- read.csv(paste0(path,"\\Downloads\\all-futures-contracts-intraday-",format(today(),"%m-%d-%Y"), ".csv"), header=T)

remDr$close()
rD[["server"]]$stop() 

##### rubber

rD <- rsDriver(browser = "firefox",extraCapabilities = extraCapabilities )
remDr <- rD[["client"]]

remDr$navigate("https://www.barchart.com/futures/quotes/U6*0/all-futures#/viewName=main")

remDr$maxWindowSize()
webElem <- remDr$findElement(value = '//a[@href = "#/login"]')

webElem$getElementAttribute("href")

webElem$clickElement()

webElem <- remDr$findElement(using = "name", "email")
webElem$sendKeysToElement(list('kevin_bonds@gap.com'))

webElem <- remDr$findElement(using = "name", "password")
webElem$sendKeysToElement(list("gapster2"))
webElem$sendKeysToElement(list(key= "enter"))
Sys.sleep(6)
file.remove(paste0(path, "\\Downloads\\all-futures-contracts-intraday-", format(today(),"%m-%d-%Y"), ".csv"))


webElem <- remDr$findElement(using = "class name", "download")
webElem$clickElement()
Sys.sleep(20)

rubber <- read.csv(paste0(path,"\\Downloads\\all-futures-contracts-intraday-", format(today(),"%m-%d-%Y"), ".csv"), header=T)

remDr$close()
rD[["server"]]$stop() 

########################################################
oil <- oil[-1,]
oil$Date_Refreshed <- today()
oil$Commodity <- "Oil"
oil$Contract <- gsub("[\\(\\)']", "", regmatches(oil$Contract, gregexpr("\\(.*?\\)", oil$Contract)))
oil$Month_Dt <- strptime(paste0(oil$Contract," 01"), "%b %y %d")
oil <- rename(oil, Month = Contract, Price = Last)


rubber$Date_Refreshed <- today()
rubber$Commodity <- "Rubber"
rubber$Contract <- gsub("[\\(\\)']", "", regmatches(rubber$Contract, gregexpr("\\(.*?\\)", rubber$Contract)))
rubber$Month_Dt <- strptime(paste0(rubber$Contract," 01"), "%b %y %d")
rubber <- rename(rubber, Month = Contract, Price = Last)


cn <- odbcConnect("SDSChild",uid = credentials$sql_id, pwd = credentials$sql_pwd)

sqlSave(cn, oil[,c("Commodity","Price", "Month", "Month_Dt", "Date_Refreshed")], 'Oil_Futures', append = TRUE, rownames = FALSE)
sqlSave(cn, rubber[,c("Commodity","Price", "Month", "Month_Dt", "Date_Refreshed")], 'Rubber_Futures', append = TRUE, rownames = FALSE)
odbcCloseAll()


