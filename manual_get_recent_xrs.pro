pro manual_get_recent_xrs, obsname=obsname

  ; For more recent data need to manually get the xrs files fromngdc/noaa and load through this approach
  ; https://satdat.ngdc.noaa.gov/sem/goes/data/full/2018/09/goes14/csv/
  ;
  ; 29-Sep-2018 - IGH   Started
  ;
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  if (n_elements(obsname) ne 1) then obsname='201809_28'

  ;-------------------------------------------
  if (obsname eq '201809_28') then begin
    torbs=[['28-Sep-2018 '+['18:05:00','19:05:00']],$
      ['28-Sep-2018 '+['20:15:00','21:15:00']]]
    timer=['28-Sep-2018 17:45:00','28-Sep-2018 21:30:00']
  endif

  fnm14='~/Dropbox/work_dbx/ns_data/nsigh_sep18qs/g14_xrs_2s_20180928_20180928.csv'
  fnm15='~/Dropbox/work_dbx/ns_data/nsigh_sep18qs/g15_xrs_2s_20180928_20180928.csv'
  ; manuualy deleted header info from file so easier with read_csv()
  dd14=read_csv(fnm14)
  dd15=read_csv(fnm15)

  gtime14=dd14.field1
  ghigh14=dd14.field4 >0.
  glow14=dd14.field7 >0.

  gtime15=dd15.field1
  ghigh15=dd15.field4 >0.
  glow15=dd15.field7 >0.

  gfile='dat_files/goes1415_ltc_'+obsname+'.dat'
  save,file=gfile,gtime14,glow14,ghigh14,gtime15,glow15,ghigh15

end