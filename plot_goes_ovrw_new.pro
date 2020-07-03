pro plot_goes_ovrw_new,obs_id=obs_id

  ; Broad summary plot of the GOES XRS data about the time of the NuSTAR observations
  ; 
  ; New approach to deal with the variety of different satellites
  ; Options
  ; obs_id       - Which NuSTAR observations (default =21)

  ; 17-Feb-2020 - IGH   Started
  ; 11-Mar-2020 - IGH   Updated for Feb 2020
  ; 03-Jul-2020 - IGH   UPdated with Jun 2020 and GOES 16/17
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obs_id) ne 1) then obs_id=12
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129','20200221','20200606']
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
  ;-------------------------------------------
  if (obsname eq '20200221') then timer=['21-Feb-2020 04:00:00','21-Feb-2020 24:00:00']
  ;-------------------------------------------
  if (obsname eq '20200606') then timer=['06-Jun-2020 18:00:00','09-Jun-2020 18:00:00']

  ; Just extend time-range +/- 3 hours
  timer[0]=anytim(anytim(timer[0])-3*60.*60.,/yoh,/trunc)
  timer[1]=anytim(anytim(timer[1])+3*60.*60.,/yoh,/trunc)

  ; Get the data
  clearplot
  !p.multi=[0,2,1]
  !p.charsize=1.5
  a = ogoes()
;  a->set,tstart=timer[0],tend=timer[1]
  a->set,tstart='29-May-2018 12:00',tend='30-May-2018 04:00'
  a->set,/goes15
  a->set, /noaa
  a->plot
  a->set, /sdac
  a->plot
  
  a = ogoes()
  ;  a->set,tstart=timer[0],tend=timer[1]
  a->set,tstart='06-Jun-2020 18:00:00',tend='06-Jun-2020 22:00:00'
  a->set, /noaa
  a->set,/goes16
  a->plot

  
  stop
  
  glow=a->getdata(/low)
  ghigh=a->getdata(/high)
  gtim = a->getdata(/times)
  gutbase = a->get(/utbase)
  gtime=anytim(anytim(gutbase)+gtim,/yoh,/trunc)
  gname=a->get(/sat)
  
  utplot,gtime,glow,timer=timer
  
  stop

  ; Do 10 sec averaging
  ; Date is actually in 2sec (GOES14/15) or 1sec (GOES16/17)
  tav=10
  dt=gtim[1]-gtim[0]
  gav=round(tav/dt)
  
  gtime0=anytim(gtime)
  glow0=glow
  ghigh0=ghigh
  ngs=n_elements(gtime0)

  nngs=ngs/gav
  gtime=strarr(nngs)
  glow=fltarr(nngs)
  ghigh=fltarr(nngs)

  for ii=0L,nngs-1L do begin
    gtime[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
    glow[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
    ghigh[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
  endfor

  ; Plot the data

  gyr=[1e-9,9e-4]
  @post_outset
  !p.thick=2
  loadct,0,/silent
  tube_line_colors

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=6, ysize=8,file='figs/ns_ltc_goesovrnew_'+obsname+'.eps'

  utplot,timer,[1,1],ytitle='!3GOES Flux, '+string(gav,forma='(i2)')+'sec avg [W m!U-2!N]',chars=1.2,$
    /ylog,/nodata,yrange=gyr,timer=timer
  outplot,gtime,ghigh,color=2
  outplot,gtime,glow,color=1
  evt_grid,replicate(timer[0],5),labpos=1.1*[1e-8,1e-7,1e-6,1e-5,1e-4],labels=['A','B','C','M','X'],$
    /data,labsize=1.1,/labonly,/noarrow,align=0,labcolor=150
  for i=0, 4 do outplot,timer,10d^(-8+i)*[1,1],color=150,lines=2,thick=4
  xyouts, 0.42e4,1.96e4,gname+': 1-8 '+string(197b),/device,chars=1.25,color=1
  xyouts, 0.84e4,1.96e4,'0.5-4 '+string(197b),/device,chars=1.25,color=2

  device,/close
  set_plot, mydevice

  stop
end