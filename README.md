# Introduction

The goal of the GRINS (Growing Resiliant INclusive and Sustainable) project is to help the Italian community to grow efficiently as well as resilient, inclusive and sustainable. This important and challenging goal will be reached thank to the deeper comprehension of the reality. Data are the mirror of reality, but they must be collected, validated, re-organised, harmonised, analysed, visualised and finally interpreted. Statistical tools are the only instruments capable of performing these operations on the data, so they are indispensable for achieving the goals of the GRINS project.

The team of the University of Bergamo (UNIBG) involved in the spoke 0, more specifically in the Work Package 0.2 (WP0.2), leaded by Prof. Alessandro Fassò, is proposing to use a common methodology for data harmonisation among the groups of the project. In particular, these methods are suitable for spatial and temporal data. UNIBG works mainly with environmental data: weather, air quality and emissions. Harmonised data, with the same spatial and temporal resolution (i.e. municipality and daily), will compose the dataset used by the AMELIA platform. More specifically, this dataset will represent the deliverable D.0.2.1 of the GRINS project.

# Air Quality data (AQ)

Air quality data are usually **observed** or **modeled**. **Observed** data represent the measurements made by operators and machines. They reflect the best approximation of the reality but they are prone to missingness, measurement errors, heterogeneity among measurements procedures, sparse availability, and other issues. **Modeled** data, on the other hand, generally show completeness and uniformity but they can significantly differ from the reality. Almost all mathematical models generating modeled data are divided in two different categories: **deterministic** and **stochastic**.

For the Italian domain, we retrieve AQ data from two different sources: the European Environmental Agency (**EEA**) and the Copernicus Atmosphere Monitoring Service (**CAMS**). **EEA** data are **observed** from the air quality monitoring stations and **CAMS** data are based on an ensemble of nine air quality data assimilation systems across Europe that use CTMs as based. Technical details about the sources are contained in the download sections [EEA 1: Download](#EEA-1-Download) and [CAMS 1: Download](#CAMS-1-Download), respectively. EEA data are available just at specific locations (the air quality monitoring network) while CAMS products are available on a full grid (cell centers lie on orthogonal straight lines) and cropped over the Italian domain. To use both the EEA and CAMS data simultaneously, data fusion techniques are required. 

## Copernicus Atmosphere Monitoring Service (CAMS)

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


