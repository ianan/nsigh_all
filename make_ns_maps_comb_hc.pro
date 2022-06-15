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
  ; 22-Mar-2017 IGH - Updated with Mar 2017 data
  ; 25-Sep-2017 IGH - Updated with Aug 2017 data
  ; 26-Sep-2017 IGH - Updated with Sep 2017 data
  ; 18-Oct-2017 IGH - Updated with Oct 2017 data
  ; 03-Jun-2018 IGH - Updated wtih May 2018 data
  ; 10-Sep-2018 IGH - Updated with Sep 2018 data
  ; 29-Sep-2018 IGH - Updated with Sep 2018 data, QS 28th
  ; 06-Feb-2019 IGH - Updated for heasarc version of Jan data
  ; 20-Apr-2019 IGH - Updated with Apr 2019 data
  ; 16-Jul-2019 IGH - Added in Jul 2019 QS data
  ; 14-Feb-2020 IGH - Added in Jan 2020 data
  ; 11-Mar-2020 IGH - Updated for Feb 2020
  ; 02-Jul-2020 IGH - Updated for Jun 2020 data
  ; 05-Oct-2020 IGH - Updated for Oct 2020
  ; 22-Feb-2021 IGH - Added in Jan 2021 data
  ; 26-May-2021 IGH - Added in Apr/May 2021 data
  ; 26-Jul-2021 IGH - Added in 20 Jul 2021 data
  ; 15-Aug-2021 IGH - Added in 30 Jul 2021 data
  ; 30-Jan-2022 IGH - Added in Nov 2021 data
  ; 28-Mar-2022 IGH - Added in Feb 2022 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  clearplot
  if (n_elements(obs_id) ne 1) then obs_id=28
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129','20200221','20200606','20200912',$
    '20210108','20210429','20210720','20210730','20211117',$
    '20220224']

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

  if (obs_id eq 8) then begin
    ; First is mosaic
    ; Default of 1 is all the mosaic tiles
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for the disk centre pointing
    gd_ids[where(ns_ids eq 'nu20211001001' or ns_ids eq 'nu20211002001' or $
      ns_ids eq 'nu20211003001' or ns_ids eq 'nu20211004001')]=2
  endif

  if (obs_id eq 9) then begin
    ; OK to combine all
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 10) then begin
    ; don't have any of the bad or slew data in the dir so no 0
    ; 11th by default are 1
    gd_ids=intarr(n_elements(evtaf))+1
    ; 12th will be 2
    gd_ids[where(ns_ids eq 'nu80310228001' or ns_ids eq 'nu80310229001' or ns_ids eq 'nu80310230001' $
      or ns_ids eq 'nu80310231001' or ns_ids eq 'nu80310232001' )]=2
    ; 13th will be 3
    gd_ids[where(ns_ids eq 'nu80310241001' or ns_ids eq 'nu80310242001' or ns_ids eq 'nu80310243001' $
      or ns_ids eq 'nu80310244001' or ns_ids eq 'nu80310245001' or ns_ids eq 'nu80310246001' )]=3
  endif

  if (obs_id eq 11) then begin
    ; OK to combine all
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 12) then begin
    ; Default of 1 is target region
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for brief look at limb region
    gd_ids[where(ns_ids eq 'nu80410206001')]=2
  endif

  if (obs_id eq 13) then begin
    ; Default of 1 is the 7th
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for the 9th
    gd_ids[where(ns_ids eq 'nu80414201001' or ns_ids eq 'nu80414202001' or ns_ids eq 'nu80414203001')]=2
    ; then for the 10th
    gd_ids[where(ns_ids eq 'nu80415201001' or ns_ids eq 'nu80415202001' or ns_ids eq 'nu80415203001')]=3

  endif

  if (obs_id eq 14) then begin
    ; Default of 1 is first mosaic
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second mosaic do this
    iidds=strmid(evtaf,strpos(evtaf[0],'nu9041')+7,6)
    gd_ids[where(iidds ge 200000)]=2

  endif

  if (obs_id eq 15) then begin
    ; Default of 1 for first two orbits on target
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for first mosaic do this
    iidds=strmid(evtaf,strpos(evtaf[3],'nu9041')+5,8)
    gd_ids[where(iidds eq 01203001)]=2
    gd_ids[where(iidds ge 11101001 and iidds le 11125001)]=3
    gd_ids[where(iidds ge 11201001 and iidds le 11225001)]=4

  endif

  if (obs_id eq 16) then begin

    ; Default of 1 for first day orbits
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second day have another one
    iidds=strmid(evtaf,strpos(evtaf[3],'nu8041')+5,8)
    gd_ids[where(iidds ge 16208001)]=2

  endif

  if (obs_id eq 17) then begin
    ; Default of 1 is first mosaic
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second mosaic do this
    iidds=strmid(evtaf,strpos(evtaf[0],'nu205111')+7,6)
    gd_ids[where(iidds ge 2e5 and iidds lt 3e5)]=2
    gd_ids[where(iidds ge 3e5 and iidds lt 4e5)]=3
    gd_ids[where(iidds ge 4e5 and iidds lt 5e5)]=4

  endif

  if (obs_id eq 18) then begin
    ; Default of 1 is first mosaic
    ; Default of 1 is first mosaic
    gd_ids=intarr(n_elements(evtaf))+1
    ; then for second mosaic do this
    iidds=strmid(evtaf,strpos(evtaf[0],'nu205121')+7,6)
    gd_ids[where(iidds ge 2e5 and iidds lt 3e5)]=2

  endif

  if (obs_id eq 19) then begin
    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu205')+4,9)
    gd_ids[where(iidds ge 5.14e8 and iidds lt 5.15e8)]=2
    gd_ids[where(iidds ge 5.15e8 and iidds lt 5.16e8)]=3

  endif


  if (obs_id eq 20) then begin

    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu805')+4,9)
    gd_ids[where(iidds ge 513201001 and iidds le 513225001)]=2
    gd_ids[where(iidds ge 514201001 and iidds le 514225001)]=3

  endif

  if (obs_id eq 21) then begin

    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu206')+4,9)
    gd_ids[where(iidds ge 611004001 and iidds le 611006001)]=2
    gd_ids[where(iidds ge 611007001 and iidds le 611009001)]=3
    gd_ids[where(iidds ge 611010001)]=4
  endif

  if (obs_id eq 22) then begin

    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu806')+4,9)
    gd_ids[where(iidds ge 611201001 and iidds le 611225001)]=2

  endif

  if (obs_id eq 23) then begin

    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu206')+4,9)

    gd_ids[where(iidds ge 613001001 and iidds le 613005001)]=2
    gd_ids[where(iidds ge 614001001 and iidds le 614003001)]=3
  endif


  if (obs_id eq 24) then begin

    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1

    iidds=strmid(evtaf,strpos(evtaf[0],'nu206')+4,9)

    gd_ids[where(iidds ge 616001001 and iidds le 616005001)]=2
    gd_ids[where(iidds ge 617001001 and iidds le 617006001)]=3

  endif

  if (obs_id eq 25) then begin
    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 26) then begin
    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1
  endif

  if (obs_id eq 27) then begin
    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1
    iidds=strmid(evtaf,strpos(evtaf[0],'nu206')+4,9)
    gd_ids[where(iidds ge 619001001 and iidds le 619003001)]=2
    gd_ids[where(iidds ge 620001001 and iidds le 620004001)]=3
  endif


  if (obs_id eq 28) then begin
    ; Split per obs target id
    gd_ids=intarr(n_elements(evtaf))+1
    iidds=strmid(evtaf,strpos(evtaf[0],'nu206')+4,9)
    gd_ids[where(iidds ge 622001001 and iidds le 622004001)]=2
    gd_ids[where(iidds ge 623001001 and iidds le 623004001)]=3
  endif

  ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$4


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

      if (obs_id eq 15) then begin
        if (m+1 eq 3 or m+1 eq 4) then begin
          ; Remove weird bright pixel in the obs15 mosaic
          ; Need to check what this is.....
          ims[*,500:650]=0
        endif
      endif

      npp=n_elements(ims[0,*])

      ; Only save a map out of the data is there
      ids00=where(total(ims,1) gt 0,nids00)
      if (nids00 gt 2) then begin
        ; save out the total map
        if (i eq 0) then begin
          ims_tot=ims/effexp
          tstart=t1
          tend=t2
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

    map2fits,maptot,maindir+nsdir+'/maps_ns_'+obsname+'_'+string(1000+m,format='(i4)')+'_'+fpid+'.fits'


  endfor

end