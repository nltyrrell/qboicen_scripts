#!/bin/bash

set -e

# This script runs the CDO commands for all models, using $cdo_master
# then combines all timeseries into one CSV file per model

#
#============
# Use $cdo_master to get the timeseries for all models
# Change to addts_master.sh to add new ts (without recalc all)
# $cdo_master.sh script is in:
script_dir="/gws/nopw/j04/gotham/cen_qboi/scripts" 
cdo_master="cdo_master.sh" #"addts_master.sh" #"cdo_master.sh"

#Global variables
exp="Exp1"
tmean="mon"
#============
#
#============
real="r1i1p1"
group="CAM"; model=""; 
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos/"
model_filename="CAM_QBOi${exp}_${real}.nc"; 
lat_size="192"; qbo_plev="20"; punits=""	
actor_dir="${model_dir}/${real}"
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

real="r2i1p1"
group="CAM"; model=""; 
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos/"
model_filename="CAM_QBOi${exp}_${real}.nc"; 
lat_size="192"; qbo_plev="20"; punits=""	
actor_dir="${model_dir}/${real}"
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

real="r3i1p1"
group="CAM"; model=""; 
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos/"
model_filename="CAM_QBOi${exp}_${real}.nc"; 
lat_size="192"; qbo_plev="20"; punits=""	
actor_dir="${model_dir}/${real}"
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""

#=========================================

#============
real="r1i1p1"	
group="CCCma"; 	model="CMAM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
years="197901-200912"
model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="48"; qbo_plev="7"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

real="r2i1p1"	
group="CCCma"; 	model="CMAM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
years="197901-200912"
model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="48"; qbo_plev="7"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

real="r3i1p1"	
group="CCCma"; 	model="CMAM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
years="197901-200912"
model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="48"; qbo_plev="7"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 
group="ISAC-CNR"; model="ECHAM5sh"
real="r1i1p1"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_ECHAM5sh_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="96"; qbo_plev="10"; punits="00"	

$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
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
# model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
# model_filename="A${tmean}_CMAM_QBOi${exp}_${real}_${years}.nc"
#=========================================


#============ 

real="r1i1p1"
group="MIROC"; model="MIROC-AGCM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/${model}-LL/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-AGCM-LL_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=true; merge_time=true
lat_size="160"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"

real="r2i1p1"
group="MIROC"; model="MIROC-AGCM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/${model}-LL/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-AGCM-LL_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=false; merge_time=true
lat_size="160"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r3i1p1"
group="MIROC"; model="MIROC-AGCM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/${model}-LL/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-AGCM-LL_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=false; merge_time=true
lat_size="160"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 

real="r1i1p1"
group="MIROC"; model="MIROC-ESM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-ESM_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=false; merge_time=true
lat_size="64"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r2i1p1"
group="MIROC"; model="MIROC-ESM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-ESM_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=false; merge_time=true
lat_size="64"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r3i1p1"
group="MIROC"; model="MIROC-ESM"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MIROC-ESM_QBOi${exp}_${real}_*"
actor_dir=""; make_actor_dir=true
mirocapsl_merge_time=false; merge_time=true
lat_size="64"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 

real="r2i1p1"
group="MOHC"; model="UMGA7"; years="197901-200902"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_UMGA7_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="145"; qbo_plev="10"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r3i1p1"
group="MOHC"; model="UMGA7"; years="197901-200902"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_UMGA7_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="145"; qbo_plev="10"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r4i1p1"
group="MOHC"; model="UMGA7"; years="197901-200902"
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_UMGA7_QBOi${exp}_${real}_${years}.nc"
actor_dir=""; make_actor_dir=true
lat_size="145"; qbo_plev="10"; punits="00"	
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --qbo_plev=$qbo_plev
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
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_MRI-ESM2_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
merge_time=false
mirocapsl_merge_time=false
lat_size="160"
qbo_plev="10"

$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================


#============ 

real="r1i1p1"
group="WACCM"; model=""
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="WACCM_QBOi${exp}_${real}.nc"
actor_dir="${model_dir}/${real}"
lat_size="192"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r2i1p1"
group="WACCM"; model=""
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="WACCM_QBOi${exp}_${real}.nc"
actor_dir="${model_dir}/${real}"
lat_size="192"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
real="r3i1p1"
group="WACCM"; model=""
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="WACCM_QBOi${exp}_${real}.nc"
actor_dir="${model_dir}/${real}"
lat_size="192"; qbo_plev="10"; punits=""
$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --qbo_plev=$qbo_plev
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
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_HadGEM2-A_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
merge_time=false
mirocapsl_merge_time=false
lat_size="145"
qbo_plev="15"

$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev

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
model_dir="/gws/nopw/j04/qboi/${group}/${model}/QBOi${exp}/${tmean}/atmos"
model_filename="A${tmean}_HadGEM2-AC_QBOi${exp}_${real}_${years}.nc"
actor_dir=""
make_actor_dir=true
merge_time=false
mirocapsl_merge_time=false
lat_size="145"
qbo_plev="10"

$script_dir/$cdo_master --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename --lat_size=$lat_size --actor_dir=$actor_dir --make_actor_dir=$make_actor_dir --merge_time=$merge_time --mirocapsl_merge_time=$mirocapsl_merge_time --qbo_plev=$qbo_plev

$script_dir/combine_actors.py "${group}${model}" "${exp}" "${real}" "${tmean}"
echo ""
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXnextmodelXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo ""
#=========================================

echo "everything finished"
echo "---===###===---"




