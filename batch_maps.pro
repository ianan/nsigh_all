pro batch_maps

  ; Make the nice overview maps and produce the summary info files
  ;
  ; 25-Sep-2017 IGH - Updated to include the Aug 2017 data
  ; 26-Sep-2017 IGH - Updated to include the Sep 2017 data
  ; 18-Oct-2017 IGH - Added in Oct 2017 data
  ; 03-Jun-2018 IGH - Added in May 2018 data
  ; 10-Sep-2018 IGH - Updated with Sep 2018 data
  ; 29-Sep-2018 IGH - Updated with Sep 2018 data, QS 28th
  ; 12-Jan-2019 IGH - Added in Jan 2019 data
  ; 20-Apr-2019 IGH - Added in Apr 2019 data
  ; 10-May-2019 IGH - Added in Apr 2019 QS data
  ; 16-Jul-2019 IGH - Added in Jul 2019 QS data
  ; 14-Feb-2020 IGH - Added in Jan 2020 data
  ; 11-Mar-2020 IGH - Updated for Feb 2020
  ; 05-Oct-2020 IGH - Updated for Oct 2020
  ; 22-Feb-2021 IGH - Added in Jan 2021 data
  ; 26-May-2021 IGH - Added in Apr/May 2021 data
  ; 26-Jul-2021 IGH - Added in 20 Jul 2021 data
  ; 15-Aug-2021 IGH - Added in 30 Jul 2021 data
  ; 30-Jan-2022 IGH - Added in Nov 2021 data
  ; 28-Mar-2022 IGH - Added in Feb 2022 data
  ; 16-Jun-2022 IGH - Added in Jun 2022 data
  ; 03-Oct-2022 IGH - Added in Sep 2022 data
  ; 02-Jan-2023 IGH - Added in Dec 2023 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ;  nf=10
  ; Only need to do this if not already converted the files to solar coordinates
  ; for i=0,nf-1 do heasarc_ns_sc,obs_id=i
  ;  for i=0,nf-1 do make_ns_maps_hc,obs_id=i
  ;  for i=0,nf-1 do make_ns_maps_comb_hc,obs_id=i,fpm='A'
  ;  for i=0,nf-1 do make_ns_maps_comb_hc,obs_id=i,fpm='B'
  ;  for i=0,nf-1 do plot_ns_maps_hc,obs_id=i

  i=31
  make_ns_maps_hc,obs_id=i
  make_ns_maps_comb_hc,obs_id=i,fpm='A'
  make_ns_maps_comb_hc,obs_id=i,fpm='B'
  plot_ns_maps_hc,obs_id=i

  stop
end