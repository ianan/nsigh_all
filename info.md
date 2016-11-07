# How to

This is a rough guide to getting the NuSTAR data and then getting it into a format for solar work.

07-Nov-2016

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and Xpec packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files] (http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html) or some form of scientific python [(NuSTAR solar scripts)](https://github.com/NuSTAR/nustar_pysolar)

### What to do:

* Download the data via [HEASARC](https://heasarc.gsfc.nasa.gov/cgi-bin/W3Browse/w3browse.pl) - one approach is to enter an observation date and the mission to be "NuSTAR", then the subsequent page gives all the targets from that day, the "SOL" ones being  the solar ones. You should end up being able to directly download the directories or a wget script to do it. These will probably be compressed so a quick `gunzip -r *` is needed.
* The files have been processed via the NuSTAR pipeline but this should be done afresh from your own HEASoft/Nuproducts installation as the solar case is a special operational mode. More info about what the NuSTAR software can do, as well as the directory structure and different files, is available in the [NuSTAR Software Guide](https://heasarc.gsfc.nasa.gov/docs/nustar/analysis/nustar_swguide.pdf). An example of this for something in directory `/data/20102011001/` would be `nupipeline obsmode=SCIENCE_SC indir=/data/20102011001/  steminputs=nu20102011001 outdir=event_cl entrystage=1 exitstage=2 pntra=OBJECT pntdec=OBJECT statusexpr="STATUS==b0000xx00xx0xx000" cleanflick=no hkevtexpr=NONE clobber=yes`
* The resulting `/data/20102011001/event_cl/nu20102011001A06_cl.evt` and `/data/20102011001/event_cl/nu20102011001B06_cl.evt` are the main eventlist files for FPMA and FPMB respectively for this example observation. To make solar work easier we need to convert the coordinate system of these files from Right Ascension and Declination to Solar Heliographic coordinates. You can do this either in [SSWIDL](https://github.com/NuSTAR/nustar_solar) or with [Python](https://github.com/NuSTAR/nustar_pysolar), with example code and scripts given at both links.
* The resulting Solar Heliographic coordinate system files are then used to create the plots and info in this directory, or can be used for science as well, or viewing via software like [ds9](http://ds9.si.edu/site/Home.html).
