;+
; read_irsa_aod.pro 
;    - reads the data of AOD provided by Li Li
;    - filter data (level 1.5, and etc)
;    - save to netcdf file for daily, and annually

  ; file to be read
  filename = '../case/IRSA-2013/0000IRSA.aod_2013'

  ; read all columnes
  readcol, filename, c1, c2, c3, c4, c5, c6, $
                     c7, c8, c9, c10, c11, c12, $
                     c13, c14, c15, c16, c17, c18, $
                     format='A,A,F,F,F,F,  F,F,F,F,F,F,  F,F,F,F,F,F'

  ; total number of raw data
  n0 = n_elements(c1)

  ; convert time variables
  strdate2ymd, c1, c2, nymd, nhms, date_form='dd/mm/yyyy'
  nymd0 = nymd  ; to aviod change of nymd in day_of_year  

  doy  = lonarr(n0) ; day of year
  dfrc = fltarr(n0) ; day fraction
  for i = 0, n0-1 do begin
    doy[i] = day_of_year( nymd0[i] )
    dfrc[i] = day_fraction( nhms[i] )
  endfor

  ; data filter 
  lev = c6 
  tau870 = c11   ; & tau440 = c13
  index = where( lev eq 1.5 and tau870 gt 0.0, ct)

  for i = 0, ct-1 do begin

    tmp = { nymd:nymd[i], $
            nhms:nhms[i], $
            doy:doy[i],  $
            dfrc:dfrc[i], $
            sza:c4[i], $
            t:c5[i], $
            uh2o:c7[i], $
            alpha:c8[i], $
            tau1020:c9[i], $
            tau1638:c10[i], $
            tau870:c11[i], $
            tau674:c12[i], $
            tau441:c13[i], $
            tau500:c14[i], $
            tau380:c17[i], $
            tau340:c18[i] }  
    if i eq 0 then aod = tmp else aod = [aod,tmp]

  endfor

  ; save the annual file
  ncdir = './data/'
  ncfile = ncdir + 'IRSA_2013_AOD15'
  write_netcdf, aod, ncfile+'.nc', status, /clobber
  save, aod, filename=ncfile+'.sav'

  ; get daily data and save to netcdf
  uniq_id = uniq( aod.nymd )
  ndays   = n_elements( uniq_id ) 

  for iday = 0, ndays-1 do begin

    ; now just do the annual, if need daily data in the future, I will do it

  endfor

  ; end
  end

