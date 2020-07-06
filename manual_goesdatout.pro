pro manual_goesdatout

  ; Make the summary dat files for the plots directly from the source GOES/XRS files
  ; without having to go through the ogoes() code
  ;
  ; Could be beacause the science data isn't there but the l2 is, i.e.
  ;
  ;https://data.ngdc.noaa.gov/platforms/solar-space-observing-satellites/goes/goes16/l2/data/xrsf-l2-flx1s/2020/06/
  ; instead of
  ;https://data.ngdc.noaa.gov/platforms/solar-space-observing-satellites/goes/goes16/l2/data/xrsf-l2-flx1s_science/2020/06/
  ;
  ; But is this data still problematic until it becomes the "science" version ????
  ;
  ; 06-Jul-2020 -IGH

  ;  obsname='202006_07'
  obsname='202006_08'
  if (obsname eq '202006_07') then timer=['07-Jun-2020 18:30','07-Jun-2020 22:30']
  if (obsname eq '202006_08') then timer=['08-Jun-2020 18:30','08-Jun-2020 22:30']

  date=strmid(break_time(timer[0]),0,8)

  file=file_search(goes_temp_dir() + '/dn_xrsf-l2-flx1s_g16_d'+date+'*')
  ncdf_list, file, vname=vname, /variables, /quiet
  ncdf_get, file, vname, output, /struct
  ;  help,output.time.value
  t = output.time.value + anytim('01-Jan-2000 12:00')
  idt=where(t ge anytim(timer[0]) and t lt anytim(timer[1]))
  gtime16=anytim(t[idt],/yoh,/trunc)
  glow16=output.xrsb_flux.value[idt] > 1e-11
  ghigh16=output.xrsa_flux.value[idt] > 1e-11

  clearplot
  !p.multi=0
  tube_line_colors
  utplot,timer, [1,1],/ylog,timer=timer,yrange=[7e-10,4e-6],/nodata
  outplot,gtime16,ghigh16,color=2
  outplot,gtime16, glow16,color=1

  gfile='dat_files/goes16_ltc_'+obsname+'.dat'
  save,file=gfile,gtime16,glow16,ghigh16

  stop
end