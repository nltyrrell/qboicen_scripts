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
nc2csv=/gws/nopw/j04/gotham/cen_qboi/scripts/nc2csv.py
# Use own version of cdo, v 1.9.6
CDO=/home/users/tyrrell/miniconda3/bin/cdo

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
		--mirocapsl_merge_time=*)
		  mirocapsl_merge_time="${1#*=}"
		  ;;
		--qbo_plev=*)
		  qbo_plev="${1#*=}"
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

# fill in empty arguments
if [ -z "${make_actor_dir}" ]; then
	make_actor_dir="false"
fi
if [ -z "${merge_time}" ]; then
	merge_time="false"
fi
if [ -z "${mirocapsl_merge_time}" ]; then
	mirocapsl_merge_time="false"
fi

#=========================================
# ----====> EA-tas <====---- #

actor="NINO34"
var="tas" 	# Variable name for the actor

lon_min="190"	# Minimum longitude
lon_max="240"	# Maximum longitude
lat_min="-5"	# Mininum latitude
lat_max="5"	# Maximum latitude

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
if $merge_time  ; then
	echo "MERGETIME TRUE"
	merge_file="${out_dir}/merge_file.nc"
	rm -f "${out_dir}/merge_file.nc"
	$CDO mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}


$nc2csv ${out_file}
rm -f ${merge_file}
echo " "
echo "================================"
echo " "

# # ----====> u60 <====---- #
# 
# actor="u60"
# 
# var="ua" 		# Variable name for the actor
# plev="10${punits}"	# pressure in hPa level with unit adjustment
# lon_min="0"		# Minimum longitude
# lon_max="0"		# Maximum longitude
# lat_min="55.0"		# Mininum latitude
# lat_max="65.0"		# Maximum latitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# out_tempfile="${out_dir}/tempfile.nc"
# out_file="${out_dir}/${out_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "Output file: ${out_file}"
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# 
# if $merge_time; then
# 	echo "MERGETIME TRUE"
# 	merge_file="${out_dir}/merge_file.nc"
# 	rm -f "${out_dir}/merge_file.nc"
# 	echo "Merge files: ${in_file}"
# 	echo "into merge file ${merge_file}"
# 	$CDO mergetime ${in_file} ${merge_file}
# 	in_file=${merge_file}
# fi
# 
# $CDO enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
# $CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
# $nc2csv ${out_file}
# rm -f ${merge_file}
# rm -f ${out_tempfile}
# echo " "
# echo "================================"
# echo " "
# 
# 
# # ----====> EA-tas <====---- #
# 
# actor="EA-tas"
# var="tas" 	# Variable name for the actor
# 
# lon_min="30"	# Minimum longitude
# lon_max="180"	# Maximum longitude
# lat_min="40"	# Mininum latitude
# lat_max="70"	# Maximum latitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_${model_filename}" 	
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# out_file="${out_dir}/${out_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "Output file: ${out_file}"
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# if $merge_time  ; then
# 	echo "MERGETIME TRUE"
# 	merge_file="${out_dir}/merge_file.nc"
# 	rm -f "${out_dir}/merge_file.nc"
# 	$CDO mergetime ${in_file} ${merge_file}
# 	in_file=${merge_file}
# fi
# 
# $CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}
# 
# 
# $nc2csv ${out_file}
# rm -f ${merge_file}
# echo " "
# echo "================================"
# echo " "
# 
# 
# #=========================================
# 
# # ----====> NAO <====---- #
# 
# actor="NAO"
# 
# var="psl" 		# Variable name for the actor
# lon_min="270"		# Minimum longitude
# lon_max="40"		# Maximum longitude
# lat_min="20"		# Mininum latitude
# lat_max="70"		# Maximum latitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_${model_filename}" 	
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# ineof_filename="nao_eof1_mon_${group}${model}_QBOi${exp}_${real}_mon.nc"
# ineofstd_filename="nao_eof1_mon_${group}${model}_QBOi${exp}_${real}_mon_ymonstd.nc"
# # Note: monthly NAO pattern used for mon and day NAO
# out_tempfile="${out_dir}/tempfile"
# out_file="${out_dir}/${out_filename}"
# ineof_file="${out_dir}/${ineof_filename}"
# ineofstd_file="${out_dir}/${ineofstd_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "EOF input file: ${ineof_file}"
# echo "EOF ystdmon input file: ${ineofstd_file}"
# echo "Output file: ${out_file}"
# if [[ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# if [[ `ls -1 ${ineof_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
# 	echo "MONTHLY EOF PATTERN FILE NOT FOUND:"
# 	echo "MUST RUN run_nao_pattern.sh FIRST"
# 	exit 1
# fi
# 
# if $merge_time ; then
# 	echo "MERGETIME TRUE"
# 	if $mirocapsl_merge_time ; then
# 		echo "MIROC-A merge"
# 		if [[ $tmean == "day" ]]; then
# 			echo "DAY merge"
# 			rm -f "${out_dir}/merge_file?.nc"
# 			merge_file1="${out_dir}/merge_file1.nc"
# 			merge_file2="${out_dir}/merge_file2.nc"
# 			merge_file="${out_dir}/merge_file0.nc"
# 			$CDO -O mulc,0.01 -mergetime ${in_file}{198001,198101}* ${merge_file1}
# 			$CDO -O delete,year=1980,1981 -mergetime ${in_file} ${merge_file2}
# 			$CDO -O mergetime ${merge_file1} ${merge_file2} ${merge_file}
# 			in_file=${merge_file}
# 		fi
# 		if [[ $tmean == "mon" ]]; then
# 			echo "MON merge"
# 			rm -f "${out_dir}/merge_file?.nc"
# 			merge_file1="${out_dir}/merge_file1.nc"
# 			merge_file2="${out_dir}/merge_file2.nc"
# 			merge_file3="${out_dir}/merge_file3.nc"
# 			merge_file="${out_dir}/merge_file0.nc"
# 			$CDO -O mulc,0.00000001 -mergetime ${in_file}197901* ${merge_file1}
# 			$CDO -O mulc,0.01 -mergetime ${in_file}{198001,198101}* ${merge_file2}
# 			$CDO -O delete,year=1979,1980,1981 -mergetime ${in_file} ${merge_file3}
# 			$CDO -O mergetime ${merge_file1} ${merge_file2} ${merge_file3} ${merge_file}
# 			in_file=${merge_file}
# 		fi
# 	else
# 		echo "mergetime, not MIROC-A"
# 		merge_file="${out_dir}/merge_file.nc"
# 		rm -f "${out_dir}/merge_file.nc"
# 		$CDO mergetime ${in_file} ${merge_file}
# 		in_file=${merge_file}
# 	fi
# fi
# 
# #--------------------- Compute NAO indices ---------------------#
# # Notes:
# #	- To get the NAO indices, we project the monthly and daily slp [20-70N, X-XX] onto the leading monthly EOF mode
# #	- Both (monthly and daily) indices are standardised by the MONTHLY std
# #	- **The lenght on the indices depends on the lenght of the z1000 anomalies used (in here periods longer than 1979-2000 can be input)
# 
# #select lat, lon, plev
# #$CDO -r sellevel,${plev} ${in_file} ${out_tempfile}_1000.nc
# ncea -O -d lat,${lat_min}.0,${lat_max}.0 -d lon,${lon_min}.0,${lon_max}.0 ${in_file} ${out_tempfile}_NAtl.nc
# if [[ $($CDO sinfo ${out_tempfile}_NAtl.nc 2> /dev/null | grep generic) ]]
# then
# 	ncks -O -x -v date ${out_tempfile}_NAtl.nc ${out_tempfile}_NAtl.nc
# echo "Remove date variable"
# fi
# 
# # calculate anomalies, remove seasonal cycle
# $CDO ymonsub ${out_tempfile}_NAtl.nc -ymonavg ${out_tempfile}_NAtl.nc ${out_tempfile}_anom.nc
# 
# $CDO mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_mon.nc
# $CDO -chname,${var},nao -fldmean ${out_tempfile}_proj1_mon.nc ${out_tempfile}_nao_nostd_mon.nc
# # $CDO ymonstd ${out_tempfile}_nao_nostd_mon.nc ${out_tempfile}_nao_ymonstd_mon.nc # to be used for daily index too
# 
# if [[ ${tmean} == "mon" ]]
# then
# 	echo "Monthly tmean NOA calulation"
# 	# --- Monthly:
# 	$CDO -O div ${out_tempfile}_nao_nostd_mon.nc ${ineofstd_file} ${out_file}
# 	rm -f ${out_tempfile}_* # remove some files after having a quick look at them
# 
# elif [[ ${tmean} == "day" ]]
# then
# 	echo "Daily tmean NAO calculation"
# 
# 	# --- Daily:
# 	$CDO mul ${ineof_file} ${out_tempfile}_anom.nc ${out_tempfile}_proj1_day.nc
# 	$CDO -chname,${var},nao -fldmean ${out_tempfile}_proj1_day.nc ${out_tempfile}_nao_nostd_day.nc
# 	# Use monthy std for daily index too. As monthly std has 12 values only, we need t    o use the loop below to make sure we divide the 31 days from January by the respec    tive January mon std and so on for the other months:
# 
# 	MON=1
# 	while [ $MON -le 12 ] ;do
# 		cdo -selmon,$MON ${out_tempfile}_nao_nostd_day.nc ${out_tempfile}f1_$MON.nc
# 		cdo selmon,$MON ${ineofstd_file} ${out_tempfile}f2_$MON.nc
# 		cdo div ${out_tempfile}f1_$MON.nc ${out_tempfile}f2_$MON.nc ${out_tempfile}nao_m$MON.nc
# 		let MON=MON+1
# 	done
# 
# 	cdo -O mergetime ${out_tempfile}nao_m*.nc ${out_file}
# 
# 	rm ${out_tempfile}* # remove some files after having a quick look at t    hem
# 
# else 
# 	echo "no NAO calculation"
# fi
# 
# 
# $nc2csv ${out_file}
# rm -f "${out_dir}/merge_file*.nc"
# echo " "
# echo "================================"
# echo " "
# 
# # ----====> v_flux <====---- #
# 
# actor="v_flux"
# 
# var="fz" 		# Variable name for the actor
# plev="100${punits}"	# pressure level with unit adjustment
# lon_min="0"		# Minimum longitude
# lon_max="0"		# Maximum longitude
# lat_min="45.0"		# Mininum latitude
# lat_max="75.0"		# Maximum latitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# out_tempfile="${out_dir}/tempfile.nc"
# out_file="${out_dir}/${out_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "Output file: ${out_file}"
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
# 	in_file="${actor_dir}/${in_filename}"
# 	echo "FZ FILE NOT ZONAL, NEW FZ FILE:"
# 	echo "${in_file}"
# fi
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# if  $merge_time  ; then
# 	echo "MERGETIME TRUE"
# 	merge_file="${out_dir}/merge_file.nc"
# 	rm -f "${out_dir}/merge_file.nc"
# 	$CDO mergetime ${in_file} ${merge_file}
# 	in_file=${merge_file}
# fi
# 
# $CDO -b 64 enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
# $CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -sellevel,${plev} ${out_tempfile} ${out_file}
# $nc2csv ${out_file}
# rm -f ${merge_file}
# rm -f ${out_tempfile}
# echo " "
# echo "================================"
# echo " "
# 
# # ----====> PoV <====---- #
# 
# actor="PoV"
# 
# var="zg" 	# Variable name for the actor
# plev="100${punits},85${punits},70${punits},60${punits},50${punits},40${punits},30${punits},20${punits},15${punits},10${punits}" # pressure level with unit adjustment
# lon_min="0"	# Minimum longitude
# lon_max="0"	# Maximum longitude
# lat_min="65"	# Mininum latitude
# lat_max="90"	# Maximum latitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# out_tempfile="${out_dir}/tempfile.nc"
# out_file="${out_dir}/${out_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "Output file: ${out_file}"
# 
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# if  $merge_time  ; then
# 	echo "MERGETIME TRUE"
# 	merge_file="${out_dir}/merge_file.nc"
# 	rm -f "${out_dir}/merge_file.nc"
# 	$CDO mergetime ${in_file} ${merge_file}
# 	in_file=${merge_file}
# fi
# 
# $CDO enlarge,r1x${lat_size} ${in_file} ${out_tempfile}
# $CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${out_tempfile} ${out_file}
# #$CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} -vertmean -sellevel,${plev} ${in_file} ${out_file}
# $nc2csv ${out_file}
# rm -f ${merge_file}
# rm -f ${out_tempfile}
# echo " "
# echo "================================"
# echo " "
# 
# 
# # ----====> Sib-SLP <====---- #
# 
# actor="Sib-SLP"
# var="psl" 	# Variable name for the actor
# 
# lat_min="40"	# Mininum latitude
# lat_max="65"	# Maximum latitude
# lon_min="85"	# Minimum longitude
# lon_max="120"	# Maximum longitude
# 
# if "$make_actor_dir" ; then
# 	actor_dir="${model_dir}/${var}/${real}"
# fi
# in_filename="${var}_${model_filename}" 	
# in_file="${actor_dir}/${in_filename}"
# 
# out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
# out_file="${out_dir}/${out_filename}"
# 
# echo "Create ${actor} timeseries"
# echo "Input file: ${in_file}"
# echo "Output file: ${out_file}"
# if [ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]; then
# 	echo "FILE NOT FOUND:"
# 	echo "${in_file}"
# 	exit 1
# fi
# # The following is required because the MIROC-A psl 
# # has the wrong units for 1979 (monthly data 10^8), 
# # 1980, 1981 (daily and monthly, 10^2)
# if $merge_time ; then
# 	echo "MERGETIME TRUE"
# 	if $mirocapsl_merge_time ; then
# 		echo "MIROC-A merge"
# 		if [[ $tmean == "day" ]]; then
# 			echo "DAY merge"
# 			rm -f "${out_dir}/merge_file?.nc"
# 			merge_file1="${out_dir}/merge_file1.nc"
# 			merge_file2="${out_dir}/merge_file2.nc"
# 			merge_file="${out_dir}/merge_file0.nc"
# 			$CDO -O mulc,0.01 -mergetime ${in_file}{198001,198101}* ${merge_file1}
# 			$CDO -O delete,year=1980,1981 -mergetime ${in_file} ${merge_file2}
# 			$CDO -O mergetime ${merge_file1} ${merge_file2} ${merge_file}
# 			in_file=${merge_file}
# 		fi
# 		if [[ $tmean == "mon" ]]; then
# 			echo "MON merge"
# 			rm -f "${out_dir}/merge_file?.nc"
# 			merge_file1="${out_dir}/merge_file1.nc"
# 			merge_file2="${out_dir}/merge_file2.nc"
# 			merge_file3="${out_dir}/merge_file3.nc"
# 			merge_file="${out_dir}/merge_file0.nc"
# 			$CDO -O mulc,0.00000001 -mergetime ${in_file}197901* ${merge_file1}
# 			$CDO -O mulc,0.01 -mergetime ${in_file}{198001,198101}* ${merge_file2}
# 			$CDO -O delete,year=1979,1980,1981 -mergetime ${in_file} ${merge_file3}
# 			$CDO -O mergetime ${merge_file1} ${merge_file2} ${merge_file3} ${merge_file}
# 			in_file=${merge_file}
# 		fi
# 	else
# 		echo "mergetime, not MIROC-A"
# 		merge_file="${out_dir}/merge_file.nc"
# 		rm -f "${out_dir}/merge_file.nc"
# 		$CDO mergetime ${in_file} ${merge_file}
# 		in_file=${merge_file}
# 	fi
# fi
# 
# $CDO -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lat_max} ${in_file} ${out_file}
# $nc2csv ${out_file}
# rm -f ${merge_file}
# echo " "
# echo "================================"
# echo " "
# 





