;+

; read aeronet original data
  dir   = '/home/xxu/Projects/aeronet/case/IRSA-2013/fromAERONET/'
  tlab  = '130101_131231'
  site  = 'Beijing_RADI'
  tlab  = tlab + '_' + site
  f_ppl = tlab + '.ppl'
  ;f_aod = tlab + '.lev20'
  f_aod = tlab + '.lev15'
  f_alm = tlab + '.alm'
  f_ppp = tlab + '.PPP'

; directory to save outputs 
  sdir  = './data/aeronet/'

; switches to turn on/off processing of each data type
  process_aod = 1
  process_alm = 0
  process_ppl = 0
  process_ppp = 0

;======================================================================
; read and process direct-Sun AODs
;======================================================================
  if ( process_aod ) then begin
    nheadline = 4L
    max_read_line = 0L
    process_lev20_aod_simplified, dir+f_aod, site, sdir, $
                                  nheadline, max_read_line, $
                                  aeronet_aod=aeronet_aod
  endif


;======================================================================
; read and process almucantar radiances
;======================================================================
  if ( process_alm ) then begin
    nheadline = 3L
    max_read_line = 0L
    process_alm_simplified, dir+f_alm, site, sdir, $
                            nheadline, max_read_line
  endif

;======================================================================
; read and process principle-plane radiances
;======================================================================
  if ( process_ppl ) then begin
    nheadline = 3L
    max_read_line = 0L
    process_ppl_simplified, dir+f_ppl, site, sdir, $
                            nheadline, max_read_line, $
                            std_sca=std_sca, aeronet_ppl=aeronet_ppl
  endif

;======================================================================
; read and process polarization 
;======================================================================
  if ( process_ppp ) then begin
    nheadline = 3L
    max_read_line = 0L
    process_ppp_simplified, dir+f_ppp, site, sdir, $
                            nheadline, max_read_line, $
                            std_vza=std_vza, aeronet_ppp=aeronet_ppp
  endif


; end of program
  end

