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
tmean="day"
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
t2m_in_file="${era_dir}/erai_t2m_1979-2014_NH_${tmean}.nc"
vt_in_file="${era_dir}/erai_vt_1979-2014_p100_${tmean}.nc"
gz_in_file="${era_dir}/erai_gz_1979-2014_NH_${tmean}.nc"

echo "Getting data from: ${group}"

#========================================

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

# ----====> QBO <====---- #

actor="QBO"

var="uz" 		# Variable name for the actor
plev="${qbo_plev}${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="0"		# Maximum longitude
lat_min="-5.0"		# Mininum latitude
lat_max="5.0"		# Maximum latitude

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

# ----====> BK-SIC <====---- #

actor="BK-SIC"

var="t2m" 	# Variable name for the actor
lon_min="30"	# Minimum longitude
lon_max="105"	# Maximum longitude
lat_min="70"	# Mininum latitude
lat_max="80"	# Maximum latitude

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

# ----====> EA-tas <====---- #

actor="EA-tas"
var="t2m" 	# Variable name for the actor

lon_min="30"	# Minimum longitude
lon_max="180"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="70"	# Maximum latitude

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


#=========================================

# ----====> NAO <====---- #

actor="NAO"

var="psl" 		# Variable name for the actor
lon_min="270"		# Minimum longitude
lon_max="40"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="70"		# Maximum latitude

in_file="${psl_in_file}"

out_filename="${actor}_${model}_${tmean}.nc"

ineof_filename="nao_eof1_mon_${model}_mon.nc"
# Note: monthly NAO pattern used for mon and day NAO
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

#select lat, lon, plev
#$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_1000.nc
ncea -O -d lat,${lat_min}.0,${lat_max}.0 -d lon,${lon_min}.0,${lon_max}.0 ${in_file} ${out_tempfile}_NAtl.nc
if [[ $($CDO sinfo ${out_tempfile}_NAtl.nc 2> /dev/null | grep generic) ]]
then
	ncks -O -x -v date ${out_tempfile}_NAtl.nc ${out_tempfile}_NAtl.nc
echo "Remove date variable"
fi

# calculate anomalies, remove seasonal cycle
$CDO ymonsub ${out_tempfile}_NAtl.nc -ymonavg ${out_tempfile}_NAtl.nc ${out_tempfile}_anom.nc


# --- Monthly:
$CDO mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_${tmean}.nc
$CDO -chname,${var},nao -fldmean ${out_tempfile}_proj1_${tmean}.nc ${out_tempfile}_nao_nostd_${tmean}.nc
$CDO y${tmean}std ${out_tempfile}_nao_nostd_${tmean}.nc ${out_tempfile}_nao_y${tmean}std_${tmean}.nc # to be used for daily index too
$CDO div ${out_tempfile}_nao_nostd_${tmean}.nc ${out_tempfile}_nao_y${tmean}std_${tmean}.nc ${out_file}
rm ${out_tempfile}_* # remove some files after having a quick look at them

$nc2csv ${out_file}
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

in_file="${vt_in_file}"
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

$CDO -b 64 enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
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

in_file="${gz_in_file}"
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

lat_size="71"
$CDO enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${out_tempfile} ${out_file}
#$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${in_file} ${out_file}
$nc2csv ${out_file}

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

in_file="${psl_in_file}"
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


# ----====> Ural-SLP <====---- #

actor="Ural-SLP"
var="psl" 	# Variable name for the actor

lat_min="40"	# Mininum latitude
lat_max="75"	# Maximum latitude
lon_min="40"	# Minimum longitude
lon_max="85"	# Maximum longitude

in_file="${psl_in_file}"
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
echo "Finished actors timeseries for ${model} "





