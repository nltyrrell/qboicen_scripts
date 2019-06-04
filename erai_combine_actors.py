#!/lustre/tmp/tyrrell/miniconda3/bin/python
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
model = "erai"
time = sys.argv[1]

main_dir = "/ibrix/arch/aledata/tyrrell/erai/cen_data/"
model_fname = f"erai_{time}.csv"

print("\n")
print(f"Running combine_actors with files: {main_dir}/*_{model_fname}")

# Read in all the actor timeseries as pandas dataframes
NAO_infile = "{0}/{1}_{2}".format(main_dir,"NAO",model_fname)
NAO = pd.read_csv(NAO_infile,header=None, names=["date","NAO"])
BKsic_infile = "{0}/{1}_{2}".format(main_dir,"BK-SIC",model_fname)
BKsic = pd.read_csv(BKsic_infile,header=None, names=["date","BK-SIC"])
EAtas_infile = "{0}/{1}_{2}".format(main_dir,"EA-tas",model_fname)
EAtas = pd.read_csv(EAtas_infile,header=None, names=["date","EA-tas"])
PoV_infile = "{0}/{1}_{2}".format(main_dir,"PoV",model_fname)
PoV = pd.read_csv(PoV_infile,header=None, names=["date","PoV"])
QBO_infile = "{0}/{1}_{2}".format(main_dir,"QBO",model_fname)
QBO = pd.read_csv(QBO_infile,header=None, names=["date","QBO"])
SibSLP_infile = "{0}/{1}_{2}".format(main_dir,"Sib-SLP",model_fname)
SibSLP = pd.read_csv(SibSLP_infile,header=None, names=["date","Sib-SLP"])
UralSLP_infile = "{0}/{1}_{2}".format(main_dir,"Ural-SLP",model_fname)
UralSLP = pd.read_csv(UralSLP_infile,header=None, names=["date","Ural-SLP"])
v_flux_infile = "{0}/{1}_{2}".format(main_dir,"v_flux",model_fname)
v_flux = pd.read_csv(v_flux_infile,header=None, names=["date","v_flux"])

# Concatenate into single dataframe
allactors_df = pd.concat([NAO["date"],
                 NAO["NAO"],
                 BKsic["BK-SIC"],
                 EAtas["EA-tas"],
                 PoV["PoV"],
                 QBO["QBO"],
                 SibSLP["Sib-SLP"],
                 UralSLP["Ural-SLP"],
                 v_flux["v_flux"]],axis=1)

csv_outfile = "{0}/{1}".format(main_dir,model_fname)
print("Saving to file: {0}".format(csv_outfile))
allactors_df.to_csv(csv_outfile)

