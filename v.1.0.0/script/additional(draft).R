pathSSD <- "/Volumes/Extreme SSD/Lavoro/GRINS/R_GRINS"

CAMSfiles <-
  list.files(path = paste0(pathSSD,"/data/AQ/CAMS/1p1y"),
             pattern = ".Rdata")

#for SIS
CAMSfiles <- CAMSfiles[grep("no2",CAMSfiles)]

for (i in CAMSfiles) {
  load(paste0(pathSSD,"/data/AQ/CAMS/1p1y/",i))
  name_file <- substr(i,nchar(i)-13,nchar(i)-6)
  write.csv(grid_all,file = paste0(pathSSD,"/data/AQ/CAMS/1p1y/csv/CAMS_AQ_",name_file,".csv"))
}

#adjusting
for (i in CAMSfiles[c(7,9)]) {
  load(paste0(pathSSD,"/data/AQ/CAMS/1p1y/",i))
  grid_all$lon<-grid_all$lon-0.05
  grid_all$lat<-grid_all$lat-0.05
  grid_all <- grid_all[grid_all$lon != unique(grid_all$lon)[131] &
                         grid_all$lat != unique(grid_all$lat)[131],]
  name_file <- substr(i,nchar(i)-13,nchar(i)-6)
  save(grid_all,file=paste0(pathSSD,"/data/AQ/CAMS/1p1y/adj_",i))
  # write.csv(grid_all,file = paste0(pathSSD,"/data/AQ/CAMS/1p1y/csv/CAMS_AQ_",name_file,".csv"))
}

lon_lat <- list()
for (i in CAMSfiles) {
  load(paste0(pathSSD,"/data/AQ/CAMS/1p1y/",i))
  n <- which(CAMSfiles==i)
  lon_lat[[n]] <- data.frame(lon=unique(grid_all$lon),lat=unique(grid_all$lat))
}

#adjusting 2019 and 2021