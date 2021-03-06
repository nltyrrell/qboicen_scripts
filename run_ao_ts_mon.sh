#!/bin/bash

set -e

# This script runs the CDO commands for all models, using ao_master.sh
# then combines all timeseries into one CSV file per model

#
#============
# Use ao_master.sh to get the timeseries for all models
# ao_master.sh.sh script is:
script_dir="/gws/nopw/j04/gotham/cen_qboi/scripts" 

#Global variables
exp="Exp1"
tmean="mon"
#============
#

#============
group="CAM" 	# Group name
model=""	# Model name - use blank string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="000101-003112" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos/"
model_filename="CAM_QBOi${exp}_${real}.nc"
actor_dir="${model_dir}/${real}"
make_actor_dir=false
lat_size="192"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""

#=========================================


#============
group="CCCma" 	# Group name
model="CMAM"	# Model name - use blank string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="48"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="ISAC-CNR" 	# Group name
model="ECHAM5sh"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_ECHAM5sh_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="96"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
# NOTE LMDz data in strange format, with multiple variables in files
# Need a seperate script to get them, not yet done nt 06/2018
# 
# group="LMDz" 	# Group name
# model=""	# Model name - use empty string "" if no model name
# real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
# punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
# years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
# model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
# model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
#=========================================


#============ 
group="MIROC" 	# Group name
model="MIROC-AGCM"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/${model}-LL/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-AGCM-LL_QBOi${exp}_${real}_*"
actor_dir=""
make_actor_dir=true
merge_time=true
lat_size="160"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="MIROC" 	# Group name
model="MIROC-ESM"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-ESM_QBOi${exp}_${real}_*"
actor_dir=""
make_actor_dir=true
merge_time=true
lat_size="64"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="MOHC" 	# Group name
model="UMGA7"	# Model name - use empty string "" if no model name
real="r2i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200902" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_UMGA7_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="145"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="MRI" 	# Group name
model="MRI-ESM2"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200912" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MRI-ESM2_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="160"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="WACCM" 	# Group name
model=""	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits=""	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-201401" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="WACCM_QBOi${exp}_${real}.nc"
actor_dir="${model_dir}/${real}"
make_actor_dir=false
lat_size="192"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="Yonsei" 	# Group name
model="HadGEM2-A"	# Model name - use empty string "" if no model name
real="r1i1p1"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200612" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_HadGEM2-A_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="145"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="Yonsei" 	# Group name
model="HadGEM2-AC"	# Model name - use empty string "" if no model name
real="r1i1p2"	# realisation number, r1i1p1, r2i1p1, r3i1p1
punits="00"	# Add "00" if pres levs in Pa, empty string if hPa
years="197901-200612" # Exp1: 197901-200912 Exp2: 000101-003112
model_dir="/group_workspaces/jasmin2/qboi_OLD/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_HadGEM2-AC_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
lat_size="145"

$script_dir/ao_master.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================

echo "everything finished"
echo "---===###===---"




