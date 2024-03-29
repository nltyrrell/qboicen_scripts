#!/bin/bash

set -e

##############################################
# Extract timeseries of actors from ERAi data
# Usage:
# 
# nicholas tyrrell 2019
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/users/tyrrelln/scripts/qboicen_scripts/nc2csv.py3

# Use own version of cdo, v 1.9.6
# CDO=/lustre/tmp/tyrrell/miniconda3/bin/cdo
CDO=/users/tyrrelln/miniconda3/bin/cdo

#============ Read in arguments from command line ===============

model="erai"
tmean="day"
punits=""
lat_size="181"
qbo_plev="30"
model_dir=""
model_filename=""
out_dir="/fmi/scratch/project_2002421/era/erai/cen_data/"

# Define variable paths and names
era_dir="/fmi/scratch/project_2002421/era/erai/cen_data/"

if [ ${tmean} == "day" ]; then
     t2m_in_file="${era_dir}/erai_t2m_1979-2014_NH_${tmean}.nc"
fi
if [ ${tmean} == "mon" ]; then
     t2m_in_file="${era_dir}/erai_t2m_1979-2014_${tmean}.nc"
fi

uz_in_file="${era_dir}/erai_uz_1979-2014_6l_${tmean}.nc"
psl_in_file="${era_dir}/erai_psl_1979-2014_${tmean}.nc"
vt_in_file="${era_dir}/erai_vt_1979-2014_p100_${tmean}.nc"
gz_in_file="${era_dir}/erai_gz_1979-2014_NH_${tmean}.nc"

out_tempfile="${out_dir}/tempfile.nc"
rm -f ${out_tempfile}*

echo "Getting data from: ${model}"

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

var="u" 		# Variable name for the actor
plev="${qbo_plev}${punits}"	# pressure level with unit adjustment
lat_min="-5.0"		# Mininum latitude
lat_max="5.0"		# Maximum latitude

in_file="${uz_in_file}"

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


$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_sellev.nc
ncap2 -h -O -s "weights=cos(lat*3.1415/180)" ${out_tempfile}_sellev.nc ${out_tempfile}_wgt.nc
nces -d lat,${lat_min},${lat_max} ${out_tempfile}_wgt.nc ${out_tempfile}_area.nc
ncwa -h -O -w weights -a lat,lon ${out_tempfile}_area.nc ${out_file}
# $CDO -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm -f ${out_tempfile}*
echo " "
echo "================================"
echo " "

# ----====> QBO50 <====---- #

actor="QBO50"

var="u" 		# Variable name for the actor
plev="50${punits}"	# pressure level with unit adjustment
lat_min="-5.0"		# Mininum latitude
lat_max="5.0"		# Maximum latitude

in_file="${uz_in_file}"

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


$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_sellev.nc
ncap2 -h -O -s "weights=cos(lat*3.1415/180)" ${out_tempfile}_sellev.nc ${out_tempfile}_wgt.nc
nces -d lat,${lat_min},${lat_max} ${out_tempfile}_wgt.nc ${out_tempfile}_area.nc
ncwa -h -O -w weights -a lat,lon ${out_tempfile}_area.nc ${out_file}
# $CDO -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm -f ${out_tempfile}*
echo " "
echo "================================"
echo " "


# ----====> BK-SIC <====---- #

actor="BK-SIC"

var="t2m" 	# Variable name for the actor
lon_min="30.0"	# Minimum longitude
lon_max="105.0"	# Maximum longitude
lat_min="70.0"	# Mininum latitude
lat_max="80.0"	# Maximum latitude

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

lon_min="30.0"	# Minimum longitude
lon_max="180.0"	# Maximum longitude
lat_min="40.0"	# Mininum latitude
lat_max="70.0"	# Maximum latitude

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

actor="NAO"

evar="msl" 		# Variable name for the actor
var="psl" 		# Variable name for the actor
lon_min="270.0"		# Minimum longitude
lon_max="40.0"		# Maximum longitude
lat_min="20.0"		# Mininum latitude
lat_max="70.0"		# Maximum latitude

in_file="${psl_in_file}"

out_filename="${actor}_${model}_${tmean}.nc"
ineof_filename="nao_eof1_mon_${model}_mon.nc"
ineofstd_filename="nao_eof1_mon_${model}_mon_ymonstd.nc"
# Note: monthly NAO pattern used for mon and day NAO
out_tempfile="${out_dir}/tempfile"
out_file="${out_dir}/${out_filename}"
ineof_file="${out_dir}/${ineof_filename}"
ineofstd_file="${out_dir}/${ineofstd_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "EOF input file: ${ineof_file}"
echo "EOF ystdmon input file: ${ineofstd_file}"
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

#--------------------- Compute NAO indices ---------------------#
# Notes:
#	- To get the NAO indices, we project the monthly and daily slp [20-70N, X-XX] onto the leading monthly EOF mode
#	- Both (monthly and daily) indices are standardised by the MONTHLY std
#	- **The length on the indices depends on the lenght of the z1000 anomalies used (in here periods longer than 1979-2000 can be input)

#select lat, lon, plev
ncea -O -d latitude,${lat_min},${lat_max} -d longitude,${lon_min},${lon_max} ${in_file} ${out_tempfile}_NAtl.nc
if [[ $($CDO sinfo ${out_tempfile}_NAtl.nc 2> /dev/null | grep generic) ]]
then
	ncks -O -x -v date ${out_tempfile}_NAtl.nc ${out_tempfile}_NAtl.nc
echo "Remove date variable"
fi

# calculate anomalies, remove seasonal cycle
$CDO ymonsub ${out_tempfile}_NAtl.nc -ymonavg ${out_tempfile}_NAtl.nc ${out_tempfile}_anom.nc

$CDO mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_mon.nc
$CDO -chname,${evar},nao -fldmean ${out_tempfile}_proj1_mon.nc ${out_tempfile}_nao_nostd_mon.nc
# $CDO ymonstd ${out_tempfile}_nao_nostd_mon.nc ${out_tempfile}_nao_ymonstd_mon.nc # to be used for daily index too

if [[ ${tmean} == "mon" ]]
then
	echo "Monthly tmean NOA calulation"
	# --- Monthly:
	$CDO -O div ${out_tempfile}_nao_nostd_mon.nc ${ineofstd_file} ${out_file}
	rm -f ${out_tempfile}_* # remove some files after having a quick look at them

elif [[ ${tmean} == "day" ]]
then
	echo "Daily tmean NAO calculation"

	# --- Daily:
	$CDO mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_day.nc
	$CDO -chname,${evar},nao -fldmean ${out_tempfile}_proj1_day.nc ${out_tempfile}_nao_nostd_day.nc
	# Use monthy std for daily index too. As monthly std has 12 values only, we need t    o use the loop below to make sure we divide the 31 days from January by the respec    tive January mon std and so on for the other months:

	MON=1
	while [ $MON -le 12 ] ;do
		$CDO -selmon,$MON ${out_tempfile}_nao_nostd_day.nc ${out_tempfile}f1_$MON.nc
		$CDO selmon,$MON ${ineofstd_file} ${out_tempfile}f2_$MON.nc
		$CDO div ${out_tempfile}f1_$MON.nc ${out_tempfile}f2_$MON.nc ${out_tempfile}nao_m$MON.nc
		let MON=MON+1
	done

	$CDO -O mergetime ${out_tempfile}nao_m*.nc ${out_file}

	rm ${out_tempfile}* # remove some files after having a quick look at t    hem

else 
	echo "no NAO calculation"
fi

$nc2csv ${out_file}
echo " "
echo "================================"
echo " "

# ----====> v_flux <====---- #

actor="v_flux"

var="vt" 		# Variable name for the actor
plev="100${punits}"	# pressure level with unit adjustment
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

$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_sellev.nc
ncap2 -h -O -s "weights=cos(lat*3.1415/180)" ${out_tempfile}_sellev.nc ${out_tempfile}_wgt.nc
nces -d lat,${lat_min},${lat_max} ${out_tempfile}_wgt.nc ${out_tempfile}_area.nc
ncwa -h -O -w weights -a lat,lon ${out_tempfile}_area.nc ${out_file}
# $CDO -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm -f ${out_tempfile}*
echo " "
echo "================================"
echo " "

# ----====> PoV <====---- #

actor="PoV"

var="z" 	# Variable name for the actor
plev="100${punits},70${punits},50${punits},30${punits},20${punits},10${punits}" # pressure level with unit adjustment
lat_min="65.0"	# Mininum latitude
lat_max="90.0"	# Maximum latitude

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

$CDO -r vertmean -sellevel,${plev} ${in_file} ${out_tempfile}_sellev.nc
ncap2 -h -O -s "weights=cos(lat*3.1415/180)" ${out_tempfile}_sellev.nc ${out_tempfile}_wgt.nc
nces -d lat,${lat_min},${lat_max} ${out_tempfile}_wgt.nc ${out_tempfile}_area.nc
ncwa -h -O -w weights -a lat,lon ${out_tempfile}_area.nc ${out_file}
# $cdo -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm -f ${out_tempfile}*
echo " "
echo "================================"
echo " "

# ----====> Sib-SLP <====---- #

actor="Sib-SLP"
var="msl" 	# Variable name for the actor

lat_min="40.0"	# Mininum latitude
lat_max="65.0"	# Maximum latitude
lon_min="85.0"	# Minimum longitude
lon_max="120.0"	# Maximum longitude

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
var="msl" 	# Variable name for the actor

lat_min="40.0"	# Mininum latitude
lat_max="75.0"	# Maximum latitude
lon_min="40.0"	# Minimum longitude
lon_max="85.0"	# Maximum longitude

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

# ----====> NINO34 <====---- #

actor="NINO34"
var="t2m" 	# Variable name for the actor

lon_min="190.0"	# Minimum longitude
lon_max="240.0"	# Maximum longitude
lat_min="-5.0"	# Mininum latitude
lat_max="5.0"	# Maximum latitude

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
lat_min="55.0"		# Mininum latitude
lat_max="65.0"		# Maximum latitude

in_file="${uz_in_file}"

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


# $CDO enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_sellev.nc
ncap2 -h -O -s "weights=cos(lat*3.1415/180)" ${out_tempfile}_sellev.nc ${out_tempfile}_wgt.nc
nces -d lat,${lat_min},${lat_max} ${out_tempfile}_wgt.nc ${out_tempfile}_area.nc
ncwa -h -O -w weights -a lat,lon ${out_tempfile}_area.nc ${out_file}
# $CDO -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm -f ${merge_file}
rm -f ${out_tempfile}*
echo " "
echo "================================"
echo " "


echo "Finished actors timeseries for ${model} "





