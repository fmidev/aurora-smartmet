#!/bin/bash
# join history plus 2015-2024 ssp245 to calculate bias/variance for each climate projection model, 
# for the specified variable (e.g., CMIP name tas and its grib shortname 2t) third is var in ERA5 as it can be with different name
# usage example: ba-cmip6-ensemble.sh 2t tas 2t
var=$1
nvar=$2
evar=$3
eevar=$4
# This script merges the historical and ssp245 data for the specified variable (e.g., tas) 
# across the specified models, and outputs a GRIB file for each model data from 1995 to 2024.
cd /home/ubuntu/data/cmip6
[[ ! -s TaiESM1_19950101T000000_20241231T000000-${nvar}-fix.nc ]] && \
 parallel cdo -O -settime,00:00:00 -setday,16 -selyear,1995/2024 -mergetime \
 [ -selyear,1995/2014 -selname,${nvar} ${nvar}_Amon_{1}_historical_*_1995011?-2014121?.nc \
  -selyear,2015/2024 -selname,${nvar} ${nvar}_Amon_{1}_ssp245*_2015011?-2099121?.nc ] \
  {1}_19950101T000000_20241231T000000-${nvar}.nc :::: models-${nvar}.lst && \
 parallel ncatted -O -a bounds,time,d,, {1}_19950101T000000_20241231T000000-${nvar}.nc \
  {1}_19950101T000000_20241231T000000-${nvar}-fix.nc :::: models-${nvar}.lst  && \
   rm {1}_19950101T000000_20241231T000000-${nvar}*.nc || echo "already merged"
#  parallel cdo --eccodes -O -b P16 -f grb2 settime,00:00:00 -setparam,"${eevar}" -setday,16 \
#   {1}_19950101T000000_20241231T000000-${nvar}-fix.nc {1}_19950101T000000_20241231T000000-${nvar}.grib :::: models-${nvar}.lst \
wait
# script then calculates the bias and variance of the merged data against ERA5 dataset for the specified variable, and outputs the results in GRIB format.
cd ..
[[ ! -s cmip6/eera5-TaiESM1_19950101T000000_${nvar}_bias_eu.grib ]] && \
 parallel calc_bias_var.sh eera5_1995-2025_mon-rh-eu.grib {} ${nvar} $evar $eevar ::: cmip6/*_1995*${nvar}.nc
wait
mv eera5-*_eu.grib cmip6/
# Finally, the script remaps the bias-corrected data to the ERA5 grid and outputs GRIB files for each model and variable.
cd cmip6
[[ ! -s CMIP-ssp585_20150101T000000_TaiESM1_${var}-eu.grib ]] && \
parallel cdo -f grb -b P16 setparam,"${eevar}" -selyear,2015/2099 -ymonadd -remapdis,../eera5-eu-grid \
 ${nvar}_Amon_{1}_{2}_*.nc eera5-{1}-19950101T000000_1995-2025_${nvar}_bias_eu.grib \
 CMIP6-{2}_20150101T000000_{1}_${var}-eu.grib :::: models-${nvar}.lst ::: ssp245 ssp585
wait
tn=$(ls CMIP6-ssp245_20150101T000000_*_${var}-eu.grib | wc -l)
# combine bias-corrected data with the original ssp245 and ssp585 data into ensembles for practical use.
parallel -k grib_set -s centre=98,stepType=avg,stepUnits=1,stepRange=672,startStep=672,endStep=672,setLocalDefinition=1,localDefinitionNumber=16,totalNumber=${tn},number={2} \
 CMIP6-ssp245_20150101T000000_{1}_${var}-eu.grib ../grib/CMIP6-ssp245_20150101T000000_{1}_${var}-eu.grib \
 :::: models-${nvar}.lst :::+ `seq 1 ${tn}`
parallel -k grib_set -s centre=98,stepType=avg,stepUnits=1,stepRange=672,startStep=672,endStep=672,setLocalDefinition=1,localDefinitionNumber=16,totalNumber=${tn},number={2} \
 CMIP6-ssp585_20150101T000000_{1}_${var}-eu.grib ../grib/CMIP6-ssp585_20150101T000000_{1}_${var}-eu.grib \
 :::: models-${nvar}.lst :::+ `seq 1 ${tn}`
