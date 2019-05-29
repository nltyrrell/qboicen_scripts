#!/bin/bash

inf=$1
name=$2

cdo gridarea $inf gridarea.nc
cdo mul $inf gridarea.nc areaXvar.nc
cdo fldsum areaXvar.nc sumareaXvar.nc
cdo fldsum gridarea.nc sumarea.nc
cdo div sumareaXvar.nc sumarea.nc ${name}_weightedmean.nc
