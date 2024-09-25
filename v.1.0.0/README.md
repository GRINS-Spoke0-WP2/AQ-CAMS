# Copernicus Atmosphere Monitoring Service (CAMS)

The second dataset accessed for the obtaining of air quality data is the *air quality reanalysis* dataset provided by the Copernicus Atmosphere Monitoring Service (CAMS) [reference link](https://ads.atmosphere.copernicus.eu/cdsapp#!/dataset/cams-europe-air-quality-reanalyses?tab=overview). CAMS is one of six services that form Copernicus, the European Union's Earth observation programme which looks at the planet and its environment. Copernicus offers information services based on satellite Earth observation, in situ (non-satellite) data and modelling.

The *air quality reanalysis* data are on a regular grid, covering the European continent from 2013 to 2023. It provides hourly concentrations for several air pollutants. The spatial resolution is 0.1° x 0.1°. The *air quality reanalysis* is based on 11 Chemical Transport Model. The ENSEMBLE output is the median. Two streams are available: "interim" and "validated". The former with data not validated by national institutes but released sooner, the latter with validated data. At the current date (3/6/2024). The period covered is from 2013 to 2021 for validated, 2022 and 2023 for interim. In @tbl-variables are summarised the variables downloade in the *air quality reanalysis* and the starting period.

| Variable Name                                                                       | NetCDF Units | Variable name in ADS                     | Period From |
|---------------------|-----------------|-----------------|-----------------|
| Ammonia\*                                                                           | µg m-3       | ammonia                                  | 2018        |
| Carbon monoxide                                                                     | µg m-3       | carbon_monoxide                          | 2016        |
| Nitrogen dioxide                                                                    | µg m-3       | nitrogen_dioxide                         | 2013        |
| Nitrogen monoxide                                                                   | µg m-3       | nitrogen_monoxide                        | 2018        |
| Non-methane volatile compounds (VOCs)\*                                             | µg m-3       | non_methane_vocs                         | 2018        |
| Ozone                                                                               | µg m-3       | ozone                                    | 2013        |
| Particulate matter d \< 10 µm (PM10)                                                | µg m-3       | particulate_matter\_ 10um                | 2013        |
| Particulate matter d \< 2.5 µm (PM2.5)                                              | µg m-3       | particulate_matter\_ 2.5um               | 2013        |
| Sulphur dioxide                                                                     | µg m-3       | sulphur_dioxide                          | 2016        |
| \*experimental                                                                      |              |                                          |             |

*Table  Variables available in the air quality reanalysis {#tbl-variables}

Moreover, in-situ observations are used as input to constrain the models. In particular the following chemical species are considered: O3, NO2, SO2, CO, PM2.5, PM10.

### CAMS 1: Download
The download is made automatically within the script [`CAMS_download.R`](script/AQ/CAMS/CAMS_download.R). The zip file contatining all Europe is opened and data are cropped into the Italian domain thorugh the *nc_cut* function.

### CAMS 2: Converting temporal resolution
Data are hourly, therefore we keep the minimum, 1st quartile, mean, medium, 3rd quartile, maximum of the day.


