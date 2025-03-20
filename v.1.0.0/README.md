# AQ-CAMS/v.1.0.0

! WARNING ! 6/10/2024: After the change of the official website and the procedure of the Copernicus Atmosphere Monitoring Service, the correctness of the download process is no longer guaranteed. However, the quality of the data is not affected.

The following steps are made:

1. [Download & regional crop](#CAMS-1-Download-&-regional-crop)
2. [Change of temporal resolution](#CAMS-2-Change-of-temporal-resolution)
3. [Export](#CAMS-3-Export)
## CAMS 1: Download & regional crop
The download is made automatically within the script [`CAMS_Download.R`](script/CAMS_Download.R). The download is quite fast but it is downloaded a zip file containing all the European region.

## CAMS 2: Changing temporal resolution
Data are hourly, therefore we keep the minimum, 1st quartile, mean, medium, 3rd quartile, maximum of the day. This step is made in the script [`CAMS_HtoD.R`](script/CAMS_HtoD.R).

## CAMS 3: Export
Data are exported in matrix for saving dimension in [`CAMS_Export.R`](script/CAMS_HtoD.R).
ciao