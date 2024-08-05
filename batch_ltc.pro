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
  ; 22-Feb-2021 - IGH   Added in Jan 2021 data
  ; 26-May-2021 - IGH   Added in Apr/May 2021 data
  ; 26-Jul-2021 - IGH   Added in 20 Jul 2021 data
  ; 15-Aug-2021 - IGH   Added in 30 Jul 2021 data
  ; 30-Jan-2022 - IGH   Added in Nov 2021 data
  ; 31-Jan-2022 - IGH   Reran all data to use better G14/15/16 (NOAA avg1min)
  ; 28-Mar-2022 - IGH   Added in Feb 2022 data
  ; 16-Jun-2022 - IGH   Added in Jun 2022 data
  ; 03-Oct-2022 - IGH   Added in Sep 2022 data
  ; 02-Jan-2023 - IGH   Added in Dec 2022 data
  ; 28-Mar-2023 - IGH   Added in Mar 2023 data
  ; 30-Jan-2024 - IGH   Added in Dec 2023 data
  ; 15-May-2024 - IGH   Added in Mar 2024 data
  ; 12-Jul-2024 - IGH   Added in Jun 2024 data
  ; 05-Aug-2024 IGH - Added in Jul 2024 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  plot_ns_sun_lc_rnm, obsname='202407_16',/gesnlog,/chudo,/goes

;  plot_ns_sun_lc_rnm, obsname='202406_30',/gesnlog,/chudo,/goes

  ;  plot_ns_sun_lc_rnm, obsname='202403_30',/gesnlog,/chudo,/goes

  ;  plot_ns_sun_lc_rnm, obsname='202312_28',/gesnlog,/chudo,/goes

  ;  plot_ns_sun_lc_rnm, obsname='202303_18',/gesnlog,/chudo,/goes

  ;  plot_ns_sun_lc_rnm, obsname='202212_09',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202212_11',/gesnlog,/chudo,/goes


  ;  plot_ns_sun_lc_rnm, obsname='202209_06',/gesnlog,/chudo,/goes,maindir='~/data/heasarc_nustar/'

  ;  plot_ns_sun_lc_rnm, obsname='202206_03',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202206_03',/gesnlog,/chudo,/goes,/wid

  ;  plot_ns_sun_lc_rnm, obsname='202202_24',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202202_25',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202202_26',/gesnlog,/chudo,/goes
  ;
  ;  ;  plot_ns_sun_lc_rnm, obsname='202111_17',/gesnlog,/chudo,/goes
  ;  ;  plot_ns_sun_lc_rnm, obsname='202111_19',/gesnlog,/chudo,/goes
  ;  ;  plot_ns_sun_lc_rnm, obsname='202111_21',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202107_30',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202107_20',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202107_20',/gesnlog,/chudo,/goes,/wid
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202104_29',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202105_03',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202105_07',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202101_08',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202101_14',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202101_20',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202009',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202009',/gesnlog,/chudo,/goes,/wid
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202006_06',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202006_07',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202006_08',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202006_09',/gesnlog,/chudo,/goes
  ;
  ;  ; These ones using G14/15, though 16 available
  ;  plot_ns_sun_lc_rnm, obsname='202002',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202002',/gesnlog,/chudo,/goes,/wid
  ;
  ;  plot_ns_sun_lc_rnm, obsname='202001',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='202001',/gesnlog,/chudo,/goes,/wid
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201907',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='20190425',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='20190425',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201904',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201901',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201809_28',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201809_10',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_09',/gesnlog,/chudo,/goes
  ;  plot_ns_sun_lc_rnm, obsname='201809_07',/gesnlog,/chudo,/goes
  ;
  ;  plot_ns_sun_lc_rnm, obsname='201805',/gesnlog,/chudo,/goes
  ;
  ;  ; These ones using G15 (and also RHESSI!)
  ;  plot_ns_sun_lc, obsname='201710',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201709_11',/goes,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_12',/goes,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201709_13',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201708',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201703',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201607',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201604',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201509_01',/goes,/gesnlog,/chudo
  ;  plot_ns_sun_lc, obsname='201509_02',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201504',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201412',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201411',/goes,/gesnlog,/chudo
  ;
  ;  plot_ns_sun_lc, obsname='201409',/goes,/gesnlog,/chudo

  stop
end