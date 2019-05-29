#!/usr/bin/python2.7

"""
Convert netcdf timeseries to csv files so they can be 
read easily by pandas
Usage: $ nc2csv.py infile.nc
Output: infile.csv

nicholas tyrrell 01/2018
"""

import sys
import os
import numpy as np
import netCDF4
import pandas as pd

# Get ncfile and dir from input
ncfile = sys.argv[1]

print("\n")
print("Running nc2csv with file: {}".format(ncfile))

# Remove .nc file end, replace with .csv
csvfile = "{}.csv".format(ncfile[:-3])

# Load nc file
nc_obj = netCDF4.Dataset(ncfile,mode='r')

# get the variable. I'm not sure whether the variable we want is always
# the last one, print varname to check
varname = nc_obj.variables.keys()[-1]
# Test we have a valid varname
if varname not in ['zg','tas','ua','psl','fz','nao']:
	varname = nc_obj.variables.keys()[-2]

var = nc_obj.variables[varname]
vshape = var.shape
print("Variable name: 	{}".format(varname))

var = np.squeeze(var)	# remove excess dimensions

#get the time variable, convert to dates
timevar = nc_obj.variables['time']
dtime = netCDF4.num2date(timevar[:],timevar.units,timevar.calendar)

# Convert to pandas series and save as csv file
var_pd = pd.Series(var,index=dtime)
var_pd.to_csv(csvfile)

print("nc2csv.py finished \n")

