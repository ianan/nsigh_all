pro make_ns_maps, obsname=obsname,maindir=maindir,nsdir=nsdir

  ; Code to make an map of the NuSTAR emission >2.5keV for each of the NuSTAR data files.
  ; The map is over all CHUs but only grade 0
  ; Also output a nice summary csv of each observation
  ;
  ; Work in progress version - only a the most recent observations
  ;
  ; Options
  ; obsname       - Which NuSTAR observations (default ='201409')
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ;
  ;
  ; 29-Aug-2016 IGH - Created
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obsname) ne 1) then obsname='201607'
  if (n_elements(maindir) ne 1) then maindir='~/data/ns_data/


  ; What is the minimum energy we want for the image?
  min_eng=2.5

  ;-------------------------------------------

  if (obsname eq '201509') then begin
    nsdir='obs5/'
    evtaf=file_search(maindir+nsdir,'*A06_cl_sunpos.evt')
  endif

  if (obsname eq '201602') then begin
    nsdir='obs6/'
    evtaf=file_search(maindir+nsdir,'*A06_cl_sunpos.evt')
  endif

  if (obsname eq '201604') then begin
    nsdir='obs7/'
    evtaf=file_search(maindir+nsdir,'*A06_cl_sunpos.evt')
  endif

  if (obsname eq '201607') then begin
    nsdir='obs8/'
    evtaf=file_search(maindir+nsdir,'*A06_cl_sunpos.evt')
  endif

  nf=n_elements(evtaf)
  ns_ids=strarr(nf)
  t1s=strarr(nf)
  t2s=strarr(nf)
  xcs=fltarr(nf)
  ycs=fltarr(nf)
  durs=fltarr(nf)
  ontime=fltarr(nf)
  lvtp=fltarr(nf)

  for i=0,nf-1 do begin
    stemp=strsplit(evtaf[i],'/',/extract)
    stemp=stemp[n_elements(stemp)-1]
    ns_ids[i]=strmid(stemp,0,strpos(stemp,'A06'))
  endfor

  ;----------------------------------------
  ; Load in the data
  for i=0, nf-1 do begin
    evta = mrdfits(evtaf[i], 1,evtah,/silent)
    engs=1.6+0.04*evta.pi
    gd=where(engs ge min_eng and evta.grade eq 0)
    evta=evta[gd]

    t1=anytim(min(evta.time)+anytim('01-Jan-2010'),/yoh,/trunc)
    t2=anytim(max(evta.time)+anytim('01-Jan-2010'),/yoh,/trunc)

    livetime=sxpar(evtah,'LIVETIME')
    dur=sxpar(evtah,'ONTIME')
    lvt=livetime/dur

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
    im_size = 1037. / pix_size
    im_width = round(im_size * 2.)
    ims=intarr(1688,1688)

    pixinds = evta.x + evta.y * npix
    im_hist = histogram(pixinds, min = 0, max = npix*npix-1, binsize = 1)
    im = reform(im_hist, npix, npix)
    ims= im[(centerx-im_width):(centerx+im_width-1), (centery-im_width):(centery+im_width-1)]
    npp=n_elements(ims[0,*])

    t1s[i]=t1
    t2s[i]=t2

    ; Only save a map out of the data is there
    ids00=where(total(ims,1) gt 0,nids00)
    if (nids00 gt 2) then begin
      ; Just want the zoomed in region
      id0=median(where(total(ims,1) gt 0))
      id1=median(where(total(ims,2) gt 0))

      subx=[-250,250]+id1
      suby=[-250,250]+id0
      zims=ims[subx[0]:subx[1],suby[0]:suby[1]]

      pxs=pix_size
      x0=xc-npp*0.5*pxs+pxs*subx[0]
      y0=yc-npp*0.5*pxs+pxs*suby[0]

      newxc=x0+0.5*n_elements(zims[*,0])*pxs
      newyc=y0+0.5*n_elements(zims[0,*])*pxs

      ang = pb0r(t1,/arcsec,l0=l0)

      mapa=make_map(zims/livetime,dx=pxs,dy=pxs,xc=newxc,yc=newyc,$
        time=t1,dur=livetime,id='FPMA '+t1+' to '+$
        anytim(t2,/yoh,/trunc,/time)+' ('+string(lvt*100,format='(f5.2)')+'%)',$
        xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])

      map2fits,mapa,maindir+nsdir+'maps_'+break_time(t1)+'_'+ns_ids[i]+'_FPMA.fits'
      loadct,39,/silent
      plot_map,mapa,/log,/limb,grid_spacing=25,title=mapa.id

      xcs[i]=newxc
      ycs[i]=newyc
      durs[i]=livetime
      ontime[i]=dur
      lvtp[i]=lvt*100.

;      ; save out the total map
;      if (i eq 0) then begin
;        ims_tot=ims/livetime
;        tstart=t1
;      endif else begin
;        ims_tot=ims_tot+ims/livetime
;        tend=t2
;      endelse

    endif

    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  endfor

  ; this has been replaced by make_ns_maps_comb.pro
  ;  ;Output the total map
  ;  maptot=make_map(ims_tot,dx=pxs,dy=pxs,xc=xc,yc=yc,$
  ;    time=tstart,id='FPMA '+tstart+' to '+$
  ;    anytim(tend,/yoh,/trunc,/time),$
  ;    xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])
  ;
  ;  map2fits,maptot,maindir+nsdir+'maps_'+(strsplit(nsdir,'/',/extract))[0]+'_FPMA.fits'

  ; Write out a nice summary file
  hdr=['NS ID','Start Time','End Time','On Time [s]','Duration [s]','Livetime [%]','X [S/C]','Y [S/C]']
  write_csv, 'info_files/'+(strsplit(nsdir,'/',/extract))[0]+'_info_FPMA.csv',ns_ids,t1s,t2s,ontime,durs,lvtp,xcs,ycs,header=hdr

  stop
end