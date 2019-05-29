#!/bin/bash

# Run the combine_actors.py script, for the current models
#
# nicholas tyrrell 04/2018

script_dir="/group_workspaces/jasmin2/gotham/cen_qboi/scripts" 

$script_dir/combine_actors.py "CAM" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "CCCmaCMAM" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "ISAC-CNRECHAM5sh" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "MIROCMIROC-ESM" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "MIROCMIROC-AGCM" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "MRIMRI-ESM2" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "MOHCUMGA7" "Exp1" "r2i1p1" "mon"
$script_dir/combine_actors.py "YonseiHadGEM2-A" "Exp1" "r1i1p1" "mon"
$script_dir/combine_actors.py "YonseiHadGEM2-AC" "Exp1" "r1i1p2" "mon"
$script_dir/combine_actors.py "WACCM" "Exp1" "r1i1p1" "mon"

