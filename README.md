# A rough how to guide

This repo is mostly code/figures/data that gives an overview of the NuSTAR solar observations. So it is a rough guide to getting the NuSTAR data and then turning it into a useful format for solar work. For more details of how to use the data for solar analysis go to my [NuSTAR Solar Analysis Code repo](https://github.com/ianan/nustar_sac).

The files [batch_ltc.pro](https://github.com/ianan/nsigh_all/blob/master/batch_ltc.pro) and [batch_maps.pro](https://github.com/ianan/nsigh_all/blob/master/batch_maps.pro) give examples of using the code to make the plots/info files.

For a nice webpage with plots summarising the NuSTAR solar observations, go to the [GitHub pages version of this repo.](http://ianan.github.io/nsigh_all/)

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and XSPEC packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files] (http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html) or some form of scientific python [(NuSTAR solar scripts)](https://github.com/NuSTAR/nustar_pysolar)

And you should also look at:

* [NuSTAR Github pages](https://github.com/NuSTAR)
* [NuSTAR Software Guide](https://heasarc.gsfc.nasa.gov/docs/nustar/analysis/nustar_swguide.pdf) - detailed information about the functions of the NuSTAR software in HEASoft
* [NuSTAR Observatory guide](https://heasarc.gsfc.nasa.gov/docs/nustar/nustar_obsguide.pdf) - covers instrument through data, processing and analysis (like spectral fitting in XSPEC)

### What to do:

* Download the data via [HEASARC](https://heasarc.gsfc.nasa.gov/cgi-bin/W3Browse/w3browse.pl) - one approach is to enter an observation date and the mission to be "NuSTAR", then the subsequent page gives all the targets from that day, the "SOL" ones being  the solar ones. You should end up being able to directly download the directories or a wget script to do it. These will probably be compressed so a quick `gunzip -r *` is needed.
* The files have been processed via the NuSTAR pipeline but as the solar observations are not a typical observation mode it would be wise to do this yourself from your own HEASoft/Nuproducts installation as the solar case. More info about what the NuSTAR software can do, as well as the directory structure and different files, is available in the [NuSTAR Software Guide](https://heasarc.gsfc.nasa.gov/docs/nustar/analysis/nustar_swguide.pdf). An example of this for something in directory `/data/20102011001/` would be `nupipeline obsmode=SCIENCE_SC indir=/data/20102011001/  steminputs=nu20102011001 outdir=event_cl entrystage=1 exitstage=2 pntra=OBJECT pntdec=OBJECT statusexpr="STATUS==b0000xx00xx0xx000" cleanflick=no hkevtexpr=NONE clobber=yes` . Or you could use a bash script like [this](https://github.com/ianan/nsigh_all/blob/master/nu_pipe_run_all.sh) to do it for you.
* The resulting `/data/20102011001/event_cl/nu20102011001A06_cl.evt` and `/data/20102011001/event_cl/nu20102011001B06_cl.evt` are the main eventlist files for FPMA and FPMB respectively for this example observation. To make solar work easier we need to convert the coordinate system of these files from Right Ascension and Declination to Solar Heliographic coordinates. You can do this either in [SSWIDL](https://github.com/NuSTAR/nustar_solar) or with [Python](https://github.com/NuSTAR/nustar_pysolar), with example code and scripts given at both links. An additional example script for running the SSWIDL code can be found [here](https://github.com/ianan/nsigh_all/blob/master/heasarc_ns_sc.pro).
* The resulting Solar Heliographic coordinate system files are then used to create the plots and info in this directory (via SSWIDL at the moment), and of course can be used for science as well, or can be quick viewed via software like [ds9](http://ds9.si.edu/site/Home.html).
* Presumably you now want to do something with your .evt files so have a look at my [NuSTAR Solar Analysis Code repo](https://github.com/ianan/nustar_sac).

