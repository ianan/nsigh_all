pro make_ns_maps_comb_hc,obs_id=obs_id,maindir=maindir,nsdir=nsdir,fpm=fpm

  ; Code to make a nice map of the NuSTAR emission >2.5keV with specified combinations per observation
  ; Theses maps are over all CHUs but only grade 0
  ; No pointing corrections have been applied
  ;
  ; If observation simple enough just one combined map produce, but sometimes need more than one
  ; i.e. if mosiac and then limb pointing (so get two combined maps)
  ;
  ; Work in progress version - only a the most recent observations
  ;
  ; Options
  ; obs_id       - Which NuSTAR observations (default =1)
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ; fpm           - A or B (default 'A')
  ;
  ;
  ; 05-Sep-2016 IGH - Created
  ; 23-Sep-2016 IGH - Added more info about what code is doing
  ; 18-Nov-2016 IGH - Includes more data (from HEASARC) and changes location of output files
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obs_id) ne 1) then obs_id=7
  dobs=['20140910','20141101','20141211','20150429','20150901','20160219','20160422','20160726']

  obsname=dobs[obs_id]
  nsdir='ns_'+obsname

  if (n_elements(maindir) ne 1) then maindir='~/data/heasarc_nustar/
  
  if (n_elements(fpm) ne 1) then fpm='A'
  
  ; What is the minimum energy we want for the image?
  min_eng=2.5

  ;-------------------------------------------

  evtaf=file_search(maindir+nsdir,'/*'+fpm+'06_cl_sunpos.evt')

  nf=n_elements(evtaf)
  ns_ids=strarr(nf)

  for i=0,nf-1 do begin
    stemp=strsplit(evtaf[i],'/',/extract)
    stemp=stemp[n_elements(stemp)-1]
    ns_ids[i]=strmid(stemp,0,strpos(stemp,fpm+'06'))
  endfor

  ; Now be more selective about how we combine the maps together

  if (obs_id eq 0) then begin
    ; OK to combine all
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 1) then begin
    ; Default of 1 is NP then limb pointing
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second for the 4 limb ones
  gd_ids[where(ns_ids eq 'nu20012001001' or ns_ids eq 'nu20012002001' or $
    ns_ids eq 'nu20012003001' or ns_ids eq 'nu20012004002')]=2
  endif


  if (obs_id eq 2) then begin
    ; OK to combine all
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 3) then begin
    ; Default of 1 is all the mosaic tiles
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second mosaic do this
    iidds=intarr(nf)
    for ii=0,nf-1 do iidds[ii]=strmid(evtaf[ii],strpos(evtaf[ii],'nu2011')+8,2)
    gd_ids[where(iidds ge 30)]=2
  endif

  if (obs_id eq 4) then begin
    ; Default of 1 is all the mosaic tiles
    gd_ids=intarr(n_elements(evtaf))+1
    ; but remove"nu20110105001" as very short duration and noisy before no nu20110106001
    gd_ids[where(ns_ids eq 'nu20110105001')]=0
    ; then 2 is the limb pointing on the 1st
    gd_ids[where(ns_ids eq 'nu20102004001' or ns_ids eq 'nu20102003001' or ns_ids eq 'nu20102002001')]=2
    ; then 3 is the limb pointing on the 2nd
    gd_ids[where(ns_ids eq 'nu20102005001' or ns_ids eq 'nu20102006001' or $
      ns_ids eq 'nu20102007001' or ns_ids eq 'nu20102008001')]=3
  endif

  if (obs_id eq 5) then begin
    ; OK to combine all
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 6) then begin
    ; OK to combine all, just removing nu20101016001 second disk AR look is misaligned with earlier one
    gd_ids=intarr(n_elements(evtaf))+1
    gd_ids[where(ns_ids eq 'nu20101016001')]=0
  endif

  if (obs_id eq 7) then begin
    ; OK to combine all, just removing nu20201007001 as slew with little useful data (?)
    gd_ids=intarr(n_elements(evtaf))+1
    gd_ids[where(ns_ids eq 'nu20201002001')]=0
  endif

  ; How many combined maps do we need to make?
  nmaps=n_elements(uniq(gd_ids[where(gd_ids ge 1)]))

  for m=0,nmaps-1 do begin
    temp_id=where(gd_ids eq m+1)
    evtaf_temp=evtaf[temp_id]
    nf=n_elements(evtaf_temp)

    for i=0,nf-1 do begin
      evta = mrdfits(evtaf_temp[i], 1,evtah,/silent)
      engs=1.6+0.04*evta.pi
      gd=where(engs ge min_eng and evta.grade eq 0)
      evta=evta[gd]

      t1=anytim(min(evta.time)+anytim('01-Jan-2010'),/yoh,/trunc)
      t2=anytim(max(evta.time)+anytim('01-Jan-2010'),/yoh,/trunc)

      effexp=sxpar(evtah,'LIVETIME')
      ontime=sxpar(evtah,'ONTIME')
      lvt=effexp/ontime

      fpid=strcompress(sxpar(evtah,'INSTRUME'),/rem)

      ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ; Setup the pixel and binning sizes
      ; Get the same values if using evtah or evtbh
      ttype = where(stregex(evtah, "TTYPE", /boolean))
      xt = where(stregex(evtah[ttype], 'X', /boolean))
      xpos = (strsplit( (strsplit(evtah[ttype[max(xt)]], ' ', /extract))[0], 'E', /extract))[1]
      npix = sxpar(evtah, 'TLMAX'+xpos)
      pix_size = abs(sxpar(evtah,'TCDLT'+xpos))

      xc=0
      yc=0

      centerx = round(xc / pix_size) + npix * 0.5
      centery = round(yc / pix_size) + npix * 0.5
      im_size = 1400. / pix_size
      im_width = round(im_size * 2.)

      pixinds = evta.x + evta.y * npix
      im_hist = histogram(pixinds, min = 0, max = npix*npix-1, binsize = 1)
      im = reform(im_hist, npix, npix)
      ims= im[(centerx-im_width):(centerx+im_width-1), (centery-im_width):(centery+im_width-1)]
      npp=n_elements(ims[0,*])

      ; Only save a map out of the data is there
      ids00=where(total(ims,1) gt 0,nids00)
      if (nids00 gt 2) then begin
        ; save out the total map
        if (i eq 0) then begin
          ims_tot=ims/effexp
          tstart=t1
        endif else begin
          ims_tot=ims_tot+ims/effexp
          tend=t2
        endelse

      endif
    endfor
    ang = pb0r(tstart,/arcsec,l0=l0)
    ;Output the total map
    maptot=make_map(ims_tot,dx=pix_size,dy=pix_size,xc=xc,yc=yc,$
      time=tstart,id=fpid+' '+tstart+' to '+$
      anytim(tend,/yoh,/trunc,/time),$
      xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])

    map2fits,maptot,maindir+nsdir+'/maps_'+nsdir+'_'+string(1000+m,format='(i4)')+'_'+fpid+'.fits'


  endfor

end