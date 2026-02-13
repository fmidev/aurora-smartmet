# SmartMet-server for AURORA Clima project

SmartMet Server is a data and product server which provides acces to both observation and forecast data. It is used for data services and product generation. Smartmet Server can read input from various sources and it provides several ouput interfaces and formats. For more detailed description, see the [SmartMet Server wiki pages](https://github.com/fmidev/smartmet-server/wiki). The setup used for AURORA is the same as in https://github.com/fmidev/harvesterseasons-smartmet/ installed in two different machines based on sponsored computing resources from WEkEO and EuroHPC.

SmartMet Server purpose is a service to make data available directly to web apps without needing any data downloading and processing steps on a server. You can directly write javascript web apps to use Copernicus data. To get a feel for the data offered, go to https://urban.geoss.space/grid-gui . This is a general data browser. This service has datasets from several producers (f.ex. currently working: CMIP6-ssp245, ERA5, ECENS, ECSF, ECBSF). 

For example web app code using a smartmet-server check out the https://github.com/fmidev/harvesterseasons-site repository and check out the service https://harvesterseasons.com.

# Data available for the AURORA Clima project
This is the place for meteorological model data to be used in AURORA. SmartMet-servers build the route to data via a hierarchy of producer-generation-variable

## Producers
ERA5 reanalysis data is available for analysing past conditions and building training data for machine learning. Generations 2000-01-01 and 1995-01-01 are available with the latter extending to 5 more years of data into the past. ERA5 is updated every day for the situation from 5 days ago.

ECENS is the producer for weather forecast ensembles from the ECMWF model for 15-day forecasts.

ECSF and ECBSF seasonal forecasts are available once per month for 215 daily forecasts (~7 months) ahead. 

In addition there will be a highresolution (1km or better) temperature product from the producer AURORA as the result from the ML model to reveal Urban Heat Islands.

To utilize datasets shown on this service, the SmartMet Server TimeSeries plugin can be used.

## Variables

Aurora analysis has chosen these variables to be available from each source:
- evaporation
- total precipitation
- wind speed
- 2m air temperature (+ min/max daily temperatures)
- relative humidity
- sea level pressure

The time scales available are mostly daily and for climate predictions monthly.
Tallinn also requested for sea surface temperature and sea surface height.

## Climate prediction models

20 models were fetched to be bias-adjusted/downscaled with ERA5 over the period 1995 to 2024. 
The script doing the bias-adjustment is ![ba-cmip6-ensmble.sh](ba-cmip6-ensemble.sh). 
First climate model historical data 1995-2014 are merged with ssp245 data 2015-2024. This data is then substracted with ERA5 timeseries of the same period at monthly time steps.

| Model | evaporation - evspsbl | relative humidity - hur | precipitation - pr | sea level pressure - psl | wind speed at 10m - sfcWind | air temperature at 2m - tas | minimum tas - mn2t24 | maximum tas - mx2t24 |
|-------|---------|-----|----|----|---------|-----|--------|--------|
| AWI-CM-1-1-MR | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| BCC-CSM2-MR | 2 | - | 2 | 2 | 2 | 2 | 2 | 2 |
| CAMS-CSM1-0 | - | - | 3 | 3 | - | 3 | - | - |
| CESM2 | 3 | 2 | 4 | 4 | 3 | 4 | 3 | 3 |
| CIESM | - | - | - | - | - | 5 | 4 | 4 |
| CMCC-ESM2 | 4 | 3 | 5 | 5 | 4 | 6 | 5 | 5 |
| CNRM-CM6-1-HR | 5 | 4 | 6 | 6 | 5 | 7 | 6 | 6 |
| EC-Earth3-CC | 6 | 5 | 7 | 7 | 6 | 8 | 7 | 7 |
| FGOALS-f3-L | 7 | - | 8 | 8 | 7 | 9 | - | - |
| FIO-ESM-2-0 | 8 | 6 | 9 | 9 | 8 | 10 | 8 | 8 |
| GFDL-ESM4 | 9 | 7 | 10 | 10 | 9 | 11 | 9 | 9 |
| IITM-ESM | 10 | - | 11 | 11 | 10 | 12 | - | - |
| INM-CM5-0 | 11 | 8 | 12 | 12 | 11 | 13 | 10 | 10 |
| MPI-ESM1-2-LR | 12 | 9 | 13 | 13 | 12 | 14 | 11 | 11 |
| MRI-ESM2-0 | 13 | - | 14 | 14 | 13 | 15 | 12 | 12 |
| NorESM2-MM | 14 | - | 15 | 15 | 14 | 16 | - | - |
| TaiESM1 | 15 | 10 | 16 | 16 | 15 | 17 | - | - |


# Using the Timeseries API for data in table format

The TimeSeries plugin can be used to fetch time series information for observation and forecast data, with specific time or time interval chosen by the user. The datasets can be downloaded with a HTTP request which contains the parameters needed to obtain the information, processing the results and formatting the output.
For example, the following simple request fetches the 'total precipitation in meters (RR-M)' for Milan (lat 45.464664, lon 9.188540):

`https://urban.geoss.space/timeseries?lonlat=9.188540,45.464664&format=debug&param=name,time,RR-M:ERA5:5021:1:0:1&starttime=20220501T000000&precision=full`

The service location that starts the HTTP request query is **urban.geoss.space**, and the parameters following it are given as name-value pairs separated by the ampersand (&) character. (Hint: copy the FMI key from the https://urban.geoss.space/grid-gui service for the parameter definition 'param'.)

An example response for this query is shown below: 

![timeseries output](https://github.com/fmidev/harmonia-smartmet/blob/main/example_timeseries_RR-M.png)

For more information and examples of the usage of the TimeSeries plugin, see SmartMet Server [Timeseries-plugin Wiki pages](https://github.com/fmidev/smartmet-plugin-timeseries/wiki). 

# Using the WMS/Dali plugin for images

Dali is the engine to make images from smartmet-server internal data. It can be used directly or with appropriate layer definitions can provide an OGC compliant WebMapService interface. Open Geospatial Consortiums (OGC) Web Map Service (WMS) offers a convenient way for generating map images from a map server over the Web using the HTTP protocol. Several image products can be generated using the SmartMet Server WMS plugin. 

An example WMS request to the server tbd

An example response for this query is shown below: tbd 

Available WMS 'LAYERS' can be checked with the GetCapabilities request as follows: 

`https://urban.geoss.space/wms?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities`

# A new API for sophisticated data retrieval OGC EDR Environmental Data Retrieval
https://ogcapi.ogc.org/edr/ is a new API to get data in CoverageJSON or GeoJson formats with a restful service. Check out https://urban.geoss.space/edr/collections for this cool new feature.
