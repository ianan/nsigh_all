pro plot_goes_ovrw,obs_id=obs_id

  ; Broad summary plot of the GOES XRS data about the time of the NuSTAR observations
  ; Options
  ; obs_id       - Which NuSTAR observations (default =19)

  ; 17-Feb-2020 - IGH   Started
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obs_id) ne 1) then obs_id=19
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129']
  obsname=dobs[obs_id]

  if (obsname eq '20140910') then timer=['10-Sep-2014 21:00','11-Sep-2014 01:00']
  ;-------------------------------------------
  if (obsname eq '20141101') then timer=['01-Nov-2014 16:00','01-Nov-2014 23:00']
  ;-------------------------------------------
  if (obsname eq '20141211') then timer=['11-Dec-2014 18:00','11-Dec-2014 20:00']
  ;-------------------------------------------
  if (obsname eq '20150429') then timer=['29-Apr-2015 10:30','29-Apr-2015 13:40']
  ;-------------------------------------------
  if (obsname eq '20150901') then timer=['01-Sep-2015 02:00',' 02-Sep-2015 12:00']
  ;-------------------------------------------
  if (obsname eq '20150901') then timer=['01-Sep-2015 02:00',' 02-Sep-2015 12:00']
  ;-------------------------------------------
  if (obsname eq '20160219') then timer=['19-Feb-2016 18:30',' 20-Feb-2016 01:00']
  ;-------------------------------------------
  if (obsname eq '20160422') then timer=['22-Apr-2016 16:50',' 22-Apr-2016 23:10']
  ;-------------------------------------------
  if (obsname eq '20160726') then timer=['26-Jul-2016 19:00',' 27-Jul-2016 01:30']
  ;-------------------------------------------
  if (obsname eq '20170321') then timer=['21-Mar-2017 11:30',' 21-Mar-2017 20:00']
  ;-------------------------------------------
  if (obsname eq '20170821') then timer=['21-Aug-2017 18:45',' 21-Aug-2017 19:55']
  ;-------------------------------------------
  if (obsname eq '20170911') then timer=['11-Sep-2017 15:45',' 14-Sep-2017 01:20']
  ;-------------------------------------------
  if (obsname eq '20171010') then timer=['10-Oct-2017 01:10:00',' 10-Oct-2017 06:00']
  ;-------------------------------------------
  if (obsname eq '20180529') then timer=['29-May-2018 15:30:00',' 29-May-2018 23:30:00']
  ;-------------------------------------------
  if (obsname eq '20180907') then timer=['07-Sep-2018 14:30:00','10-Sep-2018 18:30:00']
  ;-------------------------------------------
  if (obsname eq '20180928') then timer=['28-Sep-2018 17:45:00','28-Sep-2018 21:30:00']
  ;-------------------------------------------
  if (obsname eq '20190112') then timer=['12-Jan-2019 16:00:00',' 12-Jan-2019 22:45:00']
  ;-------------------------------------------
  if (obsname eq '20190412') then timer=['12-Apr-2019 12:00:00','13-Apr-2019 14:00:00']
  ;-------------------------------------------
  if (obsname eq '20190425') then timer=['25-Apr-2019 21:30:00',' 26-Apr-2019 04:30:00']
  ;-------------------------------------------
  if (obsname eq '20190702') then timer=['02-Jul-2019 04:00:00','02-Jul-2019 07:00:00']
  ;-------------------------------------------
  if (obsname eq '20200129') then timer=['29-Jan-2020 07:00:00','30-Jan-2020 21:00:00']

  ; Just extend time-range +/- 12 hours
  timer[0]=anytim(anytim(timer[0])-12*60.*60.,/yoh,/trunc)
  timer[1]=anytim(anytim(timer[1])+12*60.*60.,/yoh,/trunc)

  ; Get the data
  a = ogoes()
  a->set,tstart=anytim(anytim(timer[0])-30*60.,/yoh),tend=anytim(anytim(timer[1])+30*60.,/yoh)
  a->set, /goes15
  glow15=a->getdata(/low)
  ghigh15=a->getdata(/high)
  gtim15 = a->getdata(/times)
  gutbase15 = a->get(/utbase)
  gtime15=anytim(anytim(gutbase15)+gtim15,/yoh,/trunc)

  a->set, /goes14
  glow14=a->getdata(/low)
  ghigh14=a->getdata(/high)
  gtim14 = a->getdata(/times)
  gutbase14 = a->get(/utbase)
  gtime14=anytim(anytim(gutbase14)+gtim14,/yoh,/trunc)
  
  gav=5
  
  if (n_elements(gav) ne 0) then begin
    gtime0=anytim(gtime14)
    glow0=glow14
    ghigh0=ghigh14
    ngs=n_elements(gtime0)

    nngs=ngs/gav
    gtime14=strarr(nngs)
    glow14=fltarr(nngs)
    ghigh14=fltarr(nngs)

    for ii=0L,nngs-1L do begin
      gtime14[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
      glow14[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
      ghigh14[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
    endfor

    gtime0=anytim(gtime15)
    glow0=glow15
    ghigh0=ghigh15
    ngs=n_elements(gtime0)

    nngs=ngs/gav
    gtime15=strarr(nngs)
    glow15=fltarr(nngs)
    ghigh15=fltarr(nngs)

    for ii=0L,nngs-1L do begin
      gtime15[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
      glow15[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
      ghigh15[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
    endfor

  endif

  ; Plot the data

  gyr=[1e-9,1e-4]
  @post_outset
  !p.thick=1
  loadct,0,/silent
  tube_line_colors

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=6, ysize=8,file='figs/ns_ltc_goesovr_'+obsname+'.eps'

  utplot,timer,[1,1],ytitle='!3GOES Flux, '+string(gav,forma='(i2)')+'min avg [W m!U-2!N]',chars=1.2,$
    /ylog,/nodata,yrange=gyr,timer=timer
  outplot,gtime14,ghigh14,color=8
  outplot,gtime15,ghigh15,color=2
  outplot,gtime14,glow14,color=4
  outplot,gtime15,glow15,color=1
  evt_grid,replicate(timer[0],5),labpos=1.1*[1e-8,1e-7,1e-6,1e-5,1e-4],labels=['A','B','C','M','X'],$
    /data,labsize=1.1,/labonly,/noarrow,align=0,labcolor=150
  for i=0, 4 do outplot,timer,10d^(-8+i)*[1,1],color=150,lines=2,thick=4
  xyouts, 0.42e4,1.96e4,'15: 1-8 '+string(197b),/device,chars=1.25,color=1
  xyouts, 0.68e4,1.96e4,'0.5-4 '+string(197b),/device,chars=1.25,color=2

  xyouts, 1.0e4,1.96e4,'14: 1-8 '+string(197b),/device,chars=1.25,color=4
  xyouts, 1.26e4,1.96e4,'0.5-4 '+string(197b),/device,chars=1.25,color=8

  device,/close
  set_plot, mydevice

  stop
end