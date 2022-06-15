pro heasarc_ns_sc,obs_id=obs_id

  ; Code to run through the different NuSTAR pointings and convert to solar heliographic from RA & DEC
  ; Uses code from https://github.com/NuSTAR/nustar_solar
  ;
  ; The ephem file is via http://ssd.jpl.nasa.gov/horizons.cgi and info at
  ;  https://github.com/NuSTAR/nustar_solar/blob/master/solar_convert/README.txt
  ;
  ;  Selection should be:
  ;  Ephemeris Type       Observer
  ;  Target Body          Sun (Sol)
  ;  Observer Location    Geocentric
  ;  Time Span            Do 12/24 hrs +/- of the NuSTAR time range
  ;                       Time in 5min binning
  ;  Table Settings       Astrometric (1) and North pole position angle and distance (17)
  ;                       Date/time format - Calendar Date/Time
  ;                       Time digits - Fractional seconds
  ;                       Angle format - Decimal degrees
  ;
  ; Then save result as a text file
  ;
  ;
  ; 18-Nov-2016   IGH
  ; 22-Mar-2017   IGH   Updated with Mar 2017 data
  ; 25-Sep-2017   IGH   Updated with Aug 2017 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obs_id) ne 1) then obs_id=8

  dobs=['20140910','20141101','20141211','20150429','20150901','20160219','20160422','20160726','20170321','20170821']

  ephem_file = dobs[obs_id]+'_ephem.txt'

  dir='~/data/heasarc_nustar/ns_'+dobs[obs_id]

  ; Assuming NuSTAR data is in the above directory, each pointing in a separate directory starting with 2*
  fdirs=file_search(dir,'2*')
  nd=n_elements(fdirs)

  nofiles=''

  for f=0, nd-1 do begin
    indir = fdirs[f]+'/event_cl'
    seqid = file_basename(file_dirname(indir))
    evt_files = file_search(indir+'/nu'+seqid+'*06_cl.evt',count=nnf)
    ; Only do the conversion if there is a *06_cl.evt file in the directory for both
    if (nnf lt 2) then nofiles=[[nofiles],[indir]]
    for i = 0, nnf-1 do nustar_convert_to_solar,evt_files[i], ephem_file
  endfor
  
  nofiles=reform(nofiles)
  for i=1,n_elements(nofiles)-1 do print,'No files: '+ nofiles[i]

end