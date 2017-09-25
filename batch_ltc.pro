pro batch_ltc

  ; some examples of using plot_ns_sun_lc
  ; make a NuSTAR livetime, GOES, RHESSI 3 panel plot
  ; and (posisbly) a single GOES plot

  ; Note - if the *.dat files for the date aren't in the working dir will
  ; need to point maindir to you nustar data
  ; and have executed search_network,/enabled to get the rhessi data

  ; 23-Feb-2016 - IGH
  ; 17-May-2016 - IGH   Added in Apr 2016 data
  ; 03-Aug-2016 - IGH   Added in Jul 2016 data
  ; 22-Mar-2017 - IGH   Added in Mar 2017 data
  ; 25-Sep-2017 - IGH   Added in Aug 2017 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  plot_ns_sun_lc, obsname='201409',gav=5,/goes
  plot_ns_sun_lc, obsname='201411',gav=5,/goes
  plot_ns_sun_lc, obsname='201412',gav=5,/goes
  plot_ns_sun_lc, obsname='201504',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201509',gav=5,/goes
  plot_ns_sun_lc, obsname='201509_01',gav=5,/goes
  plot_ns_sun_lc, obsname='201509_02',gav=5,/goes
  plot_ns_sun_lc, obsname='201602',gav=5,/goes
  plot_ns_sun_lc, obsname='201604',gav=5,/goes
  plot_ns_sun_lc, obsname='201607',gav=5,/goes
  plot_ns_sun_lc, obsname='201703',gav=5,/goes
  plot_ns_sun_lc, obsname='201708',gav=5,/goes

  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  plot_ns_sun_lc, obsname='201409',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201411',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201412',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201504',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201509',gav=5,/gesnlog
  plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201509_02',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201602',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201604',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201607',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201703',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201708',gav=5,/gesnlog,/chudo

  stop
end