library(ncdf4)
library(ecmwfr)

source("script/AQ/CAMS/functions.R")

months <- c(paste0("0",1:9),"10","11","12")
y<-2013:2023
user<-"16954" # set the ID of your CDS account

# time_wait <- 5
for (m in months[-1]) {download_CAMS(m,y,user)}
