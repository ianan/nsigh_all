pro tube_line_colors,test=test

  ; 21-Nov-12 IGH;
  ; linecolors based on tfl tubes lines (and dlt, over etc)
  ;http://www.tfl.gov.uk/assets/downloads/corporate/tfl-colour-standard-issue03.pdf
  ; /test shows the line colors

  loadct,0,/silent
  tvlct,rrr,ggg,bbb,/get
  
  tcols=[$
    [  0,  0,  0],$ ;Northern
    [227, 32, 23],$ ;Central
    [  0, 34,136],$ ;Piccadilly
    [  0,120, 42],$ ;District
    [232,106, 16],$ ;Overground
    [  0,160,226],$ ;Victoria
    [215,153,175],$ ;Hammersmith & City
    [118,208,189],$ ;Waterloo & City
    [117, 16, 86],$ ;Metropolitan
    [255,206,  0],$ ;Circle
    [134,143,152],$ ;Jubilee
    [137, 78, 36],$ ;Bakerloo  
  ;  [  0,175,173],$ ;DLR not included as similar to Waterloo & City
    [  0,189, 25] $ ;Tramlink  
    ]
    
  for i=0, n_elements(tcols[0,*])-1 do begin
      rrr[i]=tcols[0,i]
      ggg[i]=tcols[1,i]
      bbb[i]=tcols[2,i]
    endfor
    
  tvlct,rrr,ggg,bbb
  
  if keyword_set(test) then begin 
    clearplot
    !p.multi=0
    plot,[0,1],[0,14],/nodata,xtickf='(a1)',chars=2
    for i=0, n_elements(tcols[0,*])-1 do oplot, [0,1],i*[1,1],color=i,thick=10
  endif
  
  return
end
