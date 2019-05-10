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
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  ; As no GOES data online just do a single plot of livetime and CHU
;  plot_ns_sun_lc_rnm_ng,obsname='201901'
;  plot_ns_sun_lc_rnm, obsname='201901',gav=5,/goes
;  plot_ns_sun_lc_rnm, obsname='201901',gav=5,/gesnlog,/chudo
  
plot_ns_sun_lc_rnm_ng,obsname='20190425'
plot_ns_sun_lc_rnm, obsname='20190425',gav=5,/goes
plot_ns_sun_lc_rnm, obsname='20190425',gav=5,/gesnlog,/chudo

  ;  ; For April 2019 back to a time with some activity and GOES
  ;  plot_ns_sun_lc_rnm, obsname='201904',gav=5,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201904',gav=5,/gesnlog,/chudo


  ; ;  plot_ns_sun_lc_rnm, obsname='201901',gav=5,/goes
  ;;    plot_ns_sun_lc_rnm, obsname='201901',gav=5,/gesnlog,/chudo

  ;    plot_ns_sun_lc_rnm, obsname='201809_28',gav=5,/goes
  ;    plot_ns_sun_lc_rnm, obsname='201809_28',gav=5,/gesnlog,/chudo
  ;
  ;  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  ;  plot_ns_sun_lc, obsname='201409',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201411',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201412',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201504',gav=5,/goes
  ;  ;  plot_ns_sun_lc, obsname='201509',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201509_01',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201509_02',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201602',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201604',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201607',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201703',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201708',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201709_11',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201709_12',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201709_13',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201710',gav=5,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201805',gav=5,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_07',gav=5,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_09',gav=5,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_10',gav=5,/goes


  ;
  ;
  ;  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  ;  plot_ns_sun_lc, obsname='201409',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201411',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201412',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201504',gav=5,/gesnlog,/chudo
  ;  ;  plot_ns_sun_lc, obsname='201509',gav=5,/gesnlog
  ;  plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201509_02',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201602',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201604',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201607',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201703',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201708',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_11',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_12',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_13',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201710',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201805',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_07',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_09',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc_rnm, obsname='201809_10',gav=5,/gesnlog,/chudo





  stop
end