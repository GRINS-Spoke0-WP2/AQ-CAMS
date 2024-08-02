CAMS_request <- function(month,year,user){
  if (year > 2021) {
    dataset<-"interim_reanalysis"
  }else{
    dataset<-"validated_reanalysis"
  }
  month<-as.character(month)
  if (nchar(month)==1) {
    month <- paste0("0",month)
  }
  year<-as.character(year)
  key<-wf_get_key(user,service = "ads")
  wf_set_key(user = user,key = key,service = "ads")
  request <- list(
    type = dataset,
    year = year,
    format = "zip",
    model = "ensemble",
    level = "0",
    month = month,
    variable = c("ammonia", "carbon_monoxide", "nitrogen_dioxide",
                 "nitrogen_monoxide", "non_methane_vocs", "ozone",
                 "particulate_matter_10um", "particulate_matter_2.5um", "sulphur_dioxide"),
    dataset_short_name = "cams-europe-air-quality-reanalyses",
    target = "download.zip"
  )
  ncfile <- wf_request(user = user,
                       request = request,
                       transfer = TRUE,
                       path = "~",
                       verbose = FALSE)
  return(ncfile)
}

nc_cut_CAMS <- function(ncfile,
                        boundary,
                        ncname,
                        path_in,
                        path_out) {
  nc <- nc_open(paste0(path_in, "/", ncfile))
  b <- boundary
  lo <- round(ncvar_get(nc, "lon"), 2)
  la <- round(ncvar_get(nc, "lat"), 2)
  st <- c(nrow(lo[lo <= b[1]]),
          nrow(la[la <= b[3]]),
          1)
  co <- c(nrow(lo[lo >= b[1] & lo <= b[2]]),
          nrow(la[la >= b[3] & la <= b[4]]),
          nc$dim$time$len)
  x <- ncvar_get(nc, "lon", start = st[1], count = co[1])
  y <- ncvar_get(nc, "lat", start = st[2], count = co[2])
  t <- ncvar_get(nc, "time", start = st[3], count = co[3])
  listnames <- names(nc[15]$var)
  listnames <- listnames[listnames != "date"]
  Nvars <- length(listnames)
  ncvar <- list()
  for (i in 1:Nvars) {
    ncvar[[i]] <- ncvar_get(nc, listnames[i], start = st, count = co)
  }
  ncp <- paste0(path_out, "/")
  ncn <- ncname
  ncf <- paste0(ncp, ncn)
  londim <- ncdim_def(nc$dim$lon$name,
                      nc$dim$lon$units,
                      as.double(x))
  latdim <- ncdim_def(nc$dim$lat$name,
                      nc$dim$lat$units,
                      as.double(y))
  timedim <- ncdim_def(nc$dim$time$name,
                       nc$dim$time$units,
                       as.double(t))
  listvar <- list()
  for (i in 1:Nvars) {
    listvar[[i]] <- ncvar_def(listnames[[i]],
                              nc$var[[1]][[8]],
                              list(londim, latdim, timedim),
                              prec = nc$var[[1]][[7]])
  }
  ncout <- nc_create(ncf, listvar, force_v4 = TRUE)
  for (i in 1:Nvars) {
    ncvar_put(ncout, listvar[[i]], ncvar[[i]])
  }
  ncatt_put(ncout, "lon", "axis", "x")
  ncatt_put(ncout, "lat", "axis", "y")
  ncatt_put(ncout, "time", "axis", "t")
  nc_close(ncout)
}

download_CAMS <- function(m1, y1, user) {
  for (m in m1) {
    for (y in y1) {
      print(paste("m=", m, "y=", y))
      CAMS_request(m, y, user)
      unzip("download.zip", exdir = "data/AQ/CAMS/unzipped")
      file.remove("download.zip")
      files <- list.files(path = "data/AQ/CAMS/unzipped", pattern = "*.nc")
      B_IT <- c(6, 19, 35, 48)
      for (nf in 1:length(files)) {
        nc_cut_CAMS(
          files[nf],
          B_IT,
          paste0("ITALY_", files[nf]),
          "data/AQ/CAMS/unzipped",
          "data/AQ/CAMS/cropped"
        )
        file.remove(paste0("data/AQ/CAMS/unzipped/", files[nf]))
      }
    }
  }
}

