#!/bin/bash

set -e

##############################################
# Extract timeseries of actors from QBOi data
# Usage:
# $ cdo_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename
# 
# nicholas tyrrell 2018
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/group_workspaces/jasmin2/gotham/cen_qboi/scripts/nc2csv.py

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
out_dir="/group_workspaces/jasmin2/gotham/cen_qboi/${exp}/${group}${model}"
mkdir -p ${out_dir} 	# creates output dir, -p ignores error if dir already exists

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

# ----====> QBO <====---- #

actor="QBO"

var="ua" 		# Variable name for the actor
plev="7${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="0"		# Maximum longitude
lat_min="-5.0"		# Mininum latitude
lat_max="5.0"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi

if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "

# ----====> BK-SIC <====---- #

actor="BK-SIC"

var="tas" 	# Variable name for the actor
lon_min="30"	# Minimum longitude
lon_max="105"	# Maximum longitude
lat_min="70"	# Mininum latitude
lat_max="80"	# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}

$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "

# ----====> EA-tas <====---- #

actor="EA-tas"
var="tas" 	# Variable name for the actor

lon_min="30"	# Minimum longitude
lon_max="180"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="70"	# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}


$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "


# ----====> AO <====---- #

actor="AO"

var="zg" 		# Variable name for the actor
plev="1000${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="0"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="90"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
#cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${in_file} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "

# ----====> v_flux <====---- #

actor="v_flux"

var="fz" 		# Variable name for the actor
plev="100${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="0"		# Maximum longitude
lat_min="45.0"		# Mininum latitude
lat_max="75.0"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
	in_file="${actor_dir}/${in_filename}"
	echo "FZ FILE NOT ZONAL, NEW FZ FILE:"
	echo "${in_file}"
fi
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo -b 64 enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "

# ----====> PoV <====---- #

actor="PoV"

var="zg" 	# Variable name for the actor
plev="100${punits},85${punits},70${punits},60${punits},50${punits},40${punits},30${punits},20${punits},15${punits},10${punits}" # pressure level with unit adjustment
lon_min="0"	# Minimum longitude
lon_max="0"	# Maximum longitude
lat_min="65"	# Mininum latitude
lat_max="90"	# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${out_tempfile} ${out_file}
#cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${in_file} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "


# ----====> Sib-SLP <====---- #

actor="Sib-SLP"
var="psl" 	# Variable name for the actor

lat_min="40"	# Mininum latitude
lat_max="65"	# Maximum latitude
lon_min="85"	# Minimum longitude
lon_max="120"	# Maximum longitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "


# ----====> Ural-SLP <====---- #

actor="Ural-SLP"
var="psl" 	# Variable name for the actor

lat_min="40"	# Mininum latitude
lat_max="75"	# Maximum latitude
lon_min="40"	# Minimum longitude
lon_max="85"	# Maximum longitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if "$merge_time" ; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "
echo "Finished actors timeseries for ${group}${model} "





