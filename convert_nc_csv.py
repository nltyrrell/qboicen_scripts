 #!~/my_python/bin/python2.7
"""
Convert netcdf timeseries to csv files so they can be 
read easily by pandas

NOTE: current versions of cdo_{model}.sh converts the nc output to csv
so this script is not necessary nt 05/2018

nt 01/2018
"""

import sys
import os
import numpy as np
import netCDF4
import pandas as pd

#/group_workspaces/jasmin2/gotham/cen_qboi/Exp1/CCCmaCMAM/QBO_CCCmaCMAM_QBOiExp1_r1i1p1_mon_197901-200912.nc

exp = "Exp1"
actors = ["AO","BK-SIC","EA-Snow","PoV","QBO","Sib-SLP","Ural-SLP","v_flux"]

# Uncomment and loop through these when for all models
# groups_models = ["CAM",
# 		"CCCmaCMAM",
# 		"ECMWFIFS43r1 ",
# 		"ISAC-CNRECHAM5sh ",
# 		"KIT-ASFEMAC ",
# 		"LMDzQBOI_1",
# 		"MIROCMIROC-AGCM",
# 		"MIROCMIROC-ESM",
# 		"MRIMRI-ESM2",
# 		"MOHCUMGA7",
# 		"YonseiHadGEM2-A",
# 		"YonseiHadGEM2-AC",
# 		"WACCM"]
# 
# for group_model in groups_models:

group_model = "CCCmaCMAM"

data_dir = "/group_workspaces/jasmin2/gotham/cen_qboi/{}/{}{}".format(exp,group_model)

for actor in actors:
	print("Actor: 		{}".format(actor))
	filename = "{}_{}{}_QBOi{}_r1i1p1_mon_197901-200912.nc".format(actor,group,model,exp)
	ncfile = "{}/{}".format(data_dir,filename)
	csvfile = "{}/{}.csv".format(data_dir,filename[:-3])

	nc_obj = netCDF4.Dataset(ncfile,mode='r')

	# get the variable. I'm sure whether the variable we want is always
	# the last one, print varname to check
	varname = nc_obj.variables.keys()[-1]
	var = nc_obj.variables[varname]
	vshape = var.shape
	print("Variable name: 	{}".format(varname))

	var = np.squeeze(var)	# remove excess dimensions

	#get the time variable, convert to dates
	timevar = nc_obj.variables['time']
	dtime = netCDF4.num2date(timevar[:],timevar.units)

	# Convert to pandas series and save as csv file
 	var_pd = pd.Series(var,index=dtime)
	var_pd.to_csv(csvfile)



