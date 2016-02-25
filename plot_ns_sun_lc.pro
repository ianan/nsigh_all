pro plot_ns_sun_lc, obsname=obsname,timer=timer,goes=goes,gyr=gyr,gav=gav,$
  maindir=maindir,nsdir=nsdir,gesnlog=gesnlog,chudo=chudo

  ; Script to generate overview time profiles of NuSTAR livetime, GOES and RHESSI flux
  ; The data it uses is either *.dat files in the dat_files directory or if those do not
  ; exist the code with generate these from a *local* copy of the NuSTAR data and *online*
  ; for GOES & RHESSI (might need a search_network,/enabled for the latter).
  ;
  ; In reality the *.dat files should be there and you don't need the original NuSTAR data (or setup maindir, nsdir etc)

  ; Options
  ; obsname       - Which NuSTAR observations (default ='201409')
  ; timer         - Overal time range to plot (default, specified values per obs below)
  ; goes          - Plot an additional GOES lightcurve with NuSTAR times highlighted (default no)
  ; gyr           - yrange for the GOES lightcurve (default, specified values per obs below)
  ; gav           - Average the GOES light curve, multiples of the 2sec binning (default NO, for 10secs do gav=5 etc)
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ; gesnlog       - Plot the GOES light curve with ylog=0 in default NuSTAR, GOES, RHESSI plot
  ; chudo         - Do an extra plot with NuSTAR Livetime, CHU, GOES and RHESSI (default no)

  ; example of usage
  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  ; plot_ns_sun_lc, obsname='201409',gav=5,/goes

  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  ; plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo

  ; 04-Aug-2015 IGH - Script to plot the lightcurves for the nustar obs tims
  ; 01-Sep-2015 IGH - Added in the times of the Sep 2015 observations
  ; 23-Feb-2016 IGH - Added in the times of the Feb 2016 observations
  ; 24-Feb-2016 IGH - Added in option to include panel with the CHU state

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obsname) ne 1) then obsname='201411';'201411'
  if (n_elements(maindir) ne 1) then maindir='~/data/ns_data/

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Which obs are we dealing with ?
  ; Setup info per NuSTAR observation run
  if (obsname eq '201409') then begin
    torbs=[['10-Sep-2014 21:43:00','10-Sep-2014 22:44:20'],$
      ['10-Sep-2014 23:19:50','11-Sep-2014 00:21:20']]
    timer=['10-Sep-2014 21:00','11-Sep-2014 01:00']
    nsdir='obs1_bg/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ; only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]

    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]

    gyrl=[20,80]
  endif
  if (obsname eq '201411') then begin
    torbs='01-Nov-2014 '+[['16:43:30','17:45:30'],['18:20:20','19:22:20'],$
      ['19:57:10','20:59:10'],['21:34:00','22:36:00']]
    timer=['01-Nov-2014 16:00','01-Nov-2014 23:00']
    nsdir='obs2_bg2/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ; only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    ; make sure just the original 200* directories
    hkf=hkf[where(strpos(hkf,'bg2/200') ge 0)]

    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    chuf=chuf[where(strpos(chuf,'bg2/200') ge 0)]

    gyrl=[3,7]
  endif
  if (obsname eq '201412') then begin
    torbs='11-Dec-2014 '+[['18:38','19:41']]
    timer=['11-Dec-2014 18:00','11-Dec-2014 20:00']
    nsdir='obs3_bg2/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ; only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[6,7.5]
  endif
  if (obsname eq '201504') then begin
    torbs=[['29-Apr-2015 '+['10:50','11:50']],['29-Apr-2015 '+['12:27','13:27']]]
    timer='29-Apr-2015 '+['10:30','13:40']
    nsdir='obs4_bg/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ; only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    ; make sure just the original 2011* directories
    hkf=hkf[where(strpos(hkf,'bg/2011') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    chuf=chuf[where(strpos(chuf,'bg/2011') ge 0)]

    gyrl=[2.8,3.8]
  endif

  if (obsname eq '201509') then begin
    torbs=[['01-Sep-2015 '+['02:10','03:12']],['01-Sep-2015 '+['03:47','04:48']],['01-Sep-2015 '+['08:37','09:39']],$
      ['01-Sep-2015 '+['10:14','11:15']],['02-Sep-2015 '+['02:21','03:23']],['02-Sep-2015 '+['03:58','04:59']],$
      ['02-Sep-2015 '+['08:48','09:50']],['02-Sep-2015 '+['10:25','11:26']]]
    timer=['01-Sep-2015 02:00',' 02-Sep-2015 12:00']
    nsdir='obs5/lg_convert/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.7,3.0]
  endif
  ;-------------------------------------------
  ; As over 2 days can split the Sep-2015 obs into two parts
  if (obsname eq '201509_01') then begin
    torbs=[['01-Sep-2015 '+['02:10','03:12']],['01-Sep-2015 '+['03:47','04:48']],['01-Sep-2015 '+['08:37','09:39']],$
      ['01-Sep-2015 '+['10:14','11:15']]]
    timer=['01-Sep-2015 02:00',' 01-Sep-2015 12:00']
    nsdir='obs5/lg_convert/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.7,3.0]
  endif

  if (obsname eq '201509_02') then begin
    torbs=[['02-Sep-2015 '+['02:21','03:23']],['02-Sep-2015 '+['03:58','04:59']],$
      ['02-Sep-2015 '+['08:48','09:50']],['02-Sep-2015 '+['10:25','11:26']]]
    timer=['02-Sep-2015 02:00',' 02-Sep-2015 12:00']
    nsdir='obs5/lg_convert/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.7,3.0]
  endif

  ;-------------------------------------------

  if (obsname eq '201602') then begin
    torbs=[['19-Feb-2016 '+['18:54','19:56']],['19-Feb-2016 '+['20:31','21:32']],['19-Feb-2016 '+['22:07','23:09']],$
      ['19-Feb-2016 23:44','20-Feb-2016 00:16']]
    timer=['19-Feb-2016 18:30',' 20-Feb-2016 01:00']
    nsdir='obs6/heasarc/'
    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[2.2,4.5]
  endif

  norbs=n_elements(torbs[0,*])

  ;-------------------------------------------
  ;-------------------------------------------
  ; If no GOES *.dat file then make one
  gfile='dat_files/goes_ltc_'+obsname+'.dat'
  if (file_test(gfile) eq 0) then begin
    a = ogoes()
    a->set,tstart=anytim(anytim(timer[0])-30*60.,/yoh),tend=anytim(anytim(timer[1])+30*60.,/yoh)
    glow=a->getdata(/low)
    ghigh=a->getdata(/high)
    gtim = a->getdata(/times)
    gutbase = a->get(/utbase)
    gtime=anytim(anytim(gutbase)+gtim,/yoh,/trunc)
    save,file=gfile,gtime,glow,ghigh
  endif else begin
    restore,file=gfile
  endelse

  ;-------------------------------------------
  ; Need to average the GOES data?
  if (n_elements(gav) ne 0) then begin
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
  endif

  if (n_elements(gyr) ne 2) then gyr=[2d-9,2d-5]
  @post_outset
  !p.thick=6
  loadct,0,/silent
  tube_line_colors

  ;-------------------------------------------
  ; Do a GOES plot with the NuSTAR orb times highlighted ?
  if keyword_set(goes) then begin

    set_plot,'ps'
    device, /encapsulated, /color, /isolatin1,/inches, $
      bits=8, xsize=6, ysize=5,file='figs/ns_ltc_goes_'+obsname+'.eps'

    utplot,gtime,glow,ytitle='!3GOES Flux [W m!U-2!N]',chars=1.2,$
      /ylog,/nodata,yrange=gyr,timer=timer
    outplot,gtime,glow,color=150,thick=6
    outplot,gtime,ghigh,color=150,thick=6

    norbs=n_elements(torbs[0,*])
    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyr,lines=0,color=0,thick=3
      outplot,[torbs[1,i],torbs[1,i]],gyr,lines=0,color=0,thick=3

      gd1=where(anytim(gtime) ge anytim(torbs[0,i]) and anytim(gtime) le anytim(torbs[1,i]))
      outplot,gtime[gd1],glow[gd1],color=1,thick=6
      outplot,gtime[gd1],ghigh[gd1],color=2,thick=6
      ;      outplot,torbs[*,i],0.2*gyr[1]*[1,1],lines=0,thick=10
    endfor

    evt_grid,replicate(gtime[0],5),labpos=1.2*[1e-8,1e-7,1e-6,1e-5,1e-4],labels=['A','B','C','M','X'],$
      /data,labsize=1.5,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,[gtime[0],gtime[n_elements(gtime)-1]],10d^(-8+i)*[1,1],color=150,lines=2,thick=4
    xyouts, 0.32e4,1.2e4,'1-8 '+string(197b),/device,chars=1.25,color=1
    xyouts, 0.5e4,1.2e4,'0.5-4 '+string(197b),/device,chars=1.25,color=2

    device,/close
    set_plot, mydevice
  endif

  ;-------------------------------------------
  ; Get the RHESSI data if *.dat file not there
  rfile='dat_files/rhessi_ltc_'+obsname+'.dat'
  if (file_test(rfile) eq 0) then begin
    obj = hsi_obs_summary()
    timef=anytim([anytim(timer[0])-30*60.,anytim(timer[1])+30*60.],/yoh,/trunc)
    obj ->set,obs_time_interval=[timef]
    crd = obj -> getdata(/corrected)
    rtime = anytim(obj -> getaxis(/ut),/yoh,/trunc)
    save,file=rfile,rtime,crd
  endif else begin
    restore,file=rfile
  endelse

  ;-------------------------------------------
  ; Get the NuSTAR livetime if *.dat is not there
  nhk=n_elements(hkf)
  if (nhk gt 0) then begin
    hkfile='dat_files/ns_hk_ltc_'+obsname+'.dat'
    if (file_test(hkfile) eq 0) then begin
      for ii=0, nhk-1 do begin
        hka = mrdfits(hkf[ii], 1, hkahdr)
        if (ii eq 0) then htime=anytim(hka.time+anytim('01-Jan-2010'),/yoh) else $
          htime=[htime,anytim(hka.time+anytim('01-Jan-2010'),/yoh)]
        if (ii eq 0) then hlive=hka.livetime else hlive=[hlive,hka.livetime]
      endfor
      ids=sort(anytim(htime))
      htime=htime[ids]
      hlive=hlive[ids]
      save,file=hkfile,htime,hlive
    endif else begin
      restore,file=hkfile
    endelse
  endif

  ;-------------------------------------------
  ; Get the NuSTAR CHU if *.dat is not there and you want it plotted
  if keyword_set(chudo) then begin
    nch=n_elements(chuf)
    if (nch gt 0) then begin
      chufile='dat_files/ns_chu_ltc_'+obsname+'.dat'
      if (file_test(chufile) eq 0) then begin
        for ii=0, nch-1 do begin

          for chunum= 1, 3 do begin
            chu = mrdfits(chuf[ii], chunum)
            maxres = 20 ;; [arcsec] maximum solution residual
            qind=1 ; From KKM code...
            if chunum eq 1 then begin
              mask = (chu.valid EQ 1 AND $          ;; Valid solution from CHU
                chu.residual LT maxres AND $  ;; CHU solution has low residuals
                chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
                chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
            endif else begin
              mask += (chu.valid EQ 1 AND $            ;; Valid solution from CHU
                chu.residual LT maxres AND $    ;; CHU solution has low residuals
                chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
                chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
            endelse
          endfor

          if (ii eq 0) then chutime=anytim(chu.time+anytim('01-Jan-2010'),/yoh) else $
            chutime=[chutime,anytim(chu.time+anytim('01-Jan-2010'),/yoh)]
          if (ii eq 0) then chumask=mask else chumask=[chumask,mask]
        endfor
        save,file=chufile,chutime,chumask
      endif else begin
        restore,file=chufile
      endelse
    endif
  endif

  ;-------------------------------------------
  ; Make a plot of NuSTAR livetime, GOES and RHESSI fluxes
  !p.multi=[0,3,1]
  if keyword_set(gesnlog) then figname='figs/ns_ltc_goesnl_hsi_'+obsname+'.eps' else $
    figname='figs/ns_ltc_goes_hsi_'+obsname+'.eps'
  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=5, ysize=5,file=figname
  !p.charsize=1.7
  !p.thick=4
  utplot,timer,[1,1],/ylog,yrange=[1e-3,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
    position=[0.12,0.69,0.95,0.99],xtit='',xtickf='(a1)',timer=timer,/nodata

  if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3
  xyouts, 12.5e3,9e3,'FPMA',chars=0.7,/device,orien=90,color=3


  ; Want ylog=0 for the GOES panel?
  if Keyword_set(gesnlog) then begin

    utplot,gtime,glow,ytitle='!3GOES Flux [x10!u-7!N W m!U-2!N]',$
      /nodata,yrange=gyrl,timer=timer,position=[0.12,0.38,0.95,0.68],xtit='',xtickf='(a1)'
    outplot,gtime,glow*1d7,color=150,thick=4

    norbs=n_elements(torbs[0,*])
    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2
      gd1=where(anytim(gtime) ge anytim(torbs[0,i]) and anytim(gtime) le anytim(torbs[1,i]))
      outplot,gtime[gd1],glow[gd1]*1d7,color=1,thick=4
    endfor

    xyouts, 12.5e3,5e3,'1-8 '+string(197b),chars=0.7,/device,orien=90,color=1

  endif else begin
    utplot,gtime,glow,ytitle='!3GOES Flux [W m!U-2!N]',$
      /ylog,/nodata,yrange=gyr,timer=timer,position=[0.12,0.38,0.95,0.68],xtit='',xtickf='(a1)'
    outplot,gtime,glow,color=150,thick=4
    outplot,gtime,ghigh,color=150,thick=4

    norbs=n_elements(torbs[0,*])
    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyr,lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],gyr,lines=2,color=0,thick=2

      gd1=where(anytim(gtime) ge anytim(torbs[0,i]) and anytim(gtime) le anytim(torbs[1,i]))
      outplot,gtime[gd1],glow[gd1],color=1,thick=4
      outplot,gtime[gd1],ghigh[gd1],color=2,thick=4
    endfor

    evt_grid,replicate(timer[0],4),labpos=1.2*[1e-8,1e-7,1e-6,1e-5],labels=['A','B','C','M'],$
      /data,labsize=0.7,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,[gtime[0],gtime[n_elements(gtime)-1]],10d^(-8+i)*[1,1],color=150,lines=1,thick=2

    xyouts, 12.5e3,5e3,'1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
    xyouts, 12.5e3,6e3,'0.5-4 '+string(197b),chars=0.7,/device,orien=90,color=2

  endelse

  dct=[4,5]

  tube_line_colors
  ymax=1.3*max(crd.countrate[0:1,*])
  ryr=[2,ymax]
  utplot, rtime, crd.countrate[0,*],$
    ytitle=' RHESSI [s!U-1!N det!U-1!N]',/ylog,yrange=ryr,$
    ytickf='exp1',timer=timer,psym=10,/nodata,position=[0.12,0.07,0.95,0.37]
  outplot,rtime, crd.countrate[0,*],color=dct[0],psym=10,thick=2
  outplot,rtime, crd.countrate[1,*],color=dct[1],psym=10,thick=2

  yrls=10d^(alog10(ryr[1])-[0.1,0.2,0.3,0.4,0.5]*(alog10(ryr[1])-alog10(ryr[0])))

  xyouts, 12.5e3,1e3,'3-6 keV',chars=0.7,/device,orien=90,color=dct[0]
  xyouts, 12.5e3,2.5e3,'6-12 keV',chars=0.7,/device,orien=90,color=dct[1]

  for i=0, norbs-1 do begin
    outplot,[torbs[0,i],torbs[0,i]],ryr,lines=2,color=0,thick=2
    outplot,[torbs[1,i],torbs[1,i]],ryr,lines=2,color=0,thick=2
  endfor

  device,/close
  set_plot, mydevice

  ;-------------------------------------------
  ; Make a plot of NuSTAR livetime, CHU state, GOES and RHESSI fluxes
  if keyword_Set(chudo) then begin
    
    !p.multi=[0,4,1]
    if keyword_set(gesnlog) then figname='figs/ns_ltc_chu_goesnl_hsi_'+obsname+'.eps' else $
      figname='figs/ns_ltc_chu_goes_hsi_'+obsname+'.eps'
    set_plot,'ps'
    device, /encapsulated, /color, /isolatin1,/inches, $
      bits=8, xsize=5, ysize=6,file=figname
    !p.charsize=1.5
    !p.thick=4
    utplot,timer,[1,1],/ylog,yrange=[1e-3,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
      position=[0.12,0.70,0.95,0.99],xtit='',xtickf='(a1)',timer=timer,/nodata

    if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3
    xyouts, 12.5e3,11e3,'FPMA',chars=0.7,/device,orien=90,color=3

    ; Set up the y labelling
    ;; mask = 1, chu1 only
    ;; mask = 4, chu2 only
    ;; mask = 9, chu3 only
    ;; mask = 5, chu12
    ;; mask = 10 chu13
    ;; mask = 13 chu23
    ;; mask = 14 chu123

    ; Change the KKM mask setup into something a bit easier to plot
    newmask=intarr(n_elements(chumask))
    id1=where(chumask eq 1,nid1)
    if (nid1 gt 0) then newmask[id1]=1
    id2=where(chumask eq 4,nid2)
    if (nid2 gt 0) then newmask[id2]=2
    id12=where(chumask eq 5,nid12)
    if (nid12 gt 0) then newmask[id12]=3
    id3=where(chumask eq 9,nid3)
    if (nid3 gt 0) then newmask[id3]=4
    id13=where(chumask eq 10,nid13)
    if (nid13 gt 0) then newmask[id13]=5
    id23=where(chumask eq 13,nid23)
    if (nid23 gt 0) then newmask[id23]=6
    id123=where(chumask eq 14,nid123)
    if (nid123 gt 0) then newmask[id123]=7

    ylab=[' ','1','2','12','3','13','23','123',' ']
    utplot,chutime,newmask,psym=1,yrange=[0,8],ytitle='NuSTAR CHUs',yticks=8,yminor=1,ytickname=ylab,$
      timer=timer,position=[0.12,0.49,0.95,0.69],symsize=0.5,xtit='',xtickf='(a1)',thick=2

    ; Want ylog=0 for the GOES panel?
    if Keyword_set(gesnlog) then begin

      utplot,gtime,glow,ytitle='!3GOES [x10!u-7!N W m!U-2!N]',$
        /nodata,yrange=gyrl,timer=timer,position=[0.12,0.28,0.95,0.48],xtit='',xtickf='(a1)'
      outplot,gtime,glow*1d7,color=150,thick=4

      norbs=n_elements(torbs[0,*])
      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2
        gd1=where(anytim(gtime) ge anytim(torbs[0,i]) and anytim(gtime) le anytim(torbs[1,i]))
        outplot,gtime[gd1],glow[gd1]*1d7,color=1,thick=4
      endfor

      xyouts, 12.5e3,4.5e3,'1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
    endif else begin
      utplot,gtime,glow,ytitle='!3GOES [W m!U-2!N]',$
        /ylog,/nodata,yrange=gyr,timer=timer,position=[0.12,0.28,0.95,0.48],xtit='',xtickf='(a1)'
      outplot,gtime,glow,color=150,thick=4
      outplot,gtime,ghigh,color=150,thick=4

      norbs=n_elements(torbs[0,*])
      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyr,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyr,lines=2,color=0,thick=2

        gd1=where(anytim(gtime) ge anytim(torbs[0,i]) and anytim(gtime) le anytim(torbs[1,i]))
        outplot,gtime[gd1],glow[gd1],color=1,thick=4
        outplot,gtime[gd1],ghigh[gd1],color=2,thick=4
      endfor

      evt_grid,replicate(timer[0],4),labpos=1.2*[1e-8,1e-7,1e-6,1e-5],labels=['A','B','C','M'],$
        /data,labsize=0.7,/labonly,/noarrow,align=0,labcolor=150
      for i=0, 4 do outplot,[gtime[0],gtime[n_elements(gtime)-1]],10d^(-8+i)*[1,1],color=150,lines=1,thick=2

      xyouts, 12.5e3,5e3,'1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
      xyouts, 12.5e3,6e3,'0.5-4 '+string(197b),chars=0.7,/device,orien=90,color=2

    endelse

    dct=[4,5]

    tube_line_colors
    ymax=1.3*max(crd.countrate[0:1,*])
    ryr=[2,ymax]
    utplot, rtime, crd.countrate[0,*],$
      ytitle=' RHESSI [s!U-1!N det!U-1!N]',/ylog,yrange=ryr,$
      ytickf='exp1',timer=timer,psym=10,/nodata,position=[0.12,0.07,0.95,0.27]
    outplot,rtime, crd.countrate[0,*],color=dct[0],psym=10,thick=2
    outplot,rtime, crd.countrate[1,*],color=dct[1],psym=10,thick=2

    yrls=10d^(alog10(ryr[1])-[0.1,0.2,0.3,0.4,0.5]*(alog10(ryr[1])-alog10(ryr[0])))

    xyouts, 12.5e3,1e3,'3-6 keV',chars=0.7,/device,orien=90,color=dct[0]
    xyouts, 12.5e3,2.5e3,'6-12 keV',chars=0.7,/device,orien=90,color=dct[1]

    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],ryr,lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],ryr,lines=2,color=0,thick=2
    endfor

    device,/close
    set_plot, mydevice

  endif

end