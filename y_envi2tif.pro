pro y_envi2tif, filepath,filepattern
  ; 2020.08.13
  ; convert envi to tif
  compile_opt idl2
  e = ENVI(/headless)
  ;TODO auto-generated stub

  filelist=file_search(filepath, filepattern, count=countall)
     
  for i=0, countall-1 do begin
    file=filelist[i]
    print, 'process:', file
    t1 = SYSTIME(/second)
    idata=file+'1.tif'
    if file_test(idata) eq 0 then begin
      data=e.openraster(file)
      data.export, idata, 'tif'
      data.close
      print, 'success:', idata
    endif
     t2 = SYSTIME(/second)
     print, 'success:', file
     print, 'total time: ', t2-t1
   endfor
 
end
