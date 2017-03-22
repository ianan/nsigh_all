pro batch_maps

  for i=0,8 do heasarc_ns_sc,obs_id=i
  for i=0,8 do make_ns_maps_hc,obs_id=i
  for i=0,8 do make_ns_maps_comb_hc,obs_id=i,fpm='A'
  for i=0,8 do make_ns_maps_comb_hc,obs_id=i,fpm='B'
  for i=0,8 do plot_ns_maps_hc,obs_id=i
  
  stop
end