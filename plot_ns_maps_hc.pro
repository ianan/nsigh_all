pro plot_ns_maps_hc,obs_id=obs_id,maindir=maindir,nsdir=nsdir

  ; Plot the individual maps and also a combined one
  ;
  ; Work in progress version - only a the most recent observations
  ;
  ; Options
  ; obs_id     - Which NuSTAR observations (default =1)
  ; maindir    - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir      - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ;
  ; 30-Aug-2016 IGH - Created
  ; 18-Nov-2016 IGH - Includes more data (from HEASARC) and changes location of output files
  ; 22-Mar-2017 IGH - Added in Mar 2017 data
  ; 25-Sep-2017 IGH - Updated with Aug 2017 data
  ; 26-Sep-2017 IGH - Updated with Sep 2017 data
  ; 18-Oct-2017 IGH - Updated with Oct 2017 data
  ; 03-Jun-2018 IGH - Updated wtih May 2018 data
  ; 10-Sep-2018 IGH - Updated with Sep 2018 data
  ; 29-Sep-2018 IGH - Updated with Sep 2018 data, QS 28th
  ;                     Removed auto scaling to 1e-4 and 1e-1
  ; 30-Sep-2018 IGH - Increased gaussian sr for Sep 2018 QS data
  ; 06-Feb-2019 IGH - Updated for heasarc version of Jan data
  ; 20-Apr-2019 IGH - Updated with Apr 2019 data
  ;                     Made sure sr=2 by default (uses bigger value for QS obs)
  ; 10-May-2019 IGH - Updated with Apr 2019 QS data
  ; 16-Jul-2019 IGH - Added in Jul 2019 QS data
  ; 14-Feb-2020 IGH - Added in Jan 2020 data
  ; 11-Mar-2020 IGH - Updated for Feb 2020
  ; 02-Jul-2020 IGH - Updated for Jun 2020 data
  ; 05-Oct-2020 IGH - Updated for Oct 2020, tweak plotting for QS FD mosaic (via qsmos flag)
  ; 22-Feb-2021 IGH - Added in Jan 2021 data
  ; 26-May-2021 IGH - Added in Apr/May 2021 data
  ; 26-Jul-2021 IGH - Added in 20 Jul 2021 data
  ; 15-Aug-2021 IGH - Added in 30 Jul 2021 data
  ; 30-Jan-2022 IGH - Added in Nov 2021 data
  ; 28-Mar-2022 IGH - Added in Feb 2022 data
  ; 16-Jun-2022 IGH - Added in Jun 2022 data
  ; 03-Oct-2022 IGH - Added in Sep 2022 data
  ; 02-Jan-2023 IGH - Added in Dec 2023 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  clearplot
  if (n_elements(obs_id) ne 1) then obs_id=31
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129','20200221','20200606','20200912',$
    '20210108','20210429','20210720','20210730','20211117',$
    '20220224','20220603','20220906',$
    '20221209']

  obsname=dobs[obs_id]
  if (n_elements(maindir) ne 1) then maindir='~/data/heasarc_nustar/';'~/data/ns_data/'

  if (obsname eq '20180529') then nsdir='obs13' else nsdir='ns_'+obsname
  if (obsname eq '20180907') then nsdir='obs14/quicklook' ;else nsdir='ns_'+obsname
  if (obsname eq '20180928') then nsdir='obs15/quicklook' ;else nsdir='ns_'+obsname
  if (obsname eq '20190112') then begin
    nsdir='ns_20190112';'obs16/quicklook'
    maindir='~/data/heasarc_nustar/'
  endif
  if (obsname eq '20190412') then nsdir='obs17' ;else nsdir='ns_'+obsname
  if (obsname eq '20200606') then begin
    nsdir='ns_20200606'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20200912') then begin
    nsdir='ns_20200912'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20210108') then begin
    nsdir='ns_20210108'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20210429') then begin
    nsdir='ns_20210429'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20210720') then begin
    nsdir='ns_20210720'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20210730') then begin
    nsdir='ns_20210730'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20211117') then begin
    nsdir='ns_20211117'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif  
  if (obsname eq '20220224') then begin
    nsdir='ns_20220224'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20220603') then begin
    nsdir='ns_20220603'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20220906') then begin
    nsdir='ns_20220906'
  endif
  if (obsname eq '20221209') then begin
    nsdir='ns_20221209'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  ; control color scaling on final maps by obsid
  if (obs_id eq 8 or obs_id eq 13 or obs_id eq 12 or obs_id eq 11 or $
    obs_id eq 10 or obs_id eq 19 or obs_id eq 23 or obs_id eq 24 or obs_id eq 27 or obs_id eq 28) then begin
    dnl=1e-4
    dmx=1e1
  endif else begin
    dnl=1e-3
    dmx=1e1
  endelse

  ; For the QS Mosaic data
  if (obs_id eq 14 or obs_id eq 15 or obs_id eq 17 or obs_id eq 18 or $
    obs_id eq 20 or obs_id eq 22) then begin
    dnl=1e-5
    dmx=1e-2
  endif
  
  if (obs_id eq 26) then begin
    dnl=1e-4
    dmx=1e0
  endif
    
  
  ;--------------------------------------------

  ffa=file_search(maindir+nsdir,'*FPM*.fits')
  nf=n_elements(ffa)
  
  sr=2
  if (obs_id eq 14) then sr=8
  if (obs_id eq 15) then sr=8

  @post_outset
  !p.multi=0

  loadct,74,/silent
  reverse_ct
  tvlct,r,g,b,/get
  r[0]=0
  g[0]=0
  b[0]=0
  r[1]=255
  g[1]=255
  b[1]=255
  tvlct,r,g,b

  plim=1500
  xr=[-1,1]*plim
  yr=[-1,1]*plim

  for i=0, nf-1 do begin
    
    ; Load in the map
    fits2map,ffa[i],mm

    ;    need to setup things a bit differently for the QS combined mosaics
    ;    just manually identify they and send to a different plotting option
    fitsname=(strsplit(ffa[i],'/',/extract))[-1]

    ; Extra filter to change binning and scale for the proper QS full disk mosaics
    qsmos=0

    if (obs_id eq 20 and (fitsname eq 'maps_ns_20200221_1002_FPMA.fits' or fitsname eq 'maps_ns_20200221_1002_FPMB.fits' or $
      fitsname eq 'maps_ns_20200221_1001_FPMA.fits' or fitsname eq 'maps_ns_20200221_1001_FPMB.fits' )) then qsmos=1

    if (obs_id eq 22 and (fitsname eq 'maps_ns_20200912_1001_FPMA.fits' or fitsname eq 'maps_ns_20200912_1001_FPMB.fits')) then qsmos=1

    if (qsmos eq 1) then begin
      newx=n_elements(mm.data[*,0])/16.
      newy=n_elements(mm.data[0,*])/16.
      dnl=1e-5
      dmx=1e-2
      mms=rebin_map(mm,newx,newy)
    endif else begin
      mms=mm
      mms.data=gauss_smooth(mms.data,sr)
    endelse

    idbp=where(mms.data eq 0,nidbp)
    if (nidbp gt 0) then mms.data[idbp]=1e-12

    ; modify the scaling on the fly?
    ; if (mean(mms.data) lt 1e-2) then dnl=1e-4 else dnl=1e-3

    ftemp=strsplit(ffa[i],'/',/extract)
    ftemp=ftemp[n_elements(ftemp)-1]
    fname=(strsplit(ftemp,'.',/extract))[0]

    set_plot,'ps'
    device, /encapsulated, /color, / isolatin1,/inches, $
      bits=8, xsize=4.5, ysize=4.5,file='maps/maps_'+obsname+'/'+fname+'.eps'

    plot_map,mms,/log,dmin=dnl,dmax=dmx,position=[0.17,0.13,0.87,0.83],$
      title=mms.id,grid_sp=30,xrange=xr,yrange=yr,$
      gcolor=0,bot=1,chars=0.8,xtitle='x [arcsec]',ytitle='y [arcsec]'

    plot_map_cb_igh,alog10([dnl,dmx]),position=[0.15,0.96,0.85,0.98],color=0,chars=0.8,$
      cb_title='NuSTAR [log!D10!N count s!U-1!N]',bottom=1,format='(f4.1)'

    if (obs_id eq 14 or obs_id eq 15) then xyouts,100,100,'gsr'+string(sr,format='(i1)'),/device,chars=0.5
    device,/close
    set_plot, mydevice

  endfor

end