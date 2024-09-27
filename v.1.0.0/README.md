# AQ-CAMS/v.1.0.0

The following steps are made:

1. [Download](#CAMS-1-Download)
2. [Regional crop](#CAMS-2-Regional-crop)
3. [Change of temporal resolution](#CAMS-3-Change-of-temporal-resolution)

## CAMS 1: Download
The download is made automatically within the script [`CAMS_download.R`](script/AQ/CAMS/CAMS_download.R). The download is quite fast but it is downloaded a zip file containing all the European 

## CAMS 2: Regional crop
The zip file contatining all Europe is opened and data are cropped into the Italian domain thorugh the *nc_cut* function.

## CAMS 3: Changine temporal resolution
Data are hourly, therefore we keep the minimum, 1st quartile, mean, medium, 3rd quartile, maximum of the day.
