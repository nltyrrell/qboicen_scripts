#!/bin/bash

set -e

# This script runs runs only the combine_actor script for the MIROC, since for some bloody reason the miroc zg data as two timesteps per day, so I've run cdo daymean on the nc file
# then combines all timeseries into one CSV file per model

#============
# Use ao_master.sh to get the timeseries for all models
# ao_master.sh.sh script is:
script_dir="/gws/nopw/j04/gotham/cen_qboi/scripts" 

#Global variables
exp="Exp1"
tmean="day"
#============

#============ 
group="MIROC" 	# Group name
model="MIROC-ESM"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="${tmean}_MIROC-ESM_QBOi${exp}_${real}_*"
actor_dir=""
make_actor_dir=true
merge_time=true
lat_size="64"

# $script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time

actor="AO"
out_dir="/gws/nopw/j04/gotham/cen_qboi/${exp}/${group}${model}"
out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_file="${out_dir}/${out_filename}"
nc2csv=/gws/nopw/j04/gotham/cen_qboi/scripts/nc2csv.py

$nc2csv ${out_file}

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================




