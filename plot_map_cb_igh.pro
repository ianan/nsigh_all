pro plot_map_cb_igh, prange, bottom, ncolors, cb_title=cb_title, log=log, $
  charsize=charsize, position=position, color=color, format=format,_extra=extra,plchars=plchars,major=major

  colorbar = obj_new('colorbar2', title=cb_title,font=0)
  default, charsize, 1.
  if (size(format,/type) ne 7) then begin
    format = '(f8.1)'
    if max(abs(prange)) gt 9999. then format='(i6)'
    if max(abs(prange)) gt 99999. then format='(g9.2)'
    if max(abs(prange)) lt 100. then format='(f8.2)'
    if max(abs(prange)) lt 1. then format='(g9.2)'
  endif
  datarange = float(prange)
  if abs(datarange[1]-datarange[0]) lt 1.e-6  then datarange[1] = datarange[0] + .001
  colorbar -> setproperty, range=datarange,position=position, $
    bottom=bottom, ncolors=ncolors, ticklen=-.2, format=format, log=log, color=color,major=major
  ytitle_sav = !y.title
  ; colorbar draw uses xcharsize which is a scaling factor on !p.charsize, so don't
  ; pass charsize in through set - if !p.charsize is already set, characters will be huge
  pcharsize_sav = !p.charsize
  !y.title = ''
  if (n_elements(plchars) eq 1) then !p.charsize=plchars else !p.charsize = .8 * charsize
  colorbar -> draw
  !y.title = ytitle_sav
  !p.charsize = pcharsize_sav
  obj_destroy, colorbar

end