pro plot_ns_sun_lc_rnm, obsname=obsname,timer=timer,goes=goes,gyr=gyr,tav=tav,$
  maindir=maindir,nsdir=nsdir,gesnlog=gesnlog,chudo=chudo,do_nustar=do_nustar,wid=wid

  ; Based on plot_ns_sun_lc.pro but for times with no RHESSI :( which for our case is mostly 2018+

  ; Script to generate overview time profiles of NuSTAR livetime, GOES and RHESSI flux
  ; The data it uses is either *.dat files in the dat_files directory or if those do not
  ; exist the code with generate these from a *local* copy of the NuSTAR data and *online* for GOES
  ; In reality the *.dat files should be there and you do not need the original NuSTAR data
  ; (or setup maindir, nsdir etc)

  ; Options
  ; obsname       - Which NuSTAR observations (default ='201409')
  ; timer         - Overal time range to plot (default, specified values per obs below)
  ; goes          - Plot an additional GOES lightcurve with NuSTAR times highlighted (default no)
  ; gyr           - yrange for the GOES lightcurve (default, specified values per obs below)
  ; tav           - Average the GOES light curve, in sec (default NO)
  ; maindir       - Main directory of where the NuSTAR data is kept (default for IGH system but only need if no *.dat files)
  ; nsdir         - Specific directory where this NuSTAR obs is kepts (default for IGH system but only need if no *.dat files)
  ; gesnlog       - Plot the GOES light curve with ylog=0 in default NuSTAR, GOES, RHESSI plot
  ; chudo         - Do an extra plot with NuSTAR Livetime, CHU, GOES and RHESSI (default no)
  ; do_nustar     - Process the NuSTAR data (default yes) - useful for just after an obs with no_nustar=0 to get GOES/RHESSI etc
  ; wid           - Want to make an extra wide version of the plot?

  ; example of usage
  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  ; plot_ns_sun_lc, obsname='201409',gav=5,/goes

  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  ; plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo

  ; Note that for muliple day campaigns (Sep 2015, Sep 2017) the default is to do it per day instead of whole campaign
  ; so obsname='201509_01' or obsname='201709_11'

  ; 11-Sep-2018 - IGH   Started based on plot_ns_sun_lc.pro
  ;                     Removed RHESSI data get and plotting
  ;                     Added GOES 14, as well as GOES 15
  ; 29-Sep-2018 - IGH   Added in Sep 2018 data, QS 28th
  ; 12-Jan-2019 - IGH   Added in Jan 2019 data
  ; 20-Apr-2019 - IGH   Added in Apr 2019 data
  ; 10-May-2019 - IGH   Added in Apr 2019 QS data
  ; 16-Jul-2019 - IGH   Added in Jul 2019 QS data
  ; 14-Feb-2020 - IGH   Added in Jan 2020 data and option for a wider plot
  ; 11-Mar-2020 - IGH   Added in Feb 2020 data
  ; 02-Jul-2020 - IGH   Added in Jun 2020 data
  ; 05-Jul-2020 - IGH   Added in GOES16 and changed GOES averaging (tav not gav)
  ; 05-Oct-2020 - IGH   Added in Sep 2020 data
  ; 22-Feb-2021 - IGH   Added in Jan 2021 data
  ; 26-May-2021 - IGH   Added in Apr/May 2021 data
  ; 26-Jul-2021 - IGH   Added in 20 Jul 2021 data
  ; 15-Aug-2021 - IGH   Added in 30 Jul 2021 data
  ; 17-Sep-2021 - IGH   Added in missing orbit 3 from Apr 2021 data
  ; 30-Jan-2022 - IGH   Added in Nov 2021 data
  ;                     Changed GOES16 to one min average
  ;                     Changed GOES14/15 to one min average from NOAA
  ; 28-Mar-2022 - IGH   Added in Feb 2022 data
  ; 16-Jun-2022 - IGH   Added in Jun 2022 data
  ; 03-Oct-2022 - IGH   Updated with Oct 2022 
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(obsname) ne 1) then obsname='202107_30'
  if (n_elements(maindir) ne 1) then maindir='/Volumes/Samsung_T5/data/heasarc_nustar/';'~/data/heasarc_nustar/';'~/data/ns_data/'
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
    gyrl=[0.2,1.4]

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
    gyrl=[0.05,0.5]

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
    gyrl=[0.05,0.5]

  endif

  ;-------------------------------------------
  if (obsname eq '201809_28') then begin
    torbs=[['28-Sep-2018 '+['18:25:00','19:24:00']],$
      ['28-Sep-2018 '+['20:02:00','21:01:00']]]
    timer=['28-Sep-2018 17:45:00','28-Sep-2018 21:30:00']
    nsdir='obs15/quicklook/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]

  endif

  ;-------------------------------------------
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
    gyrl=[0.05,0.5]

  endif

  ;-------------------------------------------
  if (obsname eq '201904') then begin
    torbs=[['12-Apr-2019 15:12:00','12-Apr-2019 16:12:00'],$
      ['12-Apr-2019 16:49:00','12-Apr-2019 17:49:00'],$
      ['12-Apr-2019 18:26:00','12-Apr-2019 19:26:00'],$
      ['12-Apr-2019 20:02:00','12-Apr-2019 20:46:00'],$
      ['12-Apr-2019 21:40:00','12-Apr-2019 22:30:00'],$
      ['13-Apr-2019 02:30:00','13-Apr-2019 03:30:00'],$
      ['13-Apr-2019 04:06:00','13-Apr-2019 05:06:00'],$
      ['13-Apr-2019 05:42:00','13-Apr-2019 06:39:00'],$
      ['13-Apr-2019 07:20:00','13-Apr-2019 08:20:00'],$
      ['13-Apr-2019 08:56:00','13-Apr-2019 09:55:00'],$
      ['13-Apr-2019 10:32:00','13-Apr-2019 11:32:00']]
    timer=['12-Apr-2019 12:00:00','13-Apr-2019 14:00:00']
    nsdir='obs17/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.3,3.0]

  endif

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
    gyrl=[0.05,0.5]

  endif
  ;-------------------------------------------


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
    gyrl=[0.05,0.5]

  endif

  if (obsname eq '202001') then begin
    torbs=[['29-Jan-20 08:05:47','29-Jan-20 08:14:22'],$
      ['29-Jan-20 10:03:21','29-Jan-20 10:36:42'],$
      ['29-Jan-20 11:12:39','29-Jan-20 11:53:59'],$
      ['29-Jan-20 16:05:50','29-Jan-20 17:07:49'],$
      ['29-Jan-20 17:48:36','29-Jan-20 17:56:08'],$
      ['29-Jan-20 19:18:54','29-Jan-20 20:16:33'],$
      ['29-Jan-20 20:52:35','29-Jan-20 21:43:50'],$
      ['29-Jan-20 22:29:17','29-Jan-20 23:25:17'],$
      ['30-Jan-20 00:05:57','30-Jan-20 01:06:34'],$
      ['30-Jan-20 01:42:36','30-Jan-20 01:58:03'],$
      ['30-Jan-20 03:36:35','30-Jan-20 04:19:52'],$
      ['30-Jan-20 04:55:55','30-Jan-20 05:56:31'],$
      ['30-Jan-20 06:32:34','30-Jan-20 07:33:10'],$
      ['30-Jan-20 08:13:41','30-Jan-20 08:38:14'],$
      ['30-Jan-20 10:02:26','30-Jan-20 10:28:48'],$
      ['30-Jan-20 11:57:08','30-Jan-20 11:59:12'],$
      ['30-Jan-20 13:13:51','30-Jan-20 13:59:48'],$
      ['30-Jan-20 14:35:51','30-Jan-20 15:26:18'],$
      ['30-Jan-20 16:26:20','30-Jan-20 17:13:05'],$
      ['30-Jan-20 17:49:12','30-Jan-20 18:49:46'],$
      ['30-Jan-20 19:25:49','30-Jan-20 20:26:23']]
    timer=['29-Jan-2020 07:00:00','30-Jan-2020 21:00:00']
    nsdir='ns_20200129/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]

  endif

  if (obsname eq '202002') then begin
    torbs=[['21-Feb-20 05:16:00','21-Feb-20 06:15:00'],$
      ['21-Feb-20 06:54:30','21-Feb-20 07:52:00'],$
      ['21-Feb-20 08:38:30','21-Feb-20 09:29:30'],$
      ['21-Feb-20 10:06:00','21-Feb-20 11:05:00'],$
      ['21-Feb-20 11:42:00','21-Feb-20 12:42:00'],$
      ['21-Feb-20 13:19:00','21-Feb-20 14:19:00'],$
      ['21-Feb-20 14:56:00','21-Feb-20 15:55:00'],$
      ['21-Feb-20 16:32:30','21-Feb-20 17:32:30'],$
      ['21-Feb-20 18:09:30','21-Feb-20 19:09:30'],$
      ['21-Feb-20 19:46:00','21-Feb-20 20:45:00'],$
      ['21-Feb-20 21:22:43','21-Feb-20 22:22:00']]
    timer=['21-Feb-2020 05:00:00','21-Feb-2020 23:00:00']
    nsdir='ns_20200221/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]

  endif

  if (obsname eq '202006_06') then begin
    torbs=[['06-Jun-20 19:07:22','06-Jun-20 20:07'],$
      ['06-Jun-20 20:45:00','06-Jun-20 21:37']]
    timer=['06-Jun-2020 18:30','06-Jun-2020 22:30']
    nsdir='ns_20200606/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,3.0]

  endif

  if (obsname eq '202006_07') then begin
    torbs=[['07-Jun-20 19:16','07-Jun-20 20:17'],$
      ['07-Jun-20 20:53:39','07-Jun-20 21:46:52']]
    timer=['07-Jun-2020 18:30','07-Jun-2020 22:30']
    nsdir='ns_20200606/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,8.0]

  endif

  if (obsname eq '202006_08') then begin
    torbs=[['08-Jun-20 19:26','08-Jun-20 20:26'],$
      ['08-Jun-20 21:03:00','08-Jun-20 21:56']]
    timer=['08-Jun-2020 18:30','08-Jun-2020 22:30']
    nsdir='ns_20200606/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,2.0]

  endif

  if (obsname eq '202006_09') then begin
    torbs=[['09-Jun-20 14:46','09-Jun-20 15:46']]
    timer=['09-Jun-2020 14:00','09-Jun-2020 16:30']
    nsdir='ns_20200606/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,2.0]

  endif

  if (obsname eq '202009') then begin
    torbs=[['12-Sep-2020 09:05:40','12-Sep-2020 10:05:10'],$
      ['12-Sep-2020 10:42:20','12-Sep-2020 11:41:40'],$
      ['12-Sep-2020 12:19:00','12-Sep-2020 13:18:20'],$
      ['12-Sep-2020 13:55:40','12-Sep-2020 14:55:10'],$
      ['12-Sep-2020 15:32:20','12-Sep-2020 16:31:50'],$
      ['12-Sep-2020 17:09:00','12-Sep-2020 18:08:20'],$
      ['12-Sep-2020 18:45:40','12-Sep-2020 19:45:00'],$
      ['12-Sep-2020 20:22:10','12-Sep-2020 21:07:40'],$
      ['12-Sep-2020 21:58:50','12-Sep-2020 22:50:10'],$
      ['12-Sep-2020 23:35:30','13-Sep-2020 00:34:00']]
    timer=['12-Sep-2020 08:30:00','13-Sep-2020 01:30:00']
    nsdir='ns_20200912/'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]

  endif

  if (obsname eq '202101_08') then begin
    torbs=[['08-Jan-21 10:12:00','08-Jan-21 11:13'],$
      ['08-Jan-21 11:49:00','08-Jan-21 12:50'],$
      ['08-Jan-21 13:26:00','08-Jan-21 14:27'],$
      ['08-Jan-21 15:03:00','08-Jan-21 16:03']]
    timer=['08-Jan-21 09:00','08-Jan-21 17:00']
    nsdir='ns_20210108'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]
  endif

  if (obsname eq '202101_14') then begin
    torbs=[['14-Jan-21 09:34:00','14-Jan-21 10:35'],$
      ['14-Jan-21 11:11:00','14-Jan-21 11:57'],$
      ['14-Jan-21 11:58:00','14-Jan-21 12:12'],$
      ['14-Jan-21 12:47:00','14-Jan-21 13:33'],$
      ['14-Jan-21 14:34:00','14-Jan-21 15:25']]
    timer=['14-Jan-21 09:00','14-Jan-21 16:00']
    nsdir='ns_20210108'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.05,0.5]
  endif

  if (obsname eq '202101_20') then begin
    torbs=[['20-Jan-21 10:32:00','20-Jan-21 11:32'],$
      ['20-Jan-21 12:08:00','20-Jan-21 13:09'],$
      ['20-Jan-21 13:45:00','20-Jan-21 14:45']]
    timer=['20-Jan-21 09:30','20-Jan-21 15:00']
    nsdir='ns_20210108'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,15.0]
  endif

  if (obsname eq '202104_29') then begin
    torbs=[['29-Apr-21 14:53:47','29-Apr-21 15:54:07'],$
      ['29-Apr-21 16:30:25','29-Apr-21 17:30:46'],$
      ['29-Apr-21 18:07:03','29-Apr-21 19:07:24'],$
      ['29-Apr-21 19:43:41','29-Apr-21 20:44:02'],$
      ['29-Apr-21 21:20:19','29-Apr-21 22:16:44']]
    timer=['29-Apr-21 14:30','29-Apr-21 23:00']
    nsdir='ns_20210429_only'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,2.0]
  endif

  if (obsname eq '202105_03') then begin
    torbs=[['03-May-21 15:31:50','03-May-21 16:32:14'],$
      ['03-May-21 17:08:28','03-May-21 18:08:53'],$
      ['03-May-21 18:45:14','03-May-21 19:45:37'],$
      ['03-May-21 20:21:52','03-May-21 21:22:15'],$
      ['03-May-21 21:58:30','03-May-21 22:58:53']]
    timer=['03-May-21 15:00','03-May-21 23:30']
    nsdir='ns_20210503'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.1,1.0]
  endif

  if (obsname eq '202105_07') then begin
    torbs=[['07-May-21 14:33:15','07-May-21 15:22:18'],$
      ['07-May-21 16:11:13','07-May-21 17:10:08'],$
      ['07-May-21 17:46:36','07-May-21 18:46:51'],$
      ['07-May-21 19:23:14','07-May-21 20:23:29'],$
      ['07-May-21 20:59:54','07-May-21 22:00:10'],$
      ['07-May-21 22:36:32','07-May-21 23:36:47']]
    timer=['07-May-21 14:00','07-May-21 23:30']
    nsdir='ns_20210507'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.1,20.0]
  endif

  if (obsname eq '202107_20') then begin
    torbs=[['20-Jul-21 00:24:06','20-Jul-21 01:16:54'],$
      ['20-Jul-21 02:52:00','20-Jul-21 03:01:22'],$
      ['20-Jul-21 03:37:21','20-Jul-21 04:38:00'],$
      ['20-Jul-21 05:13:59','20-Jul-21 06:14:38'],$
      ['20-Jul-21 06:50:37','20-Jul-21 07:51:16'],$
      ['20-Jul-21 08:27:14','20-Jul-21 09:27:55'],$
      ['20-Jul-21 10:03:52','20-Jul-21 11:04:32'],$
      ['20-Jul-21 11:40:30','20-Jul-21 12:41:10'],$
      ['20-Jul-21 13:17:08','20-Jul-21 14:17:48']]
    timer=['20-Jul-21 00:00:00','20-Jul-21 15:00:00']
    nsdir='ns_20210720'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,6.0]
  endif

  if (obsname eq '202107_30') then begin
    torbs=[['30-Jul-21 18:05','30-Jul-21 19:05'],$
      ['30-Jul-21 19:42','30-Jul-21 20:42'],$
      ['30-Jul-21 21:19','30-Jul-21 22:18']]
    timer=['30-Jul-21 18:00:00','30-Jul-21 22:30:00']
    nsdir='ns_20210730'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,0.8]
  endif
  
  if (obsname eq '202111_17') then begin
    torbs=[['17-Nov-21 17:28:39','17-Nov-21 18:29:12'],$
      ['17-Nov-21 19:05:23','17-Nov-21 20:05:58'],$
      ['17-Nov-21 20:42:01','17-Nov-21 21:32:40']]
    timer=['17-Nov-21 16:36:00','17-Nov-21 22:36:00']
    nsdir='ns_20211117'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,0.8]
  endif
  
  if (obsname eq '202111_19') then begin
    torbs=[['19-Nov-21 22:37:20','19-Nov-21 23:33:21'],$
      ['20-Nov-21 00:13:57','20-Nov-21 01:14:26'],$
      ['20-Nov-21 01:50:34','20-Nov-21 02:51:03']]
    timer=['19-Nov-21 22:00:00','20-Nov-21 03:15:00']
    nsdir='ns_20211119'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,0.8]
  endif
  
  if (obsname eq '202111_21') then begin
    torbs=[['21-Nov-21 22:55:58','21-Nov-21 23:52:49'],$
      ['22-Nov-21 00:32:26','22-Nov-21 01:32:57'],$
      ['22-Nov-21 02:09:13','22-Nov-21 02:58:59'],$
      ['22-Nov-21 03:00:10','22-Nov-21 03:09:33']]
    timer=['21-Nov-21 22:40:00','22-Nov-21 03:20:00']
    nsdir='ns_20211121'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.2,0.8]
  endif
  
  if (obsname eq '202202_24') then begin
    torbs=[['24-Feb-22 14:58:03','24-Feb-22 15:57:35'],$
      ['24-Feb-22 16:34:39','24-Feb-22 17:34:11'],$
      ['24-Feb-22 18:11:16','24-Feb-22 19:10:47'],$
      ['24-Feb-22 19:47:52','24-Feb-22 20:47:24']]
    timer=['24-Feb-22 14:00:00','24-Feb-22 21:30:00']
    nsdir='ns_20220224'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[0.9,2.0]
  endif

  if (obsname eq '202202_25') then begin
    torbs=[['25-Feb-22 15:07:05','25-Feb-22 16:06:36'],$
      ['25-Feb-22 16:43:41','25-Feb-22 17:43:11'],$
      ['25-Feb-22 18:20:17','25-Feb-22 19:19:48'],$
      ['25-Feb-22 19:56:53','25-Feb-22 20:56:24']]
    timer=['25-Feb-22 14:00:00','25-Feb-22 21:30:00']
    nsdir='ns_20220224'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.1,4.0]
  endif
  
  if (obsname eq '202202_26') then begin
    torbs=[['26-Feb-22 20:05:54','26-Feb-22 21:05:24'],$
      ['26-Feb-22 21:42:30','26-Feb-22 22:35:32'],$
      ['26-Feb-22 23:19:07','27-Feb-22 00:18:36'],$
      ['27-Feb-22 00:55:40','27-Feb-22 01:55:10']]
    timer=['26-Feb-22 19:30:00','27-Feb-22 02:30:00']
    nsdir='ns_20220224'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.1,8.0]
  endif
  
  if (obsname eq '202206_03') then begin
    torbs=[['03-Jun-22 13:30:00','03-Jun-22 14:30:47'],$
      ['03-Jun-22 15:06:00','03-Jun-22 16:01:00'],$
      ['03-Jun-22 16:52:00','03-Jun-22 17:36:00'],$
      ['03-Jun-22 18:36:00','03-Jun-22 19:20:00'],$
      ['03-Jun-22 20:15:29','03-Jun-22 20:53:00'],$
      ['03-Jun-22 21:32:50','03-Jun-22 22:33:00'],$
      ['03-Jun-22 23:09:23','04-Jun-22 00:08:31'],$
      ['04-Jun-22 00:46:00','04-Jun-22 01:46:45'],$
      ['04-Jun-22 02:49:00','04-Jun-22 03:04:00']]
    timer=['03-Jun-22 12:30:00','04-Jun-22 03:30:00']
    nsdir='ns_20220603'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[1.1,6.0]
  endif
  
  if (obsname eq '202209_06') then begin
    torbs=[['06-Sep-22 15:44','06-Sep-22 16:43'],$
      ['06-Sep-22 17:20','06-Sep-22 18:13'],$
      ['06-Sep-22 18:57','06-Sep-22 19:56'],$
      ['06-Sep-22 20:33','06-Sep-22 21:33']]
    timer=['06-Sep-22 15:00:00','06-Sep-22 22:00:00']
    nsdir='ns_20220906'

    hkf=file_search(maindir+nsdir,'*A_fpm.hk')
    ;    only want those in the hk directories
    hkf=hkf[where(strpos(hkf,'/hk/') ge 0)]
    chuf=file_search(maindir+nsdir, '*chu123.fits')
    chuf=chuf[where(strpos(chuf,'/hk/') ge 0)]
    gyrl=[6,40]
  endif

  norbs=n_elements(torbs[0,*])
  ngaps=(size(dgtims))[2];n_elements(dgtims[0,*])
  ;-------------------------------------------
  ;-------------------------------------------
  ; If no GOES *.dat file then make one

  if (anytim(timer[0]) gt anytim('01-Jun-2020')) then begin
    gfile='dat_files/goes16_ltc_'+obsname+'.dat'

    if (file_test(gfile) eq 0) then begin
      a = ogoes()
      a->set,tstart=anytim(anytim(timer[0])-30*60.,/yoh),tend=anytim(anytim(timer[1])+30*60.,/yoh)
      a->set, /goes16
      a->set, /noaa
      ; Now doing one min average
      a->set,/one
      glow16=a->getdata(/low)
      ghigh16=a->getdata(/high)
      gtim16 = a->getdata(/times)
      gutbase16 = a->get(/utbase)
      gtime16=anytim(anytim(gutbase16)+gtim16,/yoh,/trunc)
      save,file=gfile,gtime16,glow16,ghigh16
    endif else begin
      restore,file=gfile
    endelse

  endif else begin
    gfile='dat_files/goes1415_ltc_'+obsname+'.dat'

    if (file_test(gfile) eq 0) then begin
      a = ogoes()
      a->set,tstart=anytim(anytim(timer[0])-30*60.,/yoh),tend=anytim(anytim(timer[1])+30*60.,/yoh)
      a->set, /goes15
      a->set, /noaa
      ; Now doing one min average
      a->set,/one
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
  endelse

  ;-------------------------------------------
  ; Need to average the GOES data?
  ; As using the 1min for GOES 16 don't need to average now
  ; As using the 1min for GOES14/15 don't need to average now
  dt=0
;  if (n_elements(tav) ne 0) then begin
;
;    if (anytim(timer[0]) lt anytim('01-Jun-2020')) then begin
;      if (n_elements(gtime15) ge 2) then dt=anytim(gtime15[1])-anytim(gtime15[0])
;    endif
;
;    if (anytim(timer[0]) gt anytim('01-Jun-2020')) then begin
;;      if (dt gt 0) then begin
;;
;;        gav=round(tav/dt)
;;        gtime0=anytim(gtime16)
;;        glow0=glow16
;;        ghigh0=ghigh16
;;        ngs=n_elements(gtime0)
;;
;;        nngs=ngs/gav
;;        gtime16=strarr(nngs)
;;        glow16=fltarr(nngs)
;;        ghigh16=fltarr(nngs)
;;
;;        for ii=0L,nngs-1L do begin
;;          gtime16[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;;          glow16[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;;          ghigh16[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;;        endfor
;;      endif
;    endif else begin
;      if (dt gt 0) then begin
;
;        gav=round(tav/dt)
;        gtime0=anytim(gtime14)
;        glow0=glow14
;        ghigh0=ghigh14
;        ngs=n_elements(gtime0)
;
;        nngs=ngs/gav
;        gtime14=strarr(nngs)
;        glow14=fltarr(nngs)
;        ghigh14=fltarr(nngs)
;
;        for ii=0L,nngs-1L do begin
;          gtime14[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;          glow14[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;          ghigh14[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;        endfor
;
;        gtime0=anytim(gtime15)
;        glow0=glow15
;        ghigh0=ghigh15
;        ngs=n_elements(gtime0)
;
;        nngs=ngs/gav
;        gtime15=strarr(nngs)
;        glow15=fltarr(nngs)
;        ghigh15=fltarr(nngs)
;
;        for ii=0L,nngs-1L do begin
;          gtime15[ii]=anytim(mean(gtime0[gav*ii:gav*ii+gav-1]),/yoh,/trunc)
;          glow15[ii]=mean(glow0[gav*ii:gav*ii+gav-1])
;          ghigh15[ii]=mean(ghigh0[gav*ii:gav*ii+gav-1])
;        endfor
;      endif
;    endelse
;
;
;  endif




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

    utplot,timer,[1,1],ytitle='!3GOES Flux [W m!U-2!N]',chars=1.2,$
      /ylog,/nodata,yrange=gyr,timer=timer

    if (anytim(timer[0]) gt anytim('01-Jun-2020') and n_elements(gtime16) ge 2) then begin
      outplot,gtime16,glow16,color=150,thick=6
      outplot,gtime16,ghigh16,color=150,thick=6

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyr,lines=0,color=0,thick=3
        outplot,[torbs[1,i],torbs[1,i]],gyr,lines=0,color=0,thick=3

        gd1=where(anytim(gtime16) ge anytim(torbs[0,i]) and anytim(gtime16) le anytim(torbs[1,i]),nid1)
        if (nid1 gt 1) then outplot,gtime16[gd1],glow16[gd1],color=1,thick=6
        if (nid1 gt 1) then outplot,gtime16[gd1],ghigh16[gd1],color=2,thick=6


      endfor

      evt_grid,replicate(gtime16[0],5),labpos=1.2*[1e-8,1e-7,1e-6,1e-5,1e-4],labels=['A','B','C','M','X'],$
        /data,labsize=1.5,/labonly,/noarrow,align=0,labcolor=150
      for i=0, 4 do outplot,[gtime16[0],gtime16[n_elements(gtime15)-1]],10d^(-8+i)*[1,1],color=150,lines=2,thick=4
      xyouts, 0.32e4,1.2e4,'16: 1-8 '+string(197b),/device,chars=1.25,color=1
      xyouts, 0.58e4,1.2e4,'0.5-4 '+string(197b),/device,chars=1.25,color=2

    endif
    if (n_elements(gtime15) ge 2) then begin


      outplot,gtime14,glow14,color=150,thick=3
      outplot,gtime14,ghigh14,color=150,thick=3
      outplot,gtime15,glow15,color=150,thick=6
      outplot,gtime15,ghigh15,color=150,thick=6

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyr,lines=0,color=0,thick=3
        outplot,[torbs[1,i],torbs[1,i]],gyr,lines=0,color=0,thick=3

        gd1=where(anytim(gtime14) ge anytim(torbs[0,i]) and anytim(gtime14) le anytim(torbs[1,i]),nid1)
        if (nid1 gt 1) then outplot,gtime14[gd1],glow14[gd1],color=4,thick=3
        if (nid1 gt 1) then outplot,gtime14[gd1],ghigh14[gd1],color=8,thick=3

        gd1=where(anytim(gtime15) ge anytim(torbs[0,i]) and anytim(gtime15) le anytim(torbs[1,i]),nid1)
        if (nid1 gt 1) then outplot,gtime15[gd1],glow15[gd1],color=1,thick=6
        if (nid1 gt 1) then outplot,gtime15[gd1],ghigh15[gd1],color=2,thick=6

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

    endif

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
  utplot,timer,[1,1],/ylog,yrange=[5e-4,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
    position=[0.14,0.55,0.95,0.99],xtit='',xtickf='(a1)',timer=timer,/nodata

  if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3

  for i=0, ngaps-1 do begin
    hgd1=where(anytim(htime) ge anytim(dgtims[0,i]) and anytim(htime) le anytim(dgtims[1,i]),nhgd1)
    if (nhgd1 gt 1) then outplot,htime[hgd1],hlive[hgd1],color=200,thick=3
  endfor

  xyouts, 12.5e3,7.5e3,'FPMA',chars=0.7,/device,orien=90,color=3

  ; Want ylog=0 for the GOES panel?
  if Keyword_set(gesnlog) then begin

    utplot,timer,[1,1],ytitle='!3GOES Flux [x10!u-7!N W m!U-2!N]',$
      /nodata,yrange=gyrl,timer=timer,position=[0.14,0.1,0.95,0.54]
    ;~~~~~~~~~~~~~~~~~
    if (anytim(timer[0]) gt anytim('01-Jun-2020') and n_elements(gtime16) ge 2) then begin
      outplot,gtime16,glow16*1d7,color=150,thick=4

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2

        gd1=where(anytim(gtime16) ge anytim(torbs[0,i]) and anytim(gtime16) le anytim(torbs[1,i]),ngd1)
        if (ngd1 gt 1) then outplot,gtime16[gd1],glow16[gd1]*1d7,color=1,thick=4
      endfor

      for i=0, ngaps-1 do begin
        hgd1=where(anytim(gtime16) ge anytim(dgtims[0,i]) and anytim(gtime16) le anytim(dgtims[1,i]),nhgd1)
        if (nhgd1 gt 1) then outplot,gtime16[hgd1],glow15[hgd1]*1d7,color=200,thick=4
      endfor

      xyouts, 12.5e3,1.5e3,'16: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1

    endif
    if (n_elements(gtime15) ge 2) then begin

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
    endif


  endif else begin
    utplot,timer,[1,1],ytitle='!3GOES Flux [W m!U-2!N]',$
      /ylog,/nodata,yrange=gyr,timer=timer,position=[0.14,0.1,0.95,0.54]
    ;~~~~~~~~~~~~~~~~~
    if (anytim(timer[0]) gt anytim('01-Jun-2020') and n_elements(gtime16) ge 2) then begin
      outplot,gtime16,glow16*1d7,color=150,thick=4

      for i=0, norbs-1 do begin
        outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
        outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2

        gd1=where(anytim(gtime16) ge anytim(torbs[0,i]) and anytim(gtime16) le anytim(torbs[1,i]),ngd1)
        if (ngd1 gt 1) then outplot,gtime16[gd1],glow16[gd1]*1d7,color=1,thick=4
      endfor

      for i=0, ngaps-1 do begin
        hgd1=where(anytim(gtime16) ge anytim(dgtims[0,i]) and anytim(gtime16) le anytim(dgtims[1,i]),nhgd1)
        if (nhgd1 gt 1) then outplot,gtime16[hgd1],glow15[hgd1]*1d7,color=200,thick=4
      endfor

      xyouts, 12.5e3,1.5e3,'16: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1

    endif
    if (n_elements(gtime15) ge 2) then begin

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
    endif

  endelse

  device,/close
  set_plot, mydevice

  ;-------------------------------------------
  ; Make a plot of NuSTAR livetime, CHU state and GOES
  if keyword_Set(chudo) then begin

    if keyword_set(wid) then begin
      px1=0.08
      px2=0.97
      labx=2*12.5e3
      if keyword_set(gesnlog) then figname='figs/ns_ltc_chu_goesnl_nsl_'+obsname+'_wid.eps' else $
        figname='figs/ns_ltc_chu_goes_nsl_'+obsname+'_wid.eps'
      set_plot,'ps'
      device, /encapsulated, /color, /isolatin1,/inches, $
        bits=8, xsize=10, ysize=5,file=figname
    endif else begin
      px1=0.12
      px2=0.95
      labx=12.5e3
      if keyword_set(gesnlog) then figname='figs/ns_ltc_chu_goesnl_nsl_'+obsname+'.eps' else $
        figname='figs/ns_ltc_chu_goes_nsl_'+obsname+'.eps'
      set_plot,'ps'
      device, /encapsulated, /color, /isolatin1,/inches, $
        bits=8, xsize=5, ysize=5,file=figname
    endelse

    !p.multi=[0,3,1]
    !p.charsize=1.5
    !p.thick=4
    utplot,timer,[1,1],/ylog,yrange=[5e-4,2],ytitle='NuSTAR Livetime',ytickf='exp1',$
      position=[px1,0.64,px2,0.95],xtit='',xtickf='(a1)',timer=timer,/nodata

    if (nhk gt 0) then outplot,htime,hlive,thick=3,color=3

    for i=0, ngaps-1 do begin
      hgd1=where(anytim(htime) ge anytim(dgtims[0,i]) and anytim(htime) le anytim(dgtims[1,i]),nhgd1)
      if (nhgd1 gt 1) then outplot,htime[hgd1],hlive[hgd1],color=200,thick=3
    endfor

    xyouts, labx,8.5e3,'FPMA',chars=0.7,/device,orien=90,color=3

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
      timer=timer,position=[px1,0.36,px2,0.63],symsize=0.5,xtit='',xtickf='(a1)',thick=2

    for i=0, ngaps-1 do begin
      cgd1=where(anytim(chutime) ge anytim(dgtims[0,i]) and anytim(chutime) le anytim(dgtims[1,i]),ncgd1)
      if (ncgd1 gt 1) then outplot,chutime[cgd1],newmask[cgd1],color=200,thick=2,symsize=0.5,psym=1
    endfor

    ; Want ylog=0 for the GOES panel?
    if Keyword_set(gesnlog) then begin

      utplot,timer,[1,1],ytitle='!3GOES [x10!u-7!N W m!U-2!N]',$
        /nodata,yrange=gyrl,timer=timer,position=[px1,0.08,px2,0.35]
      ;~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if (anytim(timer[0]) gt anytim('01-Jun-2020') and n_elements(gtime16) ge 2) then begin
        outplot,gtime16,glow16*1d7,color=150,thick=4

        for i=0, norbs-1 do begin
          outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
          outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2

          gd1=where(anytim(gtime16) ge anytim(torbs[0,i]) and anytim(gtime16) le anytim(torbs[1,i]),ngd1)
          if (ngd1 gt 1) then outplot,gtime16[gd1],glow16[gd1]*1d7,color=1,thick=4
        endfor

        for i=0, ngaps-1 do begin
          hgd1=where(anytim(gtime16) ge anytim(dgtims[0,i]) and anytim(gtime16) le anytim(dgtims[1,i]),nhgd1)
          if (nhgd1 gt 1) then outplot,gtime16[hgd1],glow16[hgd1]*1d7,color=200,thick=4
        endfor
        xyouts, labx,1.e3,'16: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
      endif
      if (n_elements(gtime15) ge 2)  then begin
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

        xyouts, labx,1.e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
        xyouts, labx,3.0e3,'14: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=4
      endif



    endif else begin

      utplot,timer,[1,1],ytitle='!3GOES [W m!U-2!N]',$
        /ylog,/nodata,yrange=gyr,timer=timer,position=[px1,0.08,px2,0.35]
      ;~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if (anytim(timer[0]) gt anytim('01-Jun-2020') and n_elements(gtime16) ge 2) then begin
        outplot,gtime16,glow16*1d7,color=150,thick=4

        for i=0, norbs-1 do begin
          outplot,[torbs[0,i],torbs[0,i]],gyrl,lines=2,color=0,thick=2
          outplot,[torbs[1,i],torbs[1,i]],gyrl,lines=2,color=0,thick=2

          gd1=where(anytim(gtime16) ge anytim(torbs[0,i]) and anytim(gtime16) le anytim(torbs[1,i]),ngd1)
          if (ngd1 gt 1) then outplot,gtime16[gd1],glow16[gd1]*1d7,color=1,thick=4
        endfor

        for i=0, ngaps-1 do begin
          hgd1=where(anytim(gtime16) ge anytim(dgtims[0,i]) and anytim(gtime16) le anytim(dgtims[1,i]),nhgd1)
          if (nhgd1 gt 1) then outplot,gtime16[hgd1],glow16[hgd1]*1d7,color=200,thick=4
        endfor
        xyouts, labx,1.e3,'16: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
      endif
      if (n_elements(gtime15) ge 2) then begin
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

        xyouts, labx,1.e3,'15: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=1
        xyouts, labx,3.0e3,'14: 1-8 '+string(197b),chars=0.7,/device,orien=90,color=4
      endif

    endelse

    device,/close
    set_plot, mydevice

  endif

end