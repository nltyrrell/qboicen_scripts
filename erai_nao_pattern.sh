#!/bin/bash

set -e

##############################################
# Calculate the 1st EOF for psl -90 to 40 lon, 20 to 70 lat, to be used for NAO calculation
# Usage:
# $ nao_pattern_mon.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename
# 
# nicholas tyrrell 2019
# 

model="erai"
tmean="mon"
punits=""
lat_size="181"
qbo_plev="30"
model_dir=""
model_filename=""
out_dir="/ibrix/arch/aledata/tyrrell/erai/cen_data/"

# Define variable paths and names
era_dir="/ibrix/arch/aledata/tyrrell/erai/cen_data"
psl_in_file="${era_dir}/erai_psl_1979-2014_${tmean}.nc"

echo "Getting data from: ${group}"

#========================================

#========== DONT CHANGE THESE ============

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

# ----====> EOF1 for NAO <====---- #

actor="nao_eof1_mon"

var="psl" 		# Variable name for the actor
lon_min="270"		# Minimum longitude
lon_max="40"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="70"		# Maximum latitude


in_file="${uz_in_file}"

out_filename="${actor}_${model}_${tmean}.nc"
out_stdname="${actor}_${model}_${tmean}_ymonstd.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"
out_std="${out_dir}/${out_stdname}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [[ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi


#select lat, lon
# cdo -r sellevel,${plev} ${in_file} ${out_tempfile}_1000.nc
ncea -d lat,${lat_min}.0,${lat_max}.0 -d lon,${lon_min}.0,${lon_max}.0 ${in_file} ${out_tempfile}_NAtl.nc
# calculate anomalies, remove seasonal cycle
# Test for generic grid, if true then use selgrid to only select latlon grid and ignore generic grid
cdo ymonsub ${out_tempfile}_NAtl.nc -ymonavg ${out_tempfile}_NAtl.nc ${out_tempfile}_anom.nc

#begin EOF calculation
NEOF=2
# 1) Get file ready (set missing values to zero, if any)
cdo setmisstoc,0 ${out_tempfile}_anom.nc ${out_tempfile}_nomissval.nc

# 2) Compute EOFs and PCs:
echo "Compute EOFs and PCs"
export CDO_WEIGHT_MODE=on
cdo -b 64 eof,$NEOF ${out_tempfile}_nomissval.nc ${out_tempfile}_eigenval_weighted.nc  ${out_tempfile}_eof_weighted.nc
echo "Compute eofceoff"
cdo -b 64 eofcoeff ${out_tempfile}_eof_weighted.nc ${out_tempfile}_nomissval.nc ${out_tempfile}_pc_weighted_

# 3) Compute explained variance:
echo "Compute explained variance"
cdo -div ${out_tempfile}_eigenval_weighted.nc -timsum ${out_tempfile}_eigenval_weighted.nc ${out_tempfile}_explvar_weighted.nc

for ((i=1; i<=$NEOF-1; ++i)) ; do
  cdo -seltimestep,${i} ${out_tempfile}_explvar_weighted.nc ${out_tempfile}_explvar_some.nc
  MODE=`cdo output -mulc,100 ${out_tempfile}_explvar_some.nc | sed  "s- --g"`
  echo "EOF MODE ${i}: $MODE"
done

#rm files no longer used
rm ${out_tempfile}_explvar_some.nc ${out_tempfile}_nomissval.nc ${out_tempfile}_pc_weighted_00001.nc

# Select first EOF only (timestep should be = 1 for next part to work properly)
cdo seltimestep,1 ${out_tempfile}_eof_weighted.nc ${out_file}

# Calculate monthly std to be used to daily calc
cdo mul ${out_file} ${out_tempfile}_anom.nc proj1_mon.nc
cdo -chname,${var},nao -fldmean proj1_mon.nc nao_nostd_mon.nc
cdo ymonstd nao_nostd_mon.nc ${out_std} # to be used for daily index too

rm ${out_tempfile}_*
echo " "
echo "================================"
echo " "
echo "Finished AO patterm for ${group} "





