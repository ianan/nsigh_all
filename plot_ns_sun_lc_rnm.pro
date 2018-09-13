pro plot_ns_sun_lc_rnm, obsname=obsname,timer=timer,goes=goes,gyr=gyr,gav=gav,$
  maindir=maindir,nsdir=nsdir,gesnlog=gesnlog,chudo=chudo,do_nustar=do_nustar

  ; Based on plot_ns_sun_lc.pro but for times with no RHESSI :( which for our case is mostly 2018+

  ; Script to generate overview time profiles of NuSTAR livetime, GOES and RHESSI flux
  ; The data it uses is either *.dat files in the dat_files directory or if those do not
  ; exist the code with generate these from a *local* copy of the NuSTAR data and *online* for GOES
  ; In reality the *.dat files should be there and you don't need the original NuSTAR data
  ; (or setup maindir, nsdir etc)

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
  ; do_nustar     - Process the NuSTAR data (default yes) - useful for just after an obs with no_nustar=0 to get GOES/RHESSI etc

  ; example of usage
  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  ; plot_ns_sun_lc, obsname='201409',gav=5,/goes

  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  ; plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo

  ; Note that for muliple day campaigns (Sep 2015, Sep 2017) the default is to do it per day instead of whole campaign
  ; so obsname='201509_01' or obsname='201709_11'

  ; 11-Sep-2018 IGH   Started based on plot_ns_sun_lc.pro
  ;                   Removed RHESSI data get and plotting
  ;                   Added GOES 14, as well as GOES 15
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obsname) ne 1) then obsname='201809_10'
  if (n_elements(maindir) ne 1) then maindir='~/data/ns_data/';'~/data/heasarc_nustar/';'~/data/ns_data/
  if (n_elements(do_nustar) ne 1) then do_nustar=1

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ;-------------------------------------------
  ;-------------------------------------------
  if (obsname eq '201805') then begin
    torbs=[['29-May-2018 '+['15:55:30','16:55:50']],$
      ['29-May-2018 '+['17:32:30','18:33:30']],$
      ['29-May-2018 '+['19:08:50','20:09:10']],$
      ['29-May-2018 '+['20:45:30','21:49:00']],$
      ['29-May-2018 '+['22:22:20','23:22:00']]]
    timer=['29-May-2018 15:30:00',' 29-May-2018 23:30:00']
    nsdir='obs13/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,1.1]

  endif

  ;-------------------------------------------
  if (obsname eq '201809_07') then begin
    torbs=[['07-Sep-2018 '+['14:57:00','15:57:00']],$
      ['07-Sep-2018 '+['16:34:00','17:33:00']],$
      ['07-Sep-2018 '+['18:11:00','19:03:00']]]
    timer=['07-Sep-2018 14:30:00',' 07-Sep-2018 19:30:00']
    nsdir='obs14/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.01,0.5]

  endif

  ;-------------------------------------------
  if (obsname eq '201809_09') then begin
    torbs=[['09-Sep-2018 '+['08:50:00','09:49:00']],$
      ['09-Sep-2018 '+['10:27:00','11:26:00']],$
      ['09-Sep-2018 '+['12:04:00','13:03:00']]]
    timer=['09-Sep-2018 08:00:00','09-Sep-2018 13:30:00']
    nsdir='obs14/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]

  endif

  ;-------------------------------------------
  if (obsname eq '201809_10') then begin
    torbs=[['10-Sep-2018 '+['13:50:30','14:49:00']],$
      ['10-Sep-2018 '+['15:27:00','16:26:00']],$
      ['10-Sep-2018 '+['17:04:00','17:53:00']]]
    timer=['10-Sep-2018 13:30:00','10-Sep-2018 18:30:00']
    nsdir='obs14/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.02,0.5]

  endif

  ;-------------------------------------------

  norbs=n_elements(torbs[0,*])
  ngaps=(size(dgtims))[2];n_elements(dgtims[0,*])
  ;-------------------------------------------
  ;-------------------------------------------
  ; If no GOES *.dat file then make one
  gfile='dat_files/goes1415_ltc_'+obsname+'.dat'
  if (file_test(gfile) eq 0) then begin
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

    save,file=gfile,gtime14,glow14,ghigh14,gtime15,glow15,ghigh15
  endif else begin
    restore,file=gfile
  endelse

  ;-------------------------------------------
  ; Need to average the GOES data?
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

    utplot,gtime15,glow15,ytitle='!3GOES Flux [W m!U-2!N]',chars=1.2,$
      /ylog,/nodata,yrange=gyr,timer=timer
    outplot,gtime14,glow14,color=150,thick=3
    outplot,gtime14,ghigh14,color=150,thick=3
    outplot,gtime15,glow15,color=150,thick=6
    outplot,gtime15,ghigh15,color=150,thick=6

    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyr,lines=0,color=0,thick=3
      outplot,[torbs[1,i],torbs[1,i]],gyr,lines=0,color=0,thick=3

      gd1=where(anytim(gtime14) ge anytim(torbs[0,i]) and anytim(gtime14) le anytim(torbs[1,i]))
      outplot,gtime14[gd1],glow14[gd1],color=4,thick=3
      outplot,gtime14[gd1],ghigh14[gd1],color=8,thick=3

      gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]))
      outplot,gtime15[gd1],glow15[gd1],color=1,thick=6
      outplot,gtime15[gd1],ghigh15[gd1],color=2,thick=6

      ;      outplot,torbs[*,i],0.2*gyr[1]*[1,1],lines=0,thick=10
    endfor

    for i=0, ngaps-1 do begin
      hgd1=where(anytim(gtime15) ge anytim(dgtims[0,i]) and anytim(gtime15) le anytim(dgtims[1,i]),nhgd1)
      if (nhgd1 gt 1) then outplot,gtime15[hgd1],glow15[hgd1],color=200,thick=6
      if (nhgd1 gt 1) then outplot,gtime15[hgd1],ghigh15[hgd1],color=200,thick=6
    endfor

    evt_grid,replicate(gtime15[0],5),labpos=1.2*[1e-8,1e-7,1e-6,1e-5,1e-4],labels=['A','B','C','M','X'],$
      /data,labsize=1.5,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,[gtime15[0],gtime15[n_elements(gtime15)-1]],10d^(-8+i)*[1,1],color=150,lines=2,thick=4
    xyouts, 0.32e4,1.2e4,'15: 1-8 '+string(197b),/device,chars=1.25,color=1
    xyouts, 0.58e4,1.2e4,'0.5-4 '+string(197b),/device,chars=1.25,color=2

    xyouts, 0.9e4,1.2e4,'14: 1-8 '+string(197b),/device,chars=1.25,color=4
    xyouts, 1.16e4,1.2e4,'0.5-4 '+string(197b),/device,chars=1.25,color=8

    device,/close
    set_plot, mydevice
  endif

  if keyword_set(do_nustar) then begin

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

  endif else begin
    nhk=0
  endelse

  ;-------------------------------------------
  ; Make a plot of NuSTAR livetime and GOES fluxes
  !p.multi=[0,2,1]
  if keyword_set(gesnlog) then figname='figs/ns_ltc_goesnl_nsl_'+obsname+'.eps' else $
    figname='figs/ns_ltc_goes_nsl_'+obsname+'.eps'
  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=5, ysize=5,file=figname
  !p.charsize=1.0
  !p.thick=4
  utplot,timer,[1,1],/ylog,yrange=[1e-3,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
    position=[0.14,0.55,0.95,0.99],xtit='',xtickf='(a1)',timer=timer,/nodata

  if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3

  for i=0, ngaps-1 do begin
    hgd1=where(anytim(htime) ge anytim(dgtims[0,i]) and anytim(htime) le anytim(dgtims[1,i]),nhgd1)
    if (nhgd1 gt 1) then outplot,htime[hgd1],hlive[hgd1],color=200,thick=3
  endfor

  xyouts, 12.5e3,7.5e3,'FPMA',chars=0.7,/device,orien=90,color=3

  ; Want ylog=0 for the GOES panel?
  if Keyword_set(gesnlog) then begin

    utplot,gtime15,glow15,ytitle='!3GOES Flux [x10!u-7!N W m!U-2!N]',$
      /nodata,yrange=gyrl,timer=timer,position=[0.14,0.1,0.95,0.54]
    outplot,gtime14,glow14*1d7,color=150,thick=2
    outplot,gtime15,glow15*1d7,color=150,thick=4

    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2

      gd1=where(anytim(gtime14) ge anytim(torbs[0,i]) and anytim(gtime14) le anytim(torbs[1,i]),ngd1)
      if (ngd1 gt 1) then outplot,gtime14[gd1],glow14[gd1]*1d7,color=4,thick=2

      gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]),ngd1)
      if (ngd1 gt 1) then outplot,gtime15[gd1],glow15[gd1]*1d7,color=1,thick=4
    endfor

    for i=0, ngaps-1 do begin
      hgd1=where(anytim(gtime15) ge anytim(dgtims[0,i]) and anytim(gtime15) le anytim(dgtims[1,i]),nhgd1)
      if (nhgd1 gt 1) then outplot,gtime15[hgd1],glow15[hgd1]*1d7,color=200,thick=4
    endfor

    xyouts, 12.5e3,1.5e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
    xyouts, 12.5e3,3.0e3,'14: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=4


  endif else begin
    utplot,gtime15,glow15,ytitle='!3GOES Flux [W m!U-2!N]',$
      /ylog,/nodata,yrange=gyr,timer=timer,position=[0.14,0.1,0.95,0.54]
    outplot,gtime15,glow15,color=150,thick=4
    outplot,gtime15,ghigh15,color=150,thick=4

    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],gyr,lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],gyr,lines=2,color=0,thick=2

      gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]))
      outplot,gtime15[gd1],glow15[gd1],color=1,thick=4
      outplot,gtime15[gd1],ghigh15[gd1],color=2,thick=4
    endfor

    for i=0, ngaps-1 do begin
      hgd1=where(anytim(gtime15) ge anytim(dgtims[0,i]) and anytim(gtime15) le anytim(dgtims[1,i]),nhgd1)
      if (nhgd1 gt 1) then outplot,gtime15[hgd1],glow15[hgd1],color=200,thick=4
      if (nhgd1 gt 1) then outplot,gtime15[hgd1],ghigh15[hgd1],color=200,thick=4
    endfor

    evt_grid,replicate(timer[0],4),labpos=1.2*[1e-8,1e-7,1e-6,1e-5],labels=['A','B','C','M'],$
      /data,labsize=0.7,/labonly,/noarrow,align=0,labcolor=150
    for i=0, 4 do outplot,[gtime15[0],gtime15[n_elements(gtime15)-1]],10d^(-8+i)*[1,1],color=150,lines=1,thick=2

    xyouts, 12.5e3,1.5e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
    xyouts, 12.5e3,3.0e3,'0.5-4 '+string(197b),chars=0.7,/device,orien=90,color=2

  endelse

  device,/close
  set_plot, mydevice

  ;-------------------------------------------
  ; Make a plot of NuSTAR livetime, CHU state and GOES
  if keyword_Set(chudo) then begin

    !p.multi=[0,3,1]
    if keyword_set(gesnlog) then figname='figs/ns_ltc_chu_goesnl_nsl_'+obsname+'.eps' else $
      figname='figs/ns_ltc_chu_goes_nsl_'+obsname+'.eps'
    set_plot,'ps'
    device, /encapsulated, /color, /isolatin1,/inches, $
      bits=8, xsize=5, ysize=5,file=figname
    !p.charsize=1.5
    !p.thick=4
    utplot,timer,[1,1],/ylog,yrange=[1e-3,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
      position=[0.12,0.64,0.95,0.95],xtit='',xtickf='(a1)',timer=timer,/nodata

    if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3

    for i=0, ngaps-1 do begin
      hgd1=where(anytim(htime) ge anytim(dgtims[0,i]) and anytim(htime) le anytim(dgtims[1,i]),nhgd1)
      if (nhgd1 gt 1) then outplot,htime[hgd1],hlive[hgd1],color=200,thick=3
    endfor

    xyouts, 12.5e3,8.5e3,'FPMA',chars=0.7,/device,orien=90,color=3

    ; Set up the y labelling
    ;; mask = 1, chu1 only
    ;; mask = 4, chu2 only
    ;; mask = 9, chu3 only
    ;; mask = 5, chu12
    ;; mask = 10 chu13
    ;; mask = 13 chu23
    ;; mask = 14 chu123

    ; Change the KKM mask setup into something a bit easier to plot
    ; Make deafult value out of range of real values
    newmask=intarr(n_elements(chumask))-5
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
      timer=timer,position=[0.12,0.36,0.95,0.63],symsize=0.5,xtit='',xtickf='(a1)',thick=2

    for i=0, ngaps-1 do begin
      cgd1=where(anytim(chutime) ge anytim(dgtims[0,i]) and anytim(chutime) le anytim(dgtims[1,i]),ncgd1)
      if (ncgd1 gt 1) then outplot,chutime[cgd1],newmask[cgd1],color=200,thick=2,symsize=0.5,psym=1
    endfor

    ; Want ylog=0 for the GOES panel?
    if Keyword_set(gesnlog) then begin

      utplot,gtime15,glow15,ytitle='!3GOES [x10!u-7!N W m!U-2!N]',$
        /nodata,yrange=gyrl,timer=timer,position=[0.12,0.08,0.95,0.35]
      outplot,gtime14,glow14*1d7,color=150,thick=2
      outplot,gtime15,glow15*1d7,color=150,thick=4

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2
        gd1=where(anytim(gtime14) ge anytim(torbs[0,i]) and anytim(gtime14) le anytim(torbs[1,i]),ngd1)
        if (ngd1 gt 1) then outplot,gtime14[gd1],glow14[gd1]*1d7,color=4,thick=2
        
        gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]),ngd1)
        if (ngd1 gt 1) then outplot,gtime15[gd1],glow15[gd1]*1d7,color=1,thick=4
      endfor

      for i=0, ngaps-1 do begin
        hgd1=where(anytim(gtime15) ge anytim(dgtims[0,i]) and anytim(gtime15) le anytim(dgtims[1,i]),nhgd1)
        if (nhgd1 gt 1) then outplot,gtime15[hgd1],glow15[hgd1]*1d7,color=200,thick=4
      endfor

      xyouts, 12.5e3,1.e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
      xyouts, 12.5e3,3.0e3,'14: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=4

    endif else begin
      utplot,gtime15,glow15,ytitle='!3GOES [W m!U-2!N]',$
        /ylog,/nodata,yrange=gyr,timer=timer,position=[0.12,0.08,0.95,0.35]
      outplot,gtime15,glow15,color=150,thick=4
      outplot,gtime15,ghigh15,color=150,thick=4

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyr,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyr,lines=2,color=0,thick=2

        gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]))
        outplot,gtime15[gd1],glow15[gd1],color=1,thick=4
        outplot,gtime15[gd1],ghigh15[gd1],color=2,thick=4
      endfor

      for i=0, ngaps-1 do begin
        hgd1=where(anytim(gtime15) ge anytim(dgtims[0,i]) and anytim(gtime15) le anytim(dgtims[1,i]),nhgd1)
        if (nhgd1 gt 1) then outplot,gtime15[hgd1],glow15[hgd1],color=200,thick=4
        if (nhgd1 gt 1) then outplot,gtime15[hgd1],ghigh15[hgd1],color=200,thick=4
      endfor

      evt_grid,replicate(timer[0],4),labpos=1.2*[1e-8,1e-7,1e-6,1e-5],labels=['A','B','C','M'],$
        /data,labsize=0.7,/labonly,/noarrow,align=0,labcolor=150
      for i=0, 4 do outplot,[gtime15[0],gtime15[n_elements(gtime15)-1]],10d^(-8+i)*[1,1],color=150,lines=1,thick=2

      xyouts, 12.5e3,1.e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
      xyouts, 12.5e3,2.5e3,'0.5-4 '+string(197b),chars=0.7,/device,orien=90,color=2

    endelse

    device,/close
    set_plot, mydevice

  endif

end