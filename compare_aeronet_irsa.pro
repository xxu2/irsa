;+
; Compare the data provided by Li Li and the data downloaded from 
;  AERONET website. 
;  - Here focus on a day
; 

  ; controls
  plot_obs_sequence = 1

  ; specify the date 
  nymd0 = 20130317L
  nhms0 = 032523L
  dfrc0 = day_fraction( nhms0 )
  ddfrc1 = 0.005
  ddfrc2 = 0.015

  ; specify the files to read
  dir1 = './data/'
  dir2 = './data/aeronet/'
  
  f_aod1 = dir1 + 'IRSA_2013_AOD15.sav'
  f_alm1 = dir1 + 'IRSA_2013_ALM.sav'
  f_ppp1 = dir1 + 'IRSA_2013_PPP.sav'
  f_aod2 = dir2 + 'AERONET_2013_AOD.sav'
  f_alm2 = dir2 + 'AERONET_2013_ALM.sav'
  f_ppp2 = dir2 + 'AERONET_2013_PPP.sav'

  ; read data
  restore, f_aod1  ; aod
  restore, f_alm1  ; alm, irsa
  restore, f_ppp1  ; ppp, irsa
  restore, f_aod2  ; aeronet_aod
  restore, f_alm2  ; aeronet_alm
  restore, f_ppp2  ; aeronet_ppp

  ; structure names
  str_names = [ 'aod', 'alm', 'ppp', $
                'aeronet_aod', 'aeronet_alm', 'aeronet_ppp' ]

  ; find data for day nymd0
  ;index = where( aod.nymd eq nymd0, ct )
  ;if ct gt 0 then aod = aod[index]
  for i = 0, n_elements(str_names)-1 do begin

     com1 = 'index = where( ' + str_names[i] + '.nymd eq nymd0, ct )' 
     com2 = 'if ct gt 0 then ' + str_names[i] + '_ymd0 = ' + str_names[i] + '[index]'
     void1 = execute( com1 )
     void2 = execute( com2 )

  endfor

  ; find data from this_ymd  for this nhms0
  ;index = where( this_aod.dfrc ge dfrc0-ddfrc0 and this_aod.dfrc le dfrc0-ddfrc0  ct )
  ;if ct gt 0 then aod = aod[index]
  for i = 0, n_elements(str_names)-1 do begin

     if ( str_names[i] eq 'aod' or str_names[i] eq 'aeronet_aod' ) then $
       factor = 2.0 $
     else $
       factor = 1.0
 
     max_dfrc = dfrc0 + factor * ddfrc2
     min_dfrc = dfrc0 - factor * ddfrc1

     com3 = 'index = where( ' + str_names[i] + '_ymd0.dfrc ge min_dfrc and ' $
                              + str_names[i] + '_ymd0.dfrc le max_dfrc, ct )'
     com4 = 'if ct gt 0 then ' + str_names[i] + '_hms0 = ' + str_names[i] + '_ymd0[index]'
     void3 = execute( com3 )
     void4 = execute( com4 )

  endfor

  ; take a look the observation sequence
  if ( plot_obs_sequence ) then begin
  
    set_plot, 'X'
    window, 1, xsize=1200, ysize=600
    ymax = max( aeronet_aod_ymd0.tau441 )
    ymin = min( aeronet_aod_ymd0.tau441)
    ydis = ymax - ymin
    yrange = [ 0, ymax + 0.4*ydis]
    
    plot, aeronet_aod_ymd0.dfrc, aeronet_aod_ymd0.tau441, $
          color=1, psym=sym(6), $
          xrange=[0,0.4], xstyle=1, $
          yrange=yrange, ystyle=1 
    oplot, aod_ymd0.dfrc, aod_ymd0.tau441, psym=sym(6), color=3
    oplot, aeronet_alm_ymd0.dfrc, fltarr(n_elements(aeronet_alm_ymd0))+2.2, color=1, psym=sym(11)
    oplot, alm_ymd0.dfrc, fltarr(n_elements(alm_ymd0))+2, color=3, psym=sym(11)
    oplot, ppp_ymd0.dfrc, fltarr(n_elements(ppp_ymd0))+1, color=3, psym=sym(11)
    oplot, aeronet_ppp_ymd0.dfrc, fltarr(n_elements(aeronet_ppp_ymd0))+1.2, color=1, psym=sym(11)

  endif


  ; end of program
  end
