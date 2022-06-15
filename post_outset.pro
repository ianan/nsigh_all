clearplot
!y.range=0
!x.range=0
!p.title=''
!x.title=''
!y.title=''
!y.style=17
!x.style=17
if (!version.os_family eq 'Windows') then set_plot,'win' else set_plot,'x'
device,retain=2, decomposed=0
mydevice = !d.name
;; Make IDL use device/hardware fonts
!P.FONT = 0
;; Other things to make graphs nicer
!P.COLOR = 255  ;255 for white line
!P.BACKGROUND = 0   ;0 for balck background
!P.THICK = 1
!P.CHARTHICK = 1
!P.CHARSIZE = 1.
!p.symsize=1