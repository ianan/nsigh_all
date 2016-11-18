#!/bin/bash
# Run this in the top level directory for the chosen observation data
# i.e. the directory with lots of 200* directories in it

maindir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for d in */ ; do
	id="nu"${d%/}
	fulld=$maindir"/"$d
	# echo "$id"
    cd $fulld
    nupipeline obsmode=SCIENCE_SC indir=$fulld steminputs=$id outdir=event_cl entrystage=1 exitstage=2 pntra=OBJECT pntdec=OBJECT statusexpr="STATUS==b0000xx00xx0xx000" cleanflick=no hkevtexpr=NONE clobber=yes
    cd $maindir
done
