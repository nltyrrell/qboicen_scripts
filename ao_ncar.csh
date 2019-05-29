#!/bin/ksh

# This script reproduces the AO index for NCEP/NCAR data (as in NOAA) following their methodology from http://www.cpc.ncep.noaa.gov/products/precip/CWlink/daily_ao_index/ao.shtml#current

#--------------------- Pre-processing data --------------------#
# Notes:
#	- Input data should be monthly and daily geopotential height ANOMALIES at 1000 hPa from 20-90N, 0-360 lon
#	- For getting the EOF (spatial pattern) only MONTHLY data from 1979-2000 are used
#	- Still, indices can be obtained for both monthly and daily data, and for periods longer than 1979-2000 


#------------------------- Compute EOF -------------------------#
# Notes:
#	- The first two EOF are computed
#	- Explained variance is displayed in screen only
#	- CDO_WEIGHT_MODE=on to consider differences in gridcell areas with latitude
# 	- The principal component (temporal coefficients) are not used for the index computation

NEOF=2

# 1) Get file ready (set missing values to zero, if any)
cdo setmisstoc,0 /exports/csce/datastore/geos/groups/teleconn/AO/z_manom_1979-2000_NH.nc z_manom_1979-2000_NH_nomissval.nc

# 2) Compute EOFs and PCs:
export CDO_WEIGHT_MODE=on
cdo eof,$NEOF z_manom_1979-2000_NH_nomissval.nc z_manom_1979-2000_NH_eigenval_weighted.nc z_manom_1979-2000_NH_eof_weighted.nc
cdo eofcoeff z_manom_1979-2000_NH_eof_weighted.nc z_manom_1979-2000_NH_nomissval.nc z_manom_1979-2000_NH_pc_weighted_

# 3) Compute explained variance:
cdo -div z_manom_1979-2000_NH_eigenval_weighted.nc -timsum z_manom_1979-2000_NH_eigenval_weighted.nc z_manom_1979-2000_NH_explvar_weighted.nc

for ((i=1; i<=$NEOF-1; ++i)) ; do
  cdo -seltimestep,${i} z_manom_1979-2000_NH_explvar_weighted.nc z_manom_1979-2000_NH_explvar_some.nc
  MODE=`cdo output -mulc,100 z_manom_1979-2000_NH_explvar_some.nc | sed  "s- --g"`
  echo "EOF MODE ${i}: $MODE" 
done

#rm files no longer used
rm z_manom_1979-2000_NH_explvar_some.nc z_manom_1979-2000_NH_nomissval.nc z_manom_1979-2000_NH_pc_weighted_00001.nc

# Select first EOF only (timestep should be = 1 for next part to work properly)
cdo seltimestep,1 z_manom_1979-2000_NH_eof_weighted.nc eof1_mon.nc 


#--------------------- Compute AO indices ---------------------#
# Notes:
#	- To get the AO indices, we project the monthly and daily height anomalies at 1000 hPa [20-90N, 0-360] onto the leading monthly EOF mode
#	- Both (monthly and daily) indices are standardised by the MONTHLY std
#	- **The lenght on the indices depends on the lenght of the z1000 anomalies used (in here periods longer than 1979-2000 can be input)

# --- Monthly:
cdo mul eof1_mon.nc /exports/csce/datastore/geos/groups/teleconn/AO/z_manom_1979-2000_NH.nc proj1_mon.nc
cdo -chname,var7,ao -fldmean proj1_mon.nc ao_nostd_mon.nc
cdo ymonstd ao_nostd_mon.nc ao_ymonstd_mon.nc # to be used for daily index too
cdo div ao_nostd_mon.nc ao_ymonstd_mon.nc ao_ncar_mon.nc
rm proj1_mon.nc ao_nostd_mon.nc # remove some files after having a quick look at them

# --- Daily:
cdo mul eof1_mon.nc /exports/csce/datastore/geos/groups/teleconn/AO/z_danom_1979-2000_NH.nc proj1_day.nc
cdo -chname,var7,ao -fldmean proj1_day.nc ao_nostd_day.nc
# Use monthy std for daily index too. As monthly std has 12 values only, we need to use the loop below to make sure we divide the 31 days from January by the respective January mon std and so on for the other months:

MON=1
  while [ $MON -le 12 ] ;do     
	cdo -selmon,$MON ao_nostd_day.nc f1_$MON.nc
	cdo selmon,$MON ao_ymonstd_mon.nc f2_$MON.nc
	cdo div f1_$MON.nc f2_$MON.nc ao_m$MON.nc
      let MON=MON+1

  done

cdo mergetime ao_m*.nc ao_ncar_day.nc
rm f1_*.nc f2_*.nc ao_m*.nc

rm proj1_day.nc ao_nostd_day.nc # remove some files after having a quick look at them

 
