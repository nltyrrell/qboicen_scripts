#!/bin/bash

set -e

# Note, this script is run from run_nao_ts_mon/day.sh
##############################################
# Extract timeseries of actors from QBOi data
# Usage:
# $ nao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename
# 
# nicholas tyrrell 2018
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/gws/nopw/j04/gotham/cen_qboi/scripts/nc2csv.py


#============ Read in arguments from command line ===============

while [ $# -gt 0 ]; do
	case "$1" in
		--group=*)
		  group="${1#*=}"
		  ;;
		--model=*)
		  model="${1#*=}"
		  ;;
		--exp=*)
		  exp="${1#*=}"
		  ;;
		--tmean=*)
		  tmean="${1#*=}"
		  ;;
		--real=*)
		  real="${1#*=}"
		  ;;
		--punits=*)
		  punits="${1#*=}"
		  ;;
		--years=*)
		  years="${1#*=}"
		  ;;
		--model_dir=*)
		  model_dir="${1#*=}"
		  ;;
		--model_filename=*)
		  model_filename="${1#*=}"
		  ;;
		--lat_size=*)
		  lat_size="${1#*=}"
		  ;;
		--actor_dir=*)
		  actor_dir="${1#*=}"
		  ;;
		--make_actor_dir=*)
		  make_actor_dir="${1#*=}"
		  ;;
		--merge_time=*)
		  merge_time="${1#*=}"
		  ;;
		*)
	esac
	shift
done

echo "Getting data from: ${group}"

#========================================

#========== DONT CHANGE THESE ============
out_dir="/gws/nopw/j04/gotham/cen_qboi/${exp}/${group}${model}"
mkdir -p ${out_dir} 	# creates output dir, -p ignores error if dir already exists

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

#=========================================

# ----====> NAO <====---- #

actor="NAO_simp"

var="psl" 		# Variable name for the actor
lon_min="270"		# Minimum longitude
lon_max="40"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="70"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
ineof_filename="nao_eof1_mon_${group}${model}_QBOi${exp}_${real}_mon.nc"
# Note: monthly eof used for both mon and daily NAO calculation
out_tempfile="${out_dir}/tempfile"
out_file="${out_dir}/${out_filename}"
ineof_file="${out_dir}/${ineof_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "EOF input file: ${ineof_file}"
echo "Output file: ${out_file}"
if [[ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if [[ `ls -1 ${ineof_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
	echo "MONTHLY EOF PATTERN FILE NOT FOUND:"
	echo "MUST RUN run_nao_pattern.sh FIRST"
	exit 1
fi
if [[ "$merge_time" ]]; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

#--------------------- Compute NAO indices ---------------------#
# Notes:
#	- To get the NAO indices, we project the monthly and daily psl anomalies [20-70N, 270-40] onto the leading monthly EOF mode
#	- Both (monthly and daily) indices are standardised by the MONTHLY std
#	- **The length on the indices depends on the length of the psl anomalies used (in here periods longer than 1979-2000 can be input)

#select lat, lon, plev
# calculate anomalies, remove seasonal cycle
cdo ymonsub ${in_file} -ymonavg ${in_file} ${out_tempfile}_anom.nc
# Normalize psl data
cdo -r ymondiv ${out_tempfile}_anom.nc -ymonstd ${out_tempfile}_anom.nc ${out_tempfile}_norm.nc
# Calculate NAO
cdo -r remapnn,lon=337/lat=65 ${out_tempfile}_norm.nc ${out_tempfile}_Iceland.nc
cdo -r remapnn,lon=334/lat=38 ${out_tempfile}_norm.nc ${out_tempfile}_Azores.nc
cdo sub ${out_tempfile}_Azores.nc ${out_tempfile}_Iceland.nc ${out_file}

rm ${out_tempfile}_* # remove some files after having a quick look at them

$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "




