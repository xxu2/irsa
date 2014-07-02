;+

  filename = '../case/IRSA-2013/0000IRSA.alm.rad_2013'

  read_aeronet, filename, 0, head, data, nobs, $
                ;read_first_lines=0L, $
                label_separation=' '

  ; define a standard azms
  ;std_azm = [ 3.0,   3.5,   4.0,   5.0,   6.0, $
  ;            7.0,   8.0,  10.0,  12.0,  14.0,  16.0,  18.0,  20.0, $
  ;           25.0,  30.0,  35.0,  40.0,  45.0,  50.0,  60.0,  70.0, $
  ;           80.0,  90.0, 100.0, 120.0, 140.0, 160.0, 180.0 ]
  std_azm = get_alm_std_azm()
  nstd_azm = n_elements(std_azm)

  ; define azimuthal angles
  alm_azms = float( head[3:32] )

  ; get index in azms for standard set of azm
  index_azm = lonarr(nstd_azm)
  for j = 0, nstd_azm-1 do begin
    index1 = where( alm_azms eq std_azm[j] )
    index_azm[j] = index1[0]
  endfor

  ; define a structure
  alm = {dmy:'', hms:'', nymd:0, nhms:0, doy:0, dfrc:0.0,$
         t:fltarr(2), lamda:0.0, radiance:fltarr(30,2)}
  alm = replicate(alm,nobs)

  for i = 0, nobs-1 do begin

   
    str_dmy = strtrim( data[0,i], 2 )
    str_hms = strtrim( data[1,i], 2 )
    
    strdate2ymd, str_dmy, str_hms, nymd, nhms, date_form='dd/mm/yyyy'
    nymd0 = nymd
    nhms0 = nhms   

    radiance_left  = float( data[3:32,i] )
    radiance_right = float( data[34:63,i] )
    
    tmp = { nymd:nymd, nhms:nhms, $
            doy: day_of_year( nymd0 ), $
            dfrc: day_fraction( nhms0 ), $
            lamda: float( data[2,i] ), $
            t: float( data[33,i] ), $
            radiance_left: radiance_left[index_azm], $
            radiance_right: radiance_right[index_azm] }
    if i eq 0 then alm = tmp else alm = [alm, tmp]
    
    print, '--> ', strtrim(i+1,2), ' / ', strtrim(nobs,2)  

  endfor

  ; save the annual file
  ncdir = './data/'
  ncfile = ncdir + 'IRSA_2013_ALM'
  write_netcdf, alm, ncfile+'.nc', status, /clobber
  save, alm, std_azm, filename=ncfile+'.sav'
    
  set_plot, 'X'
  window, 1
  plot, std_azm, alm[0].radiance_left, $
        color=1, charsize=1, /nodata, $
        psym=sym(6), symsize=0.5, $
        yrange=[1d-2,5], ystyle=1, /ylog, $
        xrange=[-180,180], xstyle=1, $
        position=[0.1,0.1,0.9,0.9], min_value=1d-5

  for i = 0, 4 do begin
      oplot, std_azm, alm[i].radiance_left,psym=sym(6), symsize=0.6, color=i+1, min_value=1d-5
      oplot, -std_azm, alm[i].radiance_right,psym=sym(6), symsize=0.6, color=i+1, min_value=1d-5 
  endfor
 

  ; end of program
  end
