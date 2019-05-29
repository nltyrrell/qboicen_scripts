#!/bin/bash

# set -xe

##############################################
# Extract timeseries of actors from QBOi data
# 
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/group_workspaces/jasmin2/gotham/cen_qboi/scripts/nc2csv.py

#============ CHANGE THESE ===============
group="MIROC" 	# Group name
model="MIROC-AGCM"	# Model name - use empty string "" if no model name
exp="Exp1"	# Experiment number, (1 or 2)
tmean="mon" 	# Time mean, i.e. day, mon
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi/${group}/${model}/${model}-LL/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-AGCM-LL_QBOi${exp}_${real}_*"
#=========================================

#========== DONT CHANGE THESE ============
out_dir="/group_workspaces/jasmin2/gotham/cen_qboi/${exp}/${group}${model}"
mkdir -p ${out_dir} 	# creates output dir, -p ignores error if dir already exists

echo "Model directory: ${model_dir}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

# ----====> QBO <====---- #

actor="QBO"

var="ua" 		# Variable name for the actor
plev="10${punits}"	# pressure level with unit adjustment
lat_min="-5.0"		# Mininum latitude
lat_max="5.0"		# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_mergetempfile="${out_dir}/mergetempfile.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

# Note: for zonal mean netcdf files need to use nco to select lats, then use cdo
#	(am I going crazy? Is there really no way to select just lats, not
#	lons for a zonal mean file with CDO?? I couldn't find any - nt

cdo mergetime  ${in_file} ${out_mergetempfile}
nces -d lat,${lat_min},${lat_max} ${out_mergetempfile} ${out_tempfile}
cdo -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
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

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "

# ----====> EA-Snow <====---- #

actor="EA-Snow"
var="tas" 	# Variable name for the actor

lon_min="30"	# Minimum longitude
lon_max="180"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="70"	# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "


# ----====> AO <====---- #

actor="AO"

var="zg" 		# Variable name for the actor
plev="1000${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="360"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="90"		# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"


cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} -sellevel,${plev} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "

# ----====> v_flux <====---- #

actor="v_flux"

var="fz" 		# Variable name for the actor
plev="100${punits}"	# pressure level with unit adjustment
lat_min="45.0"		# Mininum latitude
lat_max="75.0"		# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

# Note: for zonal mean netcdf files need to use nco to select lats, then use cdo
#	(am I going crazy? Is there really no way to select just lats, not
#	lons for a zonal mean file with CDO?? I couldn't find any - nt

cdo mergetime  ${in_file} ${out_mergetempfile}
nces -d lat,${lat_min},${lat_max} ${out_mergetempfile} ${out_tempfile}
cdo -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
rm ${out_tempfile}
echo " "
echo "================================"
echo " "

# ----====> PoV <====---- #

actor="PoV"

var="zg" 	# Variable name for the actor
plev="100${punits},85${punits},70${punits},60${punits},50${punits},40${punits},30${punits},20${punits},15${punits},10${punits}" # pressure level with unit adjustment
lon_min="0"	# Minimum longitude
lon_max="360"	# Maximum longitude
lat_min="65"	# Mininum latitude
lat_max="90"	# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"


cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} -vertmean -sellevel,${plev} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "


# ----====> Sib-SLP <====---- #

actor="Sib-SLP"
var="psl" 	# Variable name for the actor

lon_min="85"	# Minimum longitude
lon_max="120"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="65"	# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "


# ----====> Ural-SLP <====---- #

actor="Ural-SLP"
var="psl" 	# Variable name for the actor

lon_min="40"	# Minimum longitude
lon_max="85"	# Maximum longitude
lat_min="45"	# Mininum latitude
lat_max="70"	# Maximum latitude

actor_dir="${model_dir}/${var}/${real}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_mergetempfile="${out_dir}/mergetempfile.nc"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo mergetime  ${in_file} ${out_mergetempfile}
cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${out_mergetempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_mergetempfile}
echo " "
echo "================================"
echo " "
echo "Finished actors timeseries for ${group}${model} "




#for filenc in ${era_dir}/era-interim_an_pl_6hr_*_u.nc4 ; do
#    cdo  -r fldmean -sellonlatbox,0,360,60,90 -sellevidx,14 -monmean "$filenc" "${out_dir}/$(basename $filenc)"
#    echo "${out_dir}/$(basename $filenc)"
#done

#cdo mergetime ${out_dir}/erai_*nc4 erai_pov.nc

