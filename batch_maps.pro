pro batch_maps

  ; Make the nice overview maps and produce the summary info files
  ;
  ; 25-Sep-2017 IGH Updated to include the Aug 2017 data
  ; 26-Sep-2017 IGH Updated to include the Sep 2017 data
  ; 18-Oct-2017 IGH Added in Oct 2017 data
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ;  nf=10
  ; Only need to do this if not already converted the files to solar coordinates
  ; for i=0,nf-1 do heasarc_ns_sc,obs_id=i
  ;  for i=0,nf-1 do make_ns_maps_hc,obs_id=i
  ;  for i=0,nf-1 do make_ns_maps_comb_hc,obs_id=i,fpm='A'
  ;  for i=0,nf-1 do make_ns_maps_comb_hc,obs_id=i,fpm='B'
  ;  for i=0,nf-1 do plot_ns_maps_hc,obs_id=i

  i=11
  make_ns_maps_hc,obs_id=i
  make_ns_maps_comb_hc,obs_id=i,fpm='A'
  make_ns_maps_comb_hc,obs_id=i,fpm='B'
  plot_ns_maps_hc,obs_id=i

  stop
end