#!/bin/bash

set -e

##############################################
# Extract timeseries of actors from ERAi data
# Usage:
# 
# nicholas tyrrell 2019
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/home/users/tyrrell/qboi/qboicen_scripts/nc2csv.py3
# Use own version of cdo, v 1.9.6
CDO=/lustre/tmp/tyrrell/miniconda3/bin/cdo

#============ Read in arguments from command line ===============

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
uz_in_file="${era_dir}/erai_uz_1979-2014_6l_${tmean}.nc"
psl_in_file="${era_dir}/erai_psl_1979-2014_${tmean}.nc"
if [ ${tmean} == "day" ]; then 
    t2m_in_file="/stornext/field/users/karpech/erai/t2m/erai_t2m_1979_2017_daily.nc"
fi
if [ ${tmean} == "mon" ]; then 
    t2m_in_file="${era_dir}/erai_t2m_1979-2014_${tmean}.nc"
fi
vt_in_file="${era_dir}/erai_vt_1979-2014_p100_${tmean}.nc"
gz_in_file="${era_dir}/erai_gz_1979-2014_NH_${tmean}.nc"

echo "Getting data from: ${model}"

#========================================

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================
# ----====> NINO34 <====---- #

actor="NINO34"
var="t2m" 	# Variable name for the actor

lon_min="190"	# Minimum longitude
lon_max="240"	# Maximum longitude
lat_min="-5"	# Mininum latitude
lat_max="5"	# Maximum latitude

in_file="${t2m_in_file}"
out_filename="${actor}_${model}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi

$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}

$nc2csv ${out_file}
echo " "
echo "================================"
echo " "


# ----====> u60 <====---- #

actor="u60"

var="ua" 		# Variable name for the actor
plev="10${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="0"		# Maximum longitude
lat_min="55.0"		# Mininum latitude
lat_max="65.0"		# Maximum latitude

in_file="${uz_in_file}"

out_filename="${actor}_${model}_${tmean}.nc"
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


$CDO enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "


echo "Finished actors timeseries for ${model} "





