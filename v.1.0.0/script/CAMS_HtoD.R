# In this script the monthly netcdf files of CAMS ari quality data are 
# converted to long table in Rdata using parallelization on 12 cores

rm(list=ls())
gc()

library(doParallel)
library(foreach)
library(abind)
registerDoParallel()

CAMSfiles <-
  list.files(path = "data/AQ/CAMS/cropped",
             pattern = ".nc")
CAMSpoll <-
  c("co", "nh3", "nmvoc", "no", "no2", "o3", "pm10", "pm2p5", "so2")
CAMSfiles_p <- list()
for (p in CAMSpoll) {
  CAMSfiles_p[[which(CAMSpoll == p)]] <-
    CAMSfiles[grep(p, CAMSfiles)]
}
sum(sapply(CAMSfiles_p, length))
#WATCH OUT FOR POLLUTANT NAME CONTAINED IN OTHER NAME e.g. NO and NO2, they have to be fixed manually
CAMSfiles_p[[4]] <- CAMSfiles_p[[4]][-grep("no2", CAMSfiles_p[[4]])]
sum(sapply(CAMSfiles_p, length)) #OK

for (i in 1:length(CAMSfiles_p)) {
  CAMSfiles_pi <- CAMSfiles_p[[i]]
  times <- c()
  for (nf in 1:length(CAMSfiles_pi)) {
    lf <- nchar(CAMSfiles_pi[nf])
    times[nf] <- substr(CAMSfiles_pi[nf], lf - 9, lf - 3)
  }
  times <- unique(times)
  times <- times[order(times)]
  y1 <- as.numeric(substr(times[1], 1, 4))
  y2 <- as.numeric(substr(times[length(times)], 1, 4))
  for (y in y1:y2) {
    print(paste("Start: Year", (y)))
    CAMSfiles_p_y <-
      CAMSfiles_pi[grep(y, CAMSfiles_pi)]
    if (length(CAMSfiles_p_y) > 0) {
      grid_all <-
        foreach (j = CAMSfiles_p_y,
                 .packages = c("ncdf4","abind"),
                 .combine = rbind) %dopar% {
                   nc <- nc_open(paste0("data/AQ/CAMS/cropped/", j))
                   aq_pol <- nc$var[[1]][[2]]
                   print(paste(aq_pol, (
                     which(CAMSfiles_pi == j) / length(CAMSfiles_pi)
                   ) * 100))
                   aq <- ncvar_get(nc, aq_pol)
                   aq3d <- array(NA,
                                 dim = c(nc$dim$lat$len,
                                         nc$dim$lon$len,
                                         nc$dim$time$len / 24,
                                         6))
                   for (i in (1:(dim(aq)[3] / 24))) {
                     aq3d[, , i , ] <- abind(aperm(apply(aq[, , c(((i - 1) * 24):(i * 24))], c(1, 2), quantile),
                                                   c(2, 3, 1)),
                                             apply(aq[, , c(((i - 1) * 24):(i * 24))], c(1, 2), mean),
                                             along = 3)
                   }
                   lat <- ncvar_get(nc, "lat")
                   lon <- ncvar_get(nc, "lon")
                   grid <- expand.grid(lon, lat)
                   t <- nc$dim$time$len
                   grid <-
                     data.frame(lon = rep(grid$Var1, t / 24),
                                lat = rep(grid$Var2, t / 24))
                   names(grid)[1:2] <- c("lon", "lat")
                   first_day <- as.Date(substr(nc$dim$time$units, 13, 100))
                   grid$days <-
                     rep(
                       seq.Date(
                         from = first_day,
                         length.out = t / 24,
                         by = "days"
                       ),
                       each = length(lon) * length(lat)
                     )
                   grid <-
                     data.frame(cbind(grid, matrix(as.vector(aq3d), ncol = 6)))
                   grid <- grid[, c(1:6, 9, 7:8)]
                   names(grid)[-c(1:3)] <-
                     paste0(c("min_", "1q_", "med_", "mean_", "3q_", "max_"), aq_pol)
                   grid_all <- grid
                   grid_all
                 }
      # source(paste0(pathHPC,"/Script/CAMS/HPC/checking_H_t_D_CAMS_HPC.R")) #checking
      save(
        grid_all,
        file = paste0("data/AQ/CAMS/1p1y/CAMS_1p1y_",
          substr(names(grid_all)[4],5,10),
          "_",
          y,
          ".Rdata"
        )
      )
      rm(grid_all)
      rm(nc)
    }
  }
}



