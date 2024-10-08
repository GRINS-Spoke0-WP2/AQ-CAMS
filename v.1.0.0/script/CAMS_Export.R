setwd("AQ-CAMS")

lf <- list.files("v.1.0.0/data/1p1y")
for (i in lf) {
  load(paste0("v.1.0.0/data/1p1y/",i))
  grid_all <- grid_all[order(grid_all$days,grid_all$lat,grid_all$lon),]
  y <- array(grid_all$mean_no2,
             dim = c(length(unique(grid_all$lon)),
                     length(unique(grid_all$lat)),
                     length(unique(grid_all$days))),
             dimnames = list(unique(grid_all$lon),
                             unique(grid_all$lat),
                             unique(grid_all$days))
  )
  name <- substr(i, nchar(i)-13,nchar(i)-6)
  y <- aperm(y,c(2,1,3))
  y<-y[130:1,,]
  save(y,file=paste0("v.1.0.0/data/output/",name,".rda"))
}
