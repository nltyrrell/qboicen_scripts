#!/usr/bin/python2.7
"""
Convert netcdf timeseries to a single file so they can be 
read easily by pandas, and stored easily
Usage: $ combine_actors.py model_name Exp_num Rel_num time_mean
example: $ combine_actors.py CAM Exp1 r1i1p1 mon
Output: model_actors.csv

nicholas tyrrell 04/2018
"""

import sys
import os
import numpy as np
import netCDF4
import pandas as pd

# Get ncfile and dir from input
model = sys.argv[1]
exp = sys.argv[2]
rel = sys.argv[3]
time = sys.argv[4]

main_dir = "/gws/nopw/j04/gotham/cen_qboi/{0}".format(exp)
model_dir = "{0}/{1}".format(main_dir,model)
model_fname = "{0}_QBOi{1}_{2}_{3}.csv".format(model,exp,rel,time)

print("\n")
print("Running combine_actors with files: {0}/*_{1}".format(model_dir,model_fname))

# Read in all the actor timeseries as pandas dataframes
NAO_infile = "{0}/{1}_{2}".format(model_dir,"NAO",model_fname)
NAO = pd.read_csv(NAO_infile,header=None, names=["date","NAO"])
BKsic_infile = "{0}/{1}_{2}".format(model_dir,"BK-SIC",model_fname)
BKsic = pd.read_csv(BKsic_infile,header=None, names=["date","BK-SIC"])
EAtas_infile = "{0}/{1}_{2}".format(model_dir,"EA-tas",model_fname)
EAtas = pd.read_csv(EAtas_infile,header=None, names=["date","EA-tas"])
PoV_infile = "{0}/{1}_{2}".format(model_dir,"PoV",model_fname)
PoV = pd.read_csv(PoV_infile,header=None, names=["date","PoV"])
QBO_infile = "{0}/{1}_{2}".format(model_dir,"QBO",model_fname)
QBO = pd.read_csv(QBO_infile,header=None, names=["date","QBO"])
NINO34_infile = "{0}/{1}_{2}".format(model_dir,"NINO34",model_fname)
NINO34 = pd.read_csv(NINO34_infile,header=None, names=["date","NINO34"])
SibSLP_infile = "{0}/{1}_{2}".format(model_dir,"Sib-SLP",model_fname)
SibSLP = pd.read_csv(SibSLP_infile,header=None, names=["date","Sib-SLP"])
UralSLP_infile = "{0}/{1}_{2}".format(model_dir,"Ural-SLP",model_fname)
UralSLP = pd.read_csv(UralSLP_infile,header=None, names=["date","Ural-SLP"])
v_flux_infile = "{0}/{1}_{2}".format(model_dir,"v_flux",model_fname)
v_flux = pd.read_csv(v_flux_infile,header=None, names=["date","v_flux"])
u60_infile = "{0}/{1}_{2}".format(model_dir,"u60",model_fname)
u60 = pd.read_csv(u60_infile,header=None, names=["date","u60"])
# NINO34_infile = "{0}/{1}_{2}".format(model_dir,"NINO34",model_fname)
# NINO34 = pd.read_csv(NINO34_infile,header=None, names=["date","NINO34"])

# Concatenate into single dataframe
allactors_df = pd.concat([NAO["date"],
			 NAO["NAO"],
			 BKsic["BK-SIC"],
			 #NINO34["Nino34"],
			 EAtas["EA-tas"],
			 PoV["PoV"],
			 u60["u60"],
			 QBO["QBO"],
			 NINO34["NINO34"],
			 SibSLP["Sib-SLP"],
			 UralSLP["Ural-SLP"],
			 v_flux["v_flux"]],axis=1)

csv_outfile = "{0}/{1}".format(main_dir,model_fname)
print("Saving to file: {0}".format(csv_outfile))
allactors_df.to_csv(csv_outfile)

#
#all_actors = []
#for n, a in enumerate(actors):
#	infile = "{0}/{1}{2}".format(model_dir,a,model_fname)
#
#	print(infile)
#	in_pd = pd.read_csv(infile,header=None, names=["date",a])
#	all_actors.append(in_pd)
#
#actors = ("NAO",
#	  "BK-SIC",
#	  "EA-tas",
#	  "PoV",
#	  "QBO",
#	  "Sib-SLP",
#	  "Ural-SLP",
#	  "v_flux")
#
#all_actors = []
#for n, a in enumerate(actors):
#	infile = "{0}/{1}{2}".format(model_dir,a,model_fname)
#
#	print(infile)
#	in_pd = pd.read_csv(infile,header=None, names=["date",a])
#	all_actors.append(in_pd)
#
