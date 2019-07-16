pro plot_ns_sun_lc_rnm_ng, obsname=obsname,timer=timer,maindir=maindir,nsdir=nsdir

  ; Based on plot_ns_sun_lc_rnm.pro but when no GOES data available online ;(
  ; So just makes a single plot of NuSTAR livetime and CHU

  ; Script to generate overview time profiles of NuSTAR livetime, GOES and RHESSI flux
  ; The data it uses is either *.dat files in the dat_files directory or if those do not
  ; exist the code with generate these from a *local* copy of the NuSTAR data and *online* for GOES
  ; In reality the *.dat files should be there and you do not need the original NuSTAR data
  ; (or setup maindir, nsdir etc)

  ; Options
  ; obsname       - Which NuSTAR observations (default ='201409')
  ; timer         - Overal time range to plot (default, specified values per obs below)
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)

  ; 12-Jan-2019 - IGH   Added in Jan 2019 data
  ; 10-May-2019 - IGH   Added in April 2019 QS data
  ; 16-Jul-2019 - IGH   Added in Jul 2019 QS data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obsname) ne 1) then obsname='201907'
  if (n_elements(maindir) ne 1) then maindir='~/data/heasarc_nustar/';'~/data/ns_data/';
  ; Generate again the livetim and CHU files, even if they already exist
  if (n_elements(genagn) ne 1) then genagn=1

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;----------------------------------------
  ;-------------------------------------------
  if (obsname eq '20180928') then begin
    torbs=[['28-Sep-2018 '+['18:25:00','19:24:00']],$
      ['28-Sep-2018 '+['20:02:00','21:01:00']]]
    timer=['28-Sep-2018 17:45:00','28-Sep-2018 21:30:00']
    nsdir='ns_20180928/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.02,0.5]

  endif

  ;-------------------------------------------
  if (obsname eq '201901') then begin
    torbs=[['12-Jan-2019 '+['16:35:00','17:30:00']],$
      ['12-Jan-2019 '+['18:11:00','19:11:00']],$
      ['12-Jan-2019 '+['19:48:00','20:30:00']],$
      ['12-Jan-2019 '+['20:45:00','20:47:00']],$
      ['12-Jan-2019 '+['21:25:00','22:13:00']]]
    timer=['12-Jan-2019 16:00:00',' 12-Jan-2019 22:45:00']
    nsdir='ns_20190112/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.01,0.9]

  endif
  ;-------------------------------------------
  ;-------------------------------------------
  if (obsname eq '20190425') then begin
    torbs=[['25-Apr-2019 '+['22:11:00','23:10:00']],$
      ['25-Apr-2019 23:48:00','26-Apr-2019 00:47:00'],$
      ['26-Apr-2019 '+['01:25:00','02:24:00']],$
      ['26-Apr-2019 '+['03:01:00','04:00:00']]]
    timer=['25-Apr-2019 21:30:00',' 26-Apr-2019 04:30:00']
    nsdir='ns_20190425/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]

    ; GOES 15 changed on 18 Apr
    gyrl=[0.1,0.9]

  endif
  
  if (obsname eq '201907') then begin
    torbs=[['02-Jul-2019 '+['04:17:00','05:17:00']],$
      ['02-Jul-2019 '+['05:53:00','06:53:00']]]
    timer=['02-Jul-2019 04:00:00','02-Jul-2019 07:00:00']
    nsdir='ns_20190702/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.02,0.5]

  endif
  
  ;-------------------------------------------


  lv_yrange=[0.1,1.1]
  lv_ylog=0

  ;-------------------------------------------

  norbs=n_elements(torbs[0,*])
  ngaps=(size(dgtims))[2];n_elements(dgtims[0,*])
  ;-------------------------------------------
  ;-------------------------------------------

  @post_outset
  !p.thick=6
  loadct,0,/silent
  tube_line_colors

  ;-------------------------------------------
  ; Get the NuSTAR livetime if *.dat is not there
  nhk=n_elements(hkf)
  if (nhk gt 0) then begin
    hkfile='dat_files/ns_hk_ltc_'+obsname+'.dat'
    if (file_test(hkfile) eq 0 or genagn eq 1) then begin
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
  nch=n_elements(chuf)
  if (nch gt 0) then begin
    chufile='dat_files/ns_chu_ltc_'+obsname+'.dat'
    if (file_test(chufile) eq 0 or genagn eq 1) then begin
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


  endif else begin
    nhk=0
  endelse

  ;;-------------------------------------------
  ; Make a plot of NuSTAR livetime and CHUs
  !p.multi=[0,2,1]
  figname='figs/ns_ltc_chu_'+obsname+'.eps'

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=5, ysize=5,file=figname
  !p.charsize=1.0
  !p.thick=4
  utplot,timer,[1,1],yrange=lv_yrange,ytitle='NuSTAR Livetime',$;ytickf='exp1',$
    position=[0.14,0.55,0.95,0.99],xtit='',xtickf='(a1)',timer=timer,/nodata,ylog=lv_ylog

  if (nhk gt 0) then begin
    outplot,htime,hlive,thick=3,color=150
    for i=0, norbs-1 do begin
      outplot,[torbs[0,i],torbs[0,i]],[0,8],lines=2,color=0,thick=2
      outplot,[torbs[1,i],torbs[1,i]],[0,8],lines=2,color=0,thick=2
      gd1=where(anytim(htime) ge anytim(torbs[0,i]) and anytim(htime) le anytim(torbs[1,i]))
      outplot,htime[gd1],hlive[gd1],thick=3,color=3

    endfor
  endif

  ;  for i=0, ngaps-1 do begin
  ;    hgd1=where(anytim(htime) ge anytim(dgtims[0,i]) and anytim(htime) le anytim(dgtims[1,i]),nhgd1)
  ;    if (nhgd1 gt 1) then outplot,htime[hgd1],hlive[hgd1],color=200,thick=3
  ;  endfor

  xyouts, 12.5e3,7.5e3,'FPMA',chars=0.7,/device,orien=90,color=3

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
    timer=timer,position=[0.14,0.1,0.95,0.54],symsize=0.5,thick=2,/nodata

  outplot,chutime,newmask,psym=1,color=150  ,symsize=0.5,thick=2


  for i=0, norbs-1 do begin
    gd1=where(anytim(chutime) ge anytim(torbs[0,i]) and anytim(chutime) le anytim(torbs[1,i]))
    outplot,chutime[gd1],newmask[gd1],psym=1,color=0  ,symsize=0.5,thick=2
    outplot,[torbs[0,i],torbs[0,i]],[0,8],lines=2,color=0,thick=2
    outplot,[torbs[1,i],torbs[1,i]],[0,8],lines=2,color=0,thick=2
  endfor

  ;  for i=0, ngaps-1 do begin
  ;    cgd1=where(anytim(chutime) ge anytim(dgtims[0,i]) and anytim(chutime) le anytim(dgtims[1,i]),ncgd1)
  ;    if (ncgd1 gt 1) then outplot,chutime[cgd1],newmask[cgd1],color=200,thick=2,symsize=0.5,psym=1
  ;  endfor

  device,/close
  set_plot, mydevice



;  stop

end