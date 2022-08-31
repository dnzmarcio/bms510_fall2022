# Libraries ----

library(rvest)
library(ggplot2)
library(dplyr)
library(lubridate)

# Last R Package updates ----

url = 'https://cran.r-project.org/web/packages/available_packages_by_date.html'
CRANpage <- read_html(url)
tbls <- html_nodes(CRANpage, "table") # since HTML is in table; no need to scrape td/tr elements
table1 <- html_table(tbls[1], fill = TRUE)
dd <- data.frame(table1[1])

# data cleaning
dd$Date <- as.Date(dd$Date)

# Get initial Dates ----

rm(list = Filter(exists, c("packageNames")))
packageNames <- dd$Package

# rm(df_first)
# create a dataframe to keep the data types in order
df_first <- data.frame(name=c("TK_NA")
                       ,firstRelease=c(as.Date("1900-12-31"))
                       ,nofUpdates=c(0))

for (i in 1:length(packageNames)){
  url1 <- 'https://cran.r-project.org/src/contrib/Archive/'
  name1 <- packageNames[i]
  url2 <- paste0(url1,name1,'/')
  
  ifErrorPass <- tryCatch(read_html(url2), error=function(e) e) 
  if(inherits(ifErrorPass, "error")) next # if package does not have archive!!!
  
  cp <- read_html(url2)
  t2 <- html_nodes(cp, "table") 
  t2 <- html_table(t2[1], fill = TRUE)
  rm(list = Filter(exists, c("dd2")))
  dd2 <- data.frame(t2[1])
  dat <- dd2$Last.modified
  dat <- as.Date(dat, format = '%Y-%m-%d')
  firstRelease <- dat[order(format(as.Date(dat),"%Y%m%d"))[1]]
  numberOfUpdates <- length(dat) 
  df_first <- rbind(df_first,data.frame(name=name1,firstRelease=as.Date(firstRelease, format='%Y-%m-%d'),nofUpdates=numberOfUpdates))
}

# clean my initial row when creating data.frame
myData = df_first[df_first$firstRelease > '1900-12-31',]

# add missing packages that did not fall into archive folder on CRAN

myDataNonArchive <- dd$Package[!dd$Package %in% myData$name]
myDataNonArchive2 <- cbind(dd[dd$Package %in% myDataNonArchive,c(2,1)],1)

names(myData) <- c("Name","firstRelease","nofUpdates")
names(myDataNonArchive2) <- c("Name","firstRelease","nofUpdates")

finalArchive <- data.frame(rbind(myData, myDataNonArchive2))