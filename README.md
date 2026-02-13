# SmartMet-server for AURORA Clima project 

SmartMet Server is a data and product server which provides acces to both observation and forecast data. It is used for data services and product generation. Smartmet Server can read input from various sources and it provides several ouput interfaces and formats. For more detailed description, see the [SmartMet Server wiki pages](https://github.com/fmidev/smartmet-server/wiki). The setup used for HARMONIA is the same as in https://github.com/fmidev/harvesterseasons-smartmet/ installed in two different machines based on sponsored computing resources from WEkEO and EuroHPC.

SmartMet Server purpose is a service to make data available directly to web apps without needing any data downloading and processing steps on a server. You can directly write javascript web apps to use Copernicus data. To get a feel for the data offered https://harmonia.geoss.space/grid-gui or even more on https://urban.geoss.space/grid-gui are general data browsers. This service has datasets from several producers (f.ex. currently working: ERA5, ECSF, ECB2SF, ECBSF). ECSF, ECB2SF and ECBSF seasonal forecasts are available once per month for 215 daily forecasts 7 months ahead. ERA5 is every day the reanalysis from 5 days ago. To utilize datasets shown on this service, the SmartMet Server TimeSeries plugin can be used.

For example web app code using a smartmet-server check out the https://github.com/fmidev/harvesterseasons-site repository and check out the service https://harvesterseasons.com.

# Using the Timeseries API for data in table format

The TimeSeries plugin can be used to fetch time series information for observation and forecast data, with specific time or time interval chosen by the user. The datasets can be downloaded with a HTTP request which contains the parameters needed to obtain the information, processing the results and formatting the output.
For example, the following simple request fetches the 'total precipitation in meters (RR-M)' for Milan (lat 45.464664, lon 9.188540):

`https://harmonia.geoss.space/timeseries?lonlat=9.188540,45.464664&format=debug&param=name,time,RR-M:ERA5:5021:1:0:1&starttime=20220501T000000&precision=full`

The service location that starts the HTTP request query is **harmonia.geoss.space**, and the parameters following it are given as name-value pairs separated by the ampersand (&) character. (Hint: copy the FMI key from the https://harmonia.geoss.space/grid-gui service for the parameter definition 'param'.)

An example response for this query is shown below: 

![timeseries output](https://github.com/fmidev/harmonia-smartmet/blob/main/example_timeseries_RR-M.png)

For more information and examples of the usage of the TimeSeries plugin, see SmartMet Server [Timeseries-plugin Wiki pages](https://github.com/fmidev/smartmet-plugin-timeseries/wiki). 

# Using the WMS/Dali plugin for images

Dali is the engine to make images from smartmet-server internal data. It can be used directly or with appropriate layer definitions can provide an OGC compliant WebMapService interface. Open Geospatial Consortiums (OGC) Web Map Service (WMS) offers a convenient way for generating map images from a map server over the Web using the HTTP protocol. Several image products can be generated using the SmartMet Server WMS plugin. 

An example WMS request to the server tbd

An example response for this query is shown below: tbd 

Available WMS 'LAYERS' can be checked with the GetCapabilities request as follows: 

`https://harmonia.geoss.space/wms?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities`

# A new API for sophisticated data retrieval OGC EDR Environmental Data Retrieval
https://ogcapi.ogc.org/edr/ is a new API to get data in CoverageJSON or GeoJson formats with a restful service. Check out https://urban.geoss.space/edr/collections for this cool new feature.
retrie
