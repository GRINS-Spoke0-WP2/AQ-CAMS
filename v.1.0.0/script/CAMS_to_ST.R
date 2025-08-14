library(abind)
library(sp)
library(spacetime)
lf2 <- list.files("AQ-CAMS/v.1.0.0/data/output")
lf2 <- lf2[order(lf2)]
dim_l <- list()
vrbls <- c("so2","pm25","pm10","o3","voc","nh3","co","no2")
# problem with variable "no"
for (vrbls_i in vrbls) {
  lf <- lf2[grep(vrbls_i,lf2)]

for (i in lf) {
  load(paste0("AQ-CAMS/v.1.0.0/data/output/", i))
  dim_l[[which(lf == i)]] <-
    list(dimnames(y)[[1]], dimnames(y)[[2]], dim(y),
         as.Date(as.numeric(dimnames(y)[[3]][1])))
}

for (i in lf) {
  load(paste0("AQ-CAMS/v.1.0.0/data/output/", i))
  if (dim(y)[2] != 130) {
    y <- y[, -131, ]
  }
  if (i == lf[1]) {
    Y <- y
  }
  if (!identical(dimnames(y)[[2]],
                 dimnames(Y)[[2]])) {
    # manually corrected 2019 e 2021
    y <- y +
      abind(y[, -1, ], y[, 130, ], along = 2) +
      abind(abind(y[, -1, ], y[, 130, ], along = 2)[-1, , ], y[130, , ], along =
              1) +
      abind(y[-1, , ], y[130, , ], along = 1)
    y <- y / 4
    dimnames(y)[[1]] <- dimnames(Y)[[1]]
    dimnames(y)[[2]] <- dimnames(Y)[[2]]
  }
  if (!identical(dim(y)[1:2], dim(Y)[1:2])) {
    stop("different dimension")
  }
  if (any(!identical(dimnames(y)[[1]], dimnames(Y)[[1]]),!identical(dimnames(y)[[2]], dimnames(Y)[[2]]))) {
    stop("different centres")
  }
  if (i != lf[1]) {
    Y <- abind(Y, y, along = 3)
  }
  rm(y)
}

AQ_CAMS_v100_matrix <- Y
# exporting matrix
# save(AQ_CAMS_v100_matrix, file = "AQ-Modelling/v.1.0.0/data/input/AQ_CAMS_v100_matrix.rda")

AQ_CAMS_v100_df <- data.frame(
  Longitude = rep(rep(dimnames(Y)[[2]], each = dim(Y)[1]), dim(Y)[3]),
  Latitude = rep(dimnames(Y)[[1]], dim(Y)[2] * dim(Y)[3]),
  time = rep(as.Date(as.numeric(dimnames(
    Y
  )[[3]])), each = dim(Y)[2] * dim(Y)[1]),
  var_i = c(Y)
)
names(AQ_CAMS_v100_df)[4]<-toupper(vrbls_i)
Y <- AQ_CAMS_v100_matrix
centre <-
  data.frame(Longitude = rep(rep(dimnames(Y)[[2]], each = dim(Y)[1])),
             Latitude = rep(dimnames(Y)[[1]], dim(Y)[2]))
centre <-
  data.frame(Longitude = as.numeric(rep(rep(
    dimnames(Y)[[2]], each = dim(Y)[1]
  ))),
  Latitude = as.numeric(rep(dimnames(Y)[[1]], dim(Y)[2])))
coordinates(centre) <- c("Longitude", "Latitude")
gridded(centre) <- TRUE
colnames(centre@coords) <- c("coords.x1", "coords.x2")
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(centre, "proj4string") <- crs_wgs84
AQ_CAMS_v100_ST <- STFDF(sp = centre,
                         time = unique(AQ_CAMS_v100_df$time),
                         data = AQ_CAMS_v100_df)
# stplot(AQ_CAMS_v100_ST[, 1:2, "NO2"])
save(AQ_CAMS_v100_ST , file = paste0("AQ-CAMS/v.1.0.0/data/output/ST/AQ_CAMS_v100_ST_",vrbls_i,".rda"))
}
