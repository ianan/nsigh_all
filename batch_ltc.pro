pro batch_ltc

  ; some examples of using plot_ns_sun_lc
  ; make a NuSTAR livetime, GOES, RHESSI 3 panel plot
  ; and (posisbly) a single GOES plot

  ; Note - if the *.dat files for the date aren't in the working dir will
  ; need to point maindir to you nustar data
  ; and have executed search_network,/enabled to get the rhessi data
  
  ; 23-Feb-2016 - IGH

  ; Do 10sec average of GOES (2sec *5) and with additional single goes plot
  plot_ns_sun_lc, obsname='201409',gav=5,/goes
  plot_ns_sun_lc, obsname='201411',gav=5,/goes
  plot_ns_sun_lc, obsname='201412',gav=5,/goes
  plot_ns_sun_lc, obsname='201504',gav=5,/goes
  ;  plot_ns_sun_lc, obsname='201509',gav=5,/goes
  plot_ns_sun_lc, obsname='201509_01',gav=5,/goes
  plot_ns_sun_lc, obsname='201509_02',gav=5,/goes
  plot_ns_sun_lc, obsname='201602',gav=5,/goes

  ; Do 10sec average of GOES (2sec *5) and non-ylog in the GOES panel and with the extra plot with the CHU panel
  plot_ns_sun_lc, obsname='201409',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201411',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201412',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201504',gav=5,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201509',gav=5,/gesnlog
  plot_ns_sun_lc, obsname='201509_01',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201509_02',gav=5,/gesnlog,/chudo
  plot_ns_sun_lc, obsname='201602',gav=5,/gesnlog,/chudo

  stop
end