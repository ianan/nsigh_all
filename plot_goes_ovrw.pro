pro plot_goes_ovrw,obs_id=obs_id

  ; Broad summary plot of the GOES XRS data about the time of the NuSTAR observations
  ;
  ; New approach to deal with the variety of different satellites
  ; Options
  ; obs_id       - Which NuSTAR observations (default =21)
  ;
  ; NOT TOO USEFUL IF CAMPAIGN IS SPREAD OVER DAYS/WEEKS!
  ; SO GOING FORWARD MIGHT NOT NEED TO UPDATE/RUN WHEN NEW OBS
  ;

  ; 17-Feb-2020 - IGH   Started
  ; 11-Mar-2020 - IGH   Updated for Feb 2020
  ; 03-Jul-2020 - IGH   Updated with Jun 2020, NOAA GOES14/15 + GOES 16/17
  ; 05-Oct-2020 - IGH   Updated with Sep 2020
  ; 22-Feb-2021 - IGH   Updated with Jan 2021 data
  ; 26-May-2021 - IGH   Updated with Apr/May 2021 data
  ; 26-Jul-2021 - IGH   Added in 20 Jul 2021 data
  ; 15-Aug-2021 - IGH   Added in 30 Jul 2021 data
  ; 30-Jan-2022 - IGH   Added in Nov 2021 data
  ;                     Reran so will get the reprocessed (scaling removed) larger G15
  ;                     Reran using one minute for G16 (so electron contamination removed)
  ; 31-Jan-2022 - IGH   Now G15 and G16 is from NOAA and <1min> 
  ;                     Use G14 not G15 for 20170821 as G15 missing
  ; 28-Mar-2022 - IGH   Updated with Feb 2022     
  ; 16-Jun-2022 - IGH   Updated with Jun 2022
  ; 03-Oct-2022 - IGH   Updated with Oct 2022   
  ; 02-Jan-2023 - IGH   Updated with Dec 2022   
  ; 28-Mar-2023 - IGH   Updated with Mar 2023  
  ; 30-Jan-2024 - IGH   Updated with Dec 2023        
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obs_id) ne 1) then obs_id=33
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129','20200221','20200606','20200912',$
    '20210108','20210429','20210720','20210730','20211117',$
    '20220224','20220603','20220906','20221209',$
    '20230318','20231228']
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
  ;-------------------------------------------
  if (obsname eq '20200912') then timer=['12-Sep-2020 09:00:00','13-Sep-2020 00:30:00']
  ;-------------------------------------------
  if (obsname eq '20210108') then timer=['08-Jan-2021 08:00:00','20-Jan-2021 18:00:00']
  ;-------------------------------------------
  if (obsname eq '20210429') then timer=['29-Apr-2021 12:00:00','07-May-2021 24:00:00']
  ;-------------------------------------------
  if (obsname eq '20210720') then timer=['19-Jul-2021 12:00:00','20-Jul-2021 24:00:00']
  ;-------------------------------------------
  if (obsname eq '20210730') then timer=['30-Jul-2021 12:00:00','30-Jul-2021 18:00:00']
  ;-------------------------------------------
  if (obsname eq '20211117') then timer=['17-Nov-2021 12:00:00','22-Nov-2021 18:00:00']
  ;-------------------------------------------
  if (obsname eq '20220224') then timer=['24-Feb-2022 12:00:00','27-Feb-2022 12:00:00']
  ;-------------------------------------------
  if (obsname eq '20220603') then timer=['03-Jun-2022 12:00:00','04-Jun-2022 04:00:00'] 
  ;-------------------------------------------
  if (obsname eq '20220906') then timer=['06-Sep-2022 15:00:00','06-Sep-2022 22:00:00']
  ;-------------------------------------------
  if (obsname eq '20221209') then timer=['09-Dec-2022 23:00:00','11-Dec-2022 23:00:00']
  ;-------------------------------------------
  if (obsname eq '20230318') then timer=['18-Mar-2023 13:00:00','18-Mar-2023 24:00:00']
  ;-------------------------------------------
  if (obsname eq '20231228') then timer=['28-Dec-2023 14:00:00','29-Dec-2023 03:00:00']
  
  ; Should be ok after these times
  ts16='07-Feb-2017' ; Obs 9, March 2017, and after
  ts17='01-Jun-2018' ; Obs 14, Sep 2018, and after
  ; And before these times for GOES15
  te15='04-Mar-2020' ; Obs 21, Feb 2020, and before

  ;  print,ssw_goesn_time2files(timer[0], timer[1], /goes15, /xrs, count=nfile)

  ; Just extend time-range +/- 6 hours
  timer[0]=anytim(anytim(timer[0])-6*60.*60.,/yoh,/trunc)
  timer[1]=anytim(anytim(timer[1])+6*60.*60.,/yoh,/trunc)

  ; Gives a 1min average
  tav=60

  if (anytim(timer[0]) lt anytim(te15)) then begin
;    a = ogoes()
;    a->set,tstart=timer[0],tend=timer[1]
;    a->set, /sdac
;    a->set,/goes14
;    glow14=a->getdata(/low)
;    ghigh14=a->getdata(/high)
;    gtim14 = a->getdata(/times)
;    gutbase14 = a->get(/utbase)
;    gtime14=anytim(anytim(gutbase14)+gtim14,/yoh,/trunc)
;    gname14=a->get(/sat)
;    obj_destroy,a
;
;    dt=gtim14[1]-gtim14[0]
;    gav=round(tav/dt)
;
;    gtime0=anytim(gtime14)
;    glow0=glow14
;    ghigh0=ghigh14
;    ngs=n_elements(gtime0)
;
;    nngs=ngs/gav
;    gtime14=strarr(nngs)
;    glow14=fltarr(nngs)
;    ghigh14=fltarr(nngs)
;
;    for ii=0L,nngs-1L do begin
;      gtime14[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;      glow14[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;      ghigh14[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;    endfor

    a = ogoes()
    a->set,tstart=timer[0],tend=timer[1]
;     this only returns the 2s version???
    a->set,/noaa;/sdac
    if (obsname eq '20170821') then begin
      a->set, /goes14
    endif else begin
      a->set, /goes15
    endelse
    a->set,/one
    glow15=a->getdata(/low)
    ghigh15=a->getdata(/high)
    gtim15 = a->getdata(/times)
    gutbase15 = a->get(/utbase)
    gtime15=anytim(anytim(gutbase15)+gtim15,/yoh,/trunc)
    gname15=a->get(/sat)
    obj_destroy,a

;    dt=gtim15[1]-gtim15[0]
;    gav=round(tav/dt)
;
;    gtime0=anytim(gtime15)
;    glow0=glow15
;    ghigh0=ghigh15
;    ngs=n_elements(gtime0)
;
;    nngs=ngs/gav
;    gtime15=strarr(nngs)
;    glow15=fltarr(nngs)
;    ghigh15=fltarr(nngs)
;
;    for ii=0L,nngs-1L do begin
;      gtime15[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;      glow15[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;      ghigh15[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;    endfor

  endif

  if (anytim(timer[0]) gt anytim(ts16)) then begin
    a = ogoes()
    a->set,tstart=timer[0],tend=timer[1]
    a->set, /noaa
    ; Get the one sec version, as also removes the electron contamination
    a->set, /one
    a->set,/goes16
    glow16=a->getdata(/low)
    ghigh16=a->getdata(/high)
    gtim16 = a->getdata(/times)
    gutbase16 = a->get(/utbase)
    gtime16=anytim(anytim(gutbase16)+gtim16,/yoh,/trunc)
    gname16=a->get(/sat)
    obj_destroy,a

;    dt=gtim16[1]-gtim16[0]
;    gav=round(tav/dt)

;    gtime0=anytim(gtime16)
;    glow0=glow16
;    ghigh0=ghigh16
;    ngs=n_elements(gtime0)
;
;    nngs=ngs/gav
;    gtime16=strarr(nngs)
;    glow16=fltarr(nngs)
;    ghigh16=fltarr(nngs)
;
;    for ii=0L,nngs-1L do begin
;      gtime16[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;      glow16[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;      ghigh16[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;    endfor

  endif

;  if (anytim(timer[0]) gt anytim(ts17)) then begin
;    a = ogoes()
;    a->set,tstart=timer[0],tend=timer[1]
;    a->set, /noaa
;    a->set, /one
;    a->set,/goes17
;    glow17=a->getdata(/low)
;    ghigh17=a->getdata(/high)
;    gtim17 = a->getdata(/times)
;    gutbase17 = a->get(/utbase)
;    gtime17=anytim(anytim(gutbase17)+gtim17,/yoh,/trunc)
;    gname17=a->get(/sat)
;    obj_destroy,a
;
;    dt=gtim17[1]-gtim17[0]
;    gav=round(tav/dt)
;
;    gtime0=anytim(gtime17)
;    glow0=glow17
;    ghigh0=ghigh17
;    ngs=n_elements(gtime0)
;
;    nngs=ngs/gav
;    gtime17=strarr(nngs)
;    glow17=fltarr(nngs)
;    ghigh17=fltarr(nngs)
;
;    for ii=0L,nngs-1L do begin
;      gtime17[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;      glow17[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;      ghigh17[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;    endfor
;
;  endif


  gyr=[2e-9,9e-6]

  @post_outset
  !p.thick=4
  loadct,0,/silent
  tube_line_colors
  !p.multi=[0,2,1]

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=6, ysize=8,file='figs/ns_ltc_goesovr_'+obsname+'.eps'

  if (anytim(timer[0]) lt anytim(te15)) then begin
    utplot,timer,[1,1],ytitle='!3NOAA GOES/XRS, avg1m [W m!U-2!N]',chars=1.2,$
      /ylog,/nodata,yrange=gyr,timer=timer,position=[0.15,0.55,0.95,0.95]
    evt_grid,replicate(timer[0],3),labpos=1.1*[1e-8,1e-7,1e-6],labels=['A','B','C'],$
      /data,labsize=1.1,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,timer,10d^(-8+i)*[1,1],color=150,lines=2,thick=4
;    outplot,gtime14,ghigh14,color=8,thick=2
    outplot,gtime15,ghigh15,color=2
;    outplot,gtime14,glow14,color=4,thick=2
    outplot,gtime15,glow15,color=1
    if (obsname eq '20170821') then begin
      xyouts, 1.5e4,1.55e4,'G14: 1-8 '+string(197b),/device,chars=0.9,color=1,orien=90
    endif else begin
      xyouts, 1.5e4,1.55e4,'G15: 1-8 '+string(197b),/device,chars=0.9,color=1,orien=90
    endelse
    xyouts, 1.5e4,1.8e4,'0.5-4 '+string(197b),/device,chars=0.9,color=2,orien=90
;    xyouts, 1.5e4,1.1e4,'G14: 1-8 '+string(197b),/device,chars=0.9,color=4,orien=90
;    xyouts, 1.5e4,1.35e4,'0.5-4 '+string(197b),/device,chars=0.9,color=8,orien=90
  endif



  if (anytim(timer[0]) gt anytim(ts16)) then begin
    utplot,timer,[1,1],ytitle='!3NOAA GOES/XRS, avg1m [W m!U-2!N]',chars=1.2,$
      /ylog,/nodata,yrange=gyr,timer=timer,position=[0.15,0.07,0.95,0.47]
    evt_grid,replicate(timer[0],3),labpos=1.1*[1e-8,1e-7,1e-6],labels=['A','B','C'],$
      /data,labsize=1.1,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,timer,10d^(-8+i)*[1,1],color=150,lines=2,thick=4
;    if (anytim(timer[0]) gt anytim(ts17)) then begin
;      outplot,gtime17,ghigh17,color=8,thick=2
;      outplot,gtime17,glow17,color=4,thick=2
;      xyouts, 1.5e4,0.1e4,'G17: 1-8 '+string(197b),/device,chars=0.9,color=4,orien=90
;      xyouts, 1.5e4,0.35e4,'0.5-4 '+string(197b),/device,chars=0.9,color=8,orien=90
;    endif
    outplot,gtime16,ghigh16,color=2
    outplot,gtime16,glow16,color=1
    xyouts, 1.5e4,0.55e4,'G16: 1-8 '+string(197b),/device,chars=0.9,color=1,orien=90
    xyouts, 1.5e4,0.8e4,'0.5-4 '+string(197b),/device,chars=0.9,color=2,orien=90



  endif


  device,/close
  set_plot, mydevice
end