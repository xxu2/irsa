;+

  filename = '../case/IRSA-2013/0000IRSA.ppp.dop_2013'

  read_aeronet, filename, 0, head, data, nobs, $
                label_separation=' ' ;, read_first_lines=10

  ; define a structure
  ppp = {dmy:'', hms:'', nymd:0L, nhms:0L, doy:0L, dfrc:0.0,$
         t:0.0, lamda:0.0, dop:fltarr(35)}
  ppp = replicate(ppp,nobs)

  ; define azimuthal angles
  ppp_vzas = float( head[3:37] )

  for i = 0, nobs-1 do begin

    ppp[i].dmy = strtrim( data[0,i], 2 )
    ppp[i].hms = strtrim( data[1,i], 2 )
    ppp[i].lamda = float( data[2,i] )
    ppp[i].dop = float( data[3:37,i] )
    ppp[i].t = float( data[38,i] )
    
    strdate2ymd, ppp[i].dmy, ppp[i].hms, $
                 nymd, nhms, date_form='dd/mm/yyyy'
    ppp[i].nymd = nymd
    ppp[i].nhms = nhms
    ppp[i].doy = day_of_year( nymd )
    ppp[i].dfrc = day_fraction( nhms )
   
    print, '--> ', strtrim(i+1,2), ' / ', strtrim(nobs,2)  

  endfor

  ; save the annual file
  ncdir = './data/'
  ncfile = ncdir + 'IRSA_2013_PPP'
  write_netcdf, ppp, ncfile+'.nc', status, /clobber
  save, ppp, ppp_vzas, filename=ncfile+'.sav'
    
  set_plot, 'X'
  window, 1
  plot, ppp_vzas, ppp[0].dop, $
        color=1, charsize=1, /nodata, $
        psym=sym(6), symsize=0.5, $
        yrange=[0,1], ystyle=1, $
        xrange=[-90,90], xstyle=1, $
        position=[0.1,0.1,0.9,0.9], min_value=1d-5

  for i = 0, 4 do begin
      oplot, ppp_vzas, ppp[i].dop,psym=sym(6), symsize=0.6, color=i+1
  endfor
 

  ; end of program
  end
