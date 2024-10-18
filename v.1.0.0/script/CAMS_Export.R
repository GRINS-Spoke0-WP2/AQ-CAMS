setwd("AQ-CAMS")

lf <- list.files("v.1.0.0/data/1p1y")
for (i in lf[c(14,15)]) {
  load(paste0("v.1.0.0/data/1p1y/",i))
  grid_all <- grid_all[order(grid_all$days,grid_all$lat,grid_all$lon),]
  y <- array(grid_all[,7], #extracting the mean
             dim = c(length(unique(grid_all$lon)),
                     length(unique(grid_all$lat)),
                     length(unique(grid_all$days))),
             dimnames = list(unique(grid_all$lon),
                             unique(grid_all$lat),
                             unique(grid_all$days))
  )
  name <- substr(i, nchar(i)-13,nchar(i)-6)
  if (substr(name,1,3)=="2p5") {name <- paste0("pm25",substr(name,4,12))}
  if (substr(name,1,3)=="m10") {name <- paste0("pm10",substr(name,4,12))}
  y <- aperm(y,c(2,1,3))
  y<-y[130:1,,]
  save(y,file=paste0("v.1.0.0/data/output/",name,".rda"))
}

# years 2020, 2022, 2023 are affected by geo-misalligned grids
# due to input data (they are built on different grids)
# a possible approach for allignment is available in:
# FRK-DataFusion/v.1.0.0/script/Modelling.R - section A.b1