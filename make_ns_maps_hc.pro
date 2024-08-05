pro make_ns_maps_hc,obs_id=obs_id,maindir=maindir,nsdir=nsdir

  ; Code to make an map of the NuSTAR emission >2.5keV for each of the NuSTAR data files.
  ; The map is over all CHUs but only grade 0
  ; Also output a nice summary csv of each observation
  ;
  ; Work in progress version - only a the most recent observations
  ;
  ; Options
  ; obs_id     - Which NuSTAR observations (default =1)
  ; maindir    - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir      - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ;
  ;
  ; 29-Aug-2016 IGH - Created
  ; 18-Nov-2016 IGH - Includes more data (from HEASARC) and changes location of output files
  ; 22-Mar-2017 IGH - Updated with Mar 2017 data
  ; 25-Sep-2017 IGH - Updated with Aug 2017 data
  ; 26-Sep-2017 IGH - Updated with Sep 2017 data
  ; 18-Oct-2017 IGH - Updated with Oct 2017 data
  ; 03-Jun-2018 IGH - Updated with May 2018 data
  ; 10-Sep-2018 IGH - Updated with Sep 2018 data
  ; 29-Sep-2018 IGH - Updated with Sep 2018 data, QS 28th
  ; 12-Jan-2019 IGH - Updated with Jan 2019 data
  ; 13-Jan-2019 IGH - Modified submap option for evt containing multiple pointings
  ; 06-Feb-2019 IGH - Updated for heasarc version of Jan data
  ; 20-Apr-2019 IGH - Updated with Apr 2019 data
  ; 10-May-2019 IGH - Updated with Apr 2019 QS data
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
  ; 16-Jun-2022 IGH - Added in Jun 2022 data
  ; 03-Oct-2022 IGH - Added in Sep 2022 data
  ; 02-Jan-2023 IGH - Added in Dec 2022 data
  ; 28-Mar-2023 IGH - Added in Mar 2023 data
  ; 30-Jan-2024 IGH - Added in Dec 2023 data
  ; 15-May-2024 IGH - Added in Mar 2024 data
  ; 12-Jul-2024 IGH - Added in Jun 2024 data
  ; 05-Aug-2024 IGH - Added in Jul 2024 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  clearplot
  if (n_elements(obs_id) ne 1) then obs_id=36
  dobs=['20140910','20141101','20141211',$
    '20150429','20150901',$
    '20160219','20160422','20160726',$
    '20170321','20170821','20170911','20171010',$
    '20180529','20180907','20180928',$
    '20190112','20190412','20190425','20190702',$
    '20200129','20200221','20200606','20200912',$
    '20210108','20210429','20210720','20210730','20211117',$
    '20220224','20220603','20220906','20221209',$
    '20230318','20231228',$
    '20240330','20240630','20240716']

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
  if (obsname eq '20230318') then begin
    nsdir='ns_20230318'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20231228') then begin
    nsdir='ns_20231228'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20240330') then begin
    nsdir='ns_20240330'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20240630') then begin
    nsdir='ns_20240630'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  if (obsname eq '20240716') then begin
    nsdir='ns_20240716'
    maindir='/Volumes/Samsung_T5/data/heasarc_nustar/'
  endif
  ; What is the minimum energy we want for the image?
  min_eng=2.5

  ;-------------------------------------------

  evtaf=file_search(maindir+nsdir,'/*06_cl_sunpos.evt')

  nf=n_elements(evtaf)
  ns_ids=strarr(nf)
  t1s=strarr(nf)
  t2s=strarr(nf)
  xcs=strarr(nf)
  ycs=strarr(nf)
  effexps=strarr(nf)
  ontimes=strarr(nf)
  lvtp=strarr(nf)
  nsfs=strarr(nf)
  fpids=strarr(nf)

  for i=0,nf-1 do begin
    stemp=strsplit(evtaf[i],'/',/extract)
    stemp=stemp[n_elements(stemp)-1]
    ns_ids[i]=strmid(stemp,0,strpos(stemp,'_cl_sunpos')-3)
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
    ;    im_size = 1037. / pix_size
    im_width = round(im_size * 2.)
    ;    ims=intarr(1688,1688)

    pixinds = evta.x + evta.y * npix
    im_hist = histogram(pixinds, min = 0, max = npix*npix-1, binsize = 1)
    im = reform(im_hist, npix, npix)
    ims= im[(centerx-im_width):(centerx+im_width-1), (centery-im_width):(centery+im_width-1)]
    npp=n_elements(ims[0,*])

    t1s[i]=t1
    t2s[i]=t2

    ; Only save a map out of the data is there
    ids00=where(total(ims,1) gt 0,nids00)
    subxy=[-250,250]

    if (obs_id eq 15) then begin
      if (ns_ids[i] eq 'nu90411100001' or ns_ids[i] eq 'nu90411200001') then subxy=[-900,900]
    endif


    if (nids00 gt 2) then begin
      ; Just want the zoomed in region
      id0=median(where(total(ims,1) gt 0))
      id1=median(where(total(ims,2) gt 0))

      subx=subxy+id1
      if (subx[0] lt 0) then subx=[0,500]
      if (subx[1] gt npp-1) then subx=[npp-1-500,npp-1]
      suby=subxy+id0
      if (suby[0] lt 0) then suby=[0,500]
      if (suby[1] gt npp-1) then suby=[npp-1-500,npp-1]
      zims=ims[subx[0]:subx[1],suby[0]:suby[1]]

      ;      if (obs_id eq 15) then begin
      ;        if (ns_ids[i] eq 'nu90411100001' or ns_ids[i] eq 'nu90411200001') then begin
      ;          ; Remove weird bright pixel in the obs15 mosaic
      ;          ; Need to check what this is.....
      ;          zims[*,300:350]=0
      ;        endif
      ;      endif

      pxs=pix_size
      x0=xc-npp*0.5*pxs+pxs*subx[0]
      y0=yc-npp*0.5*pxs+pxs*suby[0]

      newxc=x0+0.5*n_elements(zims[*,0])*pxs
      newyc=y0+0.5*n_elements(zims[0,*])*pxs

      ang = pb0r(t1,/arcsec,l0=l0)

      mapa=make_map(zims/effexp,dx=pxs,dy=pxs,xc=newxc,yc=newyc,$
        time=t1,dur=effexp,id=fpid+' '+t1+' to '+$
        anytim(t2,/yoh,/trunc,/time)+' ('+string(lvt*100,format='(f5.2)')+'%)',$
        xyshift=[0,0],l0=l0,b0=ang[1],rsun=ang[2])

      map2fits,mapa,maindir+nsdir+'/maps_'+break_time(t1)+'_'+ns_ids[i]+'_'+fpid+'.fits'
      loadct,39,/silent
      plot_map,mapa,/log,/limb,grid_spacing=25,title=mapa.id

      xcs[i]=string(newxc,format='(i5)')
      ycs[i]=string(newyc,format='(i5)')
      effexps[i]=string(effexp,format='(f7.2)')
      ontimes[i]=string(ontime,format='(f7.2)')
      lvtp[i]=string(lvt*100.,format='(f6.2)')

    endif

    nsfs[i]=ns_ids[i]+'/'+fpid
    fpids[i]=fpid

    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  endfor

  ; Make sure final list is chronological and given A then B for each pointing time.
  ida=where(fpids eq 'FPMA')
  idb=where(fpids eq 'FPMB')
  sida=ida[sort(anytim(t1s[ida]))]
  sidb=idb[sort(anytim(t1s[idb]))]
  sid=intarr(nf)
  for i=0,nf/2-1 do sid[2*i:2*i+1]=[sida[i],sidb[i]]

  ; Write out a nice summary file
  hdr=['NS ID/Inst','Start Time','End Time','On Time [s]','Eff Exp [s]','Livetime [%]','XC [S/C]','YC [S/C]']
  write_csv, 'info_files/ns_'+obsname+'_info.csv',$
    nsfs[sid],t1s[sid],t2s[sid],ontimes[sid],effexps[sid],lvtp[sid],xcs[sid],ycs[sid],header=hdr

end