pro plot_ns_maps_hc,obs_id=obs_id,maindir=maindir,nsdir=nsdir

  ; Plot the individual maps and also a combined one
  ;
  ; Work in progress version - only a the most recent observations
  ;
  ; Options
  ; obs_id       - Which NuSTAR observations (default =1)
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ;
  ;
  ; 30-Aug-2016 IGH - Created
  ; 18-Nov-2016 IGH - Includes more data (from HEASARC) and changes location of output files
  ; 22-Mar-2017 IGH - Added in Mar 2017 data
  ; 25-Sep-2017 IGH - Updated with Aug 2017 data
  ; 26-Sep-2017 IGH - Updated with Sep 2017 data
  ; 18-Oct-2017 IGH - Updated with Oct 2017 data
  ; 03-Jun-2018 IGH - Updated wtih May 2018 data
  ; 10-Sep-2018 IGH - Updated with Sep 2018 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  clearplot

  if (n_elements(obs_id) ne 1) then obs_id=13
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911',$
   '20171010','20180529','20180907']

  obsname=dobs[obs_id]
  if (obsname eq '20180529') then nsdir='obs13' else nsdir='ns_'+obsname
  if (obsname eq '20180907') then nsdir='obs14/quicklook' ;else nsdir='ns_'+obsname

  if (n_elements(maindir) ne 1) then maindir='~/data/ns_data/';~/data/heasarc_nustar/
  
  ; control color scaling on final maps by obsid
  if (obs_id eq 8) then begin
    dnl=1e-4
    dmx=1e1
  endif else begin
    dnl=1e-3
    dmx=1e1
  endelse

  ; What is the minimum energy we want for the image?
  min_eng=2.5

  ;--------------------------------------------

  ffa=file_search(maindir+nsdir,'*FPM*.fits')
  
  nf=n_elements(ffa)
  sr=2
  for i=0, nf-1 do begin
    fits2map,ffa[i],mm
    mms=mm
    mms.data=gauss_smooth(mms.data,sr)
    
    ; modify the scaling on the fly?
    if (mean(mms.data) lt 1e-2) then dnl=1e-4 else dnl=1e-3
   
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

    device,/close
    set_plot, mydevice

  endfor

end