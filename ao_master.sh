#!/bin/bash

set -e

# Note, this script is run from run_ao_ts.sh
##############################################
# Extract timeseries of actors from QBOi data
# Usage:
# $ ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename
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

# ----====> AO <====---- #

actor="AO"

var="zg" 		# Variable name for the actor
plev="1000${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="360"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="90"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
ineof_filename="eof1_mon_${group}${model}_QBOi${exp}_${real}_mon.nc"
# Note: monthly eof used for both mon and daily AO calculation
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
	echo "MUST RUN run_ao_pattern.sh FIRST"
	exit 1
fi
if [[ "$merge_time" ]]; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

#--------------------- Compute AO indices ---------------------#
# Notes:
#	- To get the AO indices, we project the monthly and daily height anomalies at 1000 hPa [20-90N, 0-360] onto the leading monthly EOF mode
#	- Both (monthly and daily) indices are standardised by the MONTHLY std
#	- **The lenght on the indices depends on the lenght of the z1000 anomalies used (in here periods longer than 1979-2000 can be input)

#select lat, lon, plev
cdo -r sellevel,${plev} ${in_file} ${out_tempfile}_1000.nc
ncea -d lat,${lat_min}.0,${lat_max}.0 -d lon,${lon_min}.0,${lon_max}.0 ${out_tempfile}_1000.nc ${out_tempfile}_NH1000.nc
# calculate anomalies, remove seasonal cycle
cdo ymonsub ${out_tempfile}_NH1000.nc -ymonavg ${out_tempfile}_NH1000.nc ${out_tempfile}_anom.nc


# --- Monthly:
cdo mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_mon.nc
cdo -chname,${var},ao -fldmean ${out_tempfile}_proj1_mon.nc ${out_tempfile}_ao_nostd_mon.nc
cdo ymonstd ${out_tempfile}_ao_nostd_mon.nc ${out_tempfile}_ao_ymonstd_mon.nc # to be used for daily index too
cdo div ${out_tempfile}_ao_nostd_mon.nc ${out_tempfile}_ao_ymonstd_mon.nc ${out_file}
rm ${out_tempfile}_* # remove some files after having a quick look at them

$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "




