#!/bin/bash

# set -xe

##############################################
# Extract timeseries of actors from QBOi data
# 
# 
# Use nc2csv.py to convert nc files to csv files
nc2csv=/group_workspaces/jasmin2/gotham/cen_qboi/scripts/nc2csv.py

group="CAM" 	# Group name
model=""	# Model name - use blank string "" if no model name

exp="Exp1"	# Experiment number, (1 or 2)
tmean="mon" 	# Time mean, i.e. day, mon
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
# years="000101-003112" # Exp1: 197901-200912 Exp2: 000101-003112

# example: /group_workspaces/jasmin2/qboi/CAM/QBOiExp1/mon/atmos/r1i1p1
model_dir="/group_workspaces/jasmin2/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos/${real}"
out_dir="/group_workspaces/jasmin2/gotham/cen_qboi/${exp}/${group}${model}"
model_filename="CAM_QBOi${exp}_${real}.nc"

mkdir -p ${out_dir} 	# creates output dir, -p ignores error if dir already exists

echo "Model directory: ${model_dir}"
echo "Out directory: ${out_dir}"
echo " "
echo " "

# ----====> QBO <====---- #

actor="QBO"
var="ua" 	# Variable name for the actor

plev="20"	# pressure level
lat_min="-5.0"	# Mininum latitude
lat_max="5.0"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

# Note: for zonal mean netcdf files need to use nco to select lats, then use cdo
#	(am I going crazy? Is there really no way to select just lats, not
#	lons for a zonal mean file with CDO?? I couldn't find any - nt

nces -d lat,${lat_min},${lat_max} ${in_file} ${out_tempfile}
cdo -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_tempfile}
echo " "
echo " "

# ----====> BK-SIC <====---- #

actor="BK-SIC"
var="tas" 	# Variable name for the actor

lon_min="30"	# Minimum longitude
lon_max="105"	# Maximum longitude
lat_min="70"	# Mininum latitude
lat_max="80"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "

# ----====> EA-Snow <====---- #

actor="EA-Snow"
var="tas" 	# Variable name for the actor

lon_min="30"	# Minimum longitude
lon_max="180"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="70"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "


# ----====> AO <====---- #

actor="AO"
var="zg" 	# Variable name for the actor

plev="1000"	# pressure level
lon_min="0"	# Minimum longitude
lon_max="360"	# Maximum longitude
lat_min="20"	# Mininum latitude
lat_max="90"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"


cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} -sellevel,${plev} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "

# ----====> v_flux <====---- #

actor="v_flux"
var="fz" 	# Variable name for the actor

plev="100"	# pressure level 
lat_min="45.0"	# Mininum latitude
lat_max="75.0"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_Z${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_tempfile="${out_dir}/tempfile.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

# Note: for zonal mean netcdf files need to use nco to select lats, then use cdo
#	(am I going crazy? Is there really no way to select just lats, not
#	lons for a zonal mean file with CDO?? I couldn't find any - nt

nces -d lat,${lat_min},${lat_max} ${in_file} ${out_tempfile}
cdo -r fldmean -sellevel,${plev} ${out_tempfile} ${out_file}
$nc2csv ${out_file}
rm ${out_tempfile}
echo " "
echo " "

# ----====> PoV <====---- #

actor="PoV"
var="zg" 	# Variable name for the actor

plev="100,85,70,60,50,40,30,20,15,10"	# pressure level 
lon_min="0"	# Minimum longitude
lon_max="360"	# Maximum longitude
lat_min="65"	# Mininum latitude
lat_max="90"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	# Note the Z for zonal variables
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"


cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} -vertmean -sellevel,${plev} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "


# ----====> Sib-SLP <====---- #

actor="Sib-SLP"
var="psl" 	# Variable name for the actor

lon_min="85"	# Minimum longitude
lon_max="120"	# Maximum longitude
lat_min="40"	# Mininum latitude
lat_max="65"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "


# ----====> Ural-SLP <====---- #

actor="Ural-SLP"
var="psl" 	# Variable name for the actor

lon_min="40"	# Minimum longitude
lon_max="85"	# Maximum longitude
lat_min="45"	# Mininum latitude
lat_max="70"	# Maximum latitude

actor_dir="${model_dir}"
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"

cdo -r fldmean -sellonlatbox,${lon_min},${lon_max},${lat_min},${lon_max} ${in_file} ${out_file}
$nc2csv ${out_file}
echo " "
echo " "
echo "Finished actors timeseries for ${group}${model} "




#for filenc in ${era_dir}/era-interim_an_pl_6hr_*_u.nc4 ; do
#    cdo  -r fldmean -sellonlatbox,0,360,60,90 -sellevidx,14 -monmean "$filenc" "${out_dir}/$(basename $filenc)"
#    echo "${out_dir}/$(basename $filenc)"
#done

#cdo mergetime ${out_dir}/erai_*nc4 erai_pov.nc

