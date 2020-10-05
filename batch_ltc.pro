pro batch_ltc

  ; some examples of using plot_ns_sun_lc
  ; make a NuSTAR livetime, GOES, RHESSI 3 panel plot
  ; and (posisbly) a single GOES plot

  ; Note - if the *.dat files for the date are not in the working dir will
  ; need to point maindir to you nustar data
  ; and have executed search_network,/enabled to get the rhessi data

  ; For 2018 onwards observations use plot_ns_sun_lc_rnm.pro, as shown below

  ; 23-Feb-2016 - IGH
  ; 17-May-2016 - IGH   Added in Apr 2016 data
  ; 03-Aug-2016 - IGH   Added in Jul 2016 data
  ; 22-Mar-2017 - IGH   Added in Mar 2017 data
  ; 25-Sep-2017 - IGH   Added in Aug 2017 data
  ; 26-Sep-2017 - IGH   Added in Sep 2017 data
  ; 18-Oct-2017 - IGH   Added in Oct 2017 data
  ; 03-Jun-2018 - IGH   Added in May 2018 data
  ; 10-Sep-2018 - IGH   Added in Sep 2018 data
  ; 29-Sep-2018 - IGH   Added in Sep 2018 data, QS 28th
  ; 03-Jan-2019 - IGH   Highlighted use of *_rnm code for 2018+
  ; 12-Jan-2019 - IGH   Added in Jan 2019 data
  ; 20-Apr-2019 - IGH   Added in Apr 2019 data
  ; 10-May-2019 - IGH   Added in Apr 2019 QS data
  ; 14-Feb-2020 - IGH   Added in Jan 2020 data
  ; 11-Mar-2020 - IGH   Added in Feb 2020 data
  ; 02-Jul-2020 - IGH   Added in Jun 2020 data
  ; 05-Oct-2020 - IGH   Added in Sep 2020 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  
  plot_ns_sun_lc_rnm, obsname='202009',tav=10,/gesnlog,/chudo,/goes
  plot_ns_sun_lc_rnm, obsname='202009',tav=10,/gesnlog,/chudo,/goes,/wid

;  plot_ns_sun_lc_rnm, obsname='202006_06',tav=10,/gesnlog,/chudo,/goes
;  plot_ns_sun_lc_rnm, obsname='202006_07',tav=10,/gesnlog,/chudo,/goes
;  plot_ns_sun_lc_rnm, obsname='202006_08',tav=10,/gesnlog,/chudo,/goes
;  plot_ns_sun_lc_rnm, obsname='202006_09',tav=10,/gesnlog,/chudo,/goes

  ;; Variant that work if no GOES data online just do a single plot of livetime and CHU
  ;  plot_ns_sun_lc_rnm_ng,obsname='201901'
  ;  plot_ns_sun_lc_rnm, obsname='201901',tav=10,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201901',tav=10,/gesnlog,/chudo

  ;  plot_ns_sun_lc_rnm_ng,obsname='20190425'
  ; Older versions below - which had some RHESSI

  ;  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  ;  plot_ns_sun_lc, obsname='201409',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201411',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201412',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201504',tav=10,/goes
  ;  ;  plot_ns_sun_lc, obsname='201509',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201509_01',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201509_02',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201602',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201604',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201607',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201703',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201708',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201709_11',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201709_12',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201709_13',tav=10,/goes
  ;  plot_ns_sun_lc, obsname='201710',tav=10,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201805',tav=10,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_07',tav=10,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_09',tav=10,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_10',tav=10,/goes


  ;
  ;
  ;  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  ;  plot_ns_sun_lc, obsname='201409',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201411',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201412',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201504',tav=10,/gesnlog,/chudo
  ;  ;  plot_ns_sun_lc, obsname='201509',tav=10,/gesnlog
  ;  plot_ns_sun_lc, obsname='201509_01',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201509_02',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201602',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201604',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201607',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201703',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201708',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_11',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_12',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_13',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201710',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201805',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_07',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_09',tav=10,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_10',tav=10,/gesnlog,/chudo





  stop
end