#!/bin/bash

set -e

##############################################
# Calculate the 1st EOF for NH z1000, to be used for AO calculation
# Usage:
# $ ao_pattern_mon.sh --group=$group --model=$model --exp=$exp --tmean=$tmean --real=$real --punits=$punits --years=$years --model_dir=$model_dir --model_filename=$model_filename
# 
# nicholas tyrrell 2018
# 


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
out_dir="/gws/nopw/j04/gotham/cen_qboi/${exp}/${group}${model}"
mkdir -p ${out_dir} 	# creates output dir, -p ignores error if dir already exists

echo "Model directory: ${model_dir}"
echo "Model file name is ${model_filename}"
echo "Out directory: ${out_dir}"
echo " "
echo "================================"
echo " "
#=========================================

# ----====> EOF1 for AO <====---- #

actor="eof1_mon"

var="zg" 		# Variable name for the actor
plev="1000${punits}"	# pressure level with unit adjustment
lon_min="0"		# Minimum longitude
lon_max="360"		# Maximum longitude
lat_min="20"		# Mininum latitude
lat_max="90"		# Maximum latitude

if "$make_actor_dir" ; then
	actor_dir="${model_dir}/${var}/${real}"
fi
in_filename="${var}_${model_filename}" 	
in_file="${actor_dir}/${in_filename}"

out_filename="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}.nc"
out_stdname="${actor}_${group}${model}_QBOi${exp}_${real}_${tmean}_ymonstd.nc"
out_tempfile="${out_dir}/tempfile"
out_file="${out_dir}/${out_filename}"
out_std="${out_dir}/${out_stdname}"

echo "Create ${actor} timeseries"
echo "Input file: ${in_file}"
echo "Output file: ${out_file}"
if [[ `ls -1 ${in_file} 2>/dev/null | wc -l ` -lt 1 ]]; then
	echo "FILE NOT FOUND:"
	echo "${in_file}"
	exit 1
fi
if [[ "$merge_time" ]]; then
	merge_file="${out_dir}/merge_file.nc"
	cdo mergetime ${in_file} ${merge_file}
	in_file=${merge_file}
fi

#select lat, lon, plev
cdo -r sellevel,${plev} ${in_file} ${out_tempfile}_1000.nc
ncea -d lat,${lat_min}.0,${lat_max}.0 -d lon,${lon_min}.0,${lon_max}.0 ${out_tempfile}_1000.nc ${out_tempfile}_NH1000.nc
# calculate anomalies, remove seasonal cycle
cdo ymonsub ${out_tempfile}_NH1000.nc -ymonavg ${out_tempfile}_NH1000.nc ${out_tempfile}_anom.nc

#begin EOF calculation
NEOF=2
# 1) Get file ready (set missing values to zero, if any)
cdo setmisstoc,0 ${out_tempfile}_anom.nc ${out_tempfile}_nomissval.nc

# 2) Compute EOFs and PCs:
echo "Compute EOFs and PCs"
export CDO_WEIGHT_MODE=on
cdo -b 64 eof,$NEOF ${out_tempfile}_nomissval.nc ${out_tempfile}_eigenval_weighted.nc  ${out_tempfile}_eof_weighted.nc
cdo -b 64 eofcoeff ${out_tempfile}_eof_weighted.nc ${out_tempfile}_nomissval.nc ${out_tempfile}_pc_weighted_

# 3) Compute explained variance:
echo "Compute explained variance"
cdo -div ${out_tempfile}_eigenval_weighted.nc -timsum ${out_tempfile}_eigenval_weighted.nc ${out_tempfile}_explvar_weighted.nc

for ((i=1; i<=$NEOF-1; ++i)) ; do
  cdo -seltimestep,${i} ${out_tempfile}_explvar_weighted.nc ${out_tempfile}_explvar_some.nc
  MODE=`cdo output -mulc,100 ${out_tempfile}_explvar_some.nc | sed  "s- --g"`
  echo "EOF MODE ${i}: $MODE"
done

#rm files no longer used
rm ${out_tempfile}_explvar_some.nc ${out_tempfile}_nomissval.nc ${out_tempfile}_pc_weighted_00001.nc

# Select first EOF only (timestep should be = 1 for next part to work properly)
cdo seltimestep,1 ${out_tempfile}_eof_weighted.nc ${out_file}

# Calculate monthly std to be used to daily calc
cdo mul ${out_file} ${out_tempfile}_anom.nc proj1_mon.nc
cdo -chname,${var},ao -fldmean proj1_mon.nc ao_nostd_mon.nc
cdo ymonstd ao_nostd_mon.nc ${out_std} # to be used for daily index too

rm -f ${merge_file}
rm ${out_tempfile}_*
echo " "
echo "================================"
echo " "
echo "Finished AO patterm for ${group}${model} "





