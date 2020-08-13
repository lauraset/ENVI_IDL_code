pro y_envi2tif
  ;2020.08.13
  ; convert envi to tif
  compile_opt idl2
  e = ENVI(/headless)
  ;TODO auto-generated stub

  ipath='F:\yinxcao\dpan'
  filelist=file_search(ipath, 'mux_quacs', count=countall)
     
  for i=0, countall-1 do begin
    file=filelist[i]
    filedir=file_dirname(file)
    dataall=[file, filedir+'\nads', filedir+'\fwds', filedir+'\bwds']
    print, 'process:', file
    t1 = SYSTIME(/second)
    for j=0, 3 do begin
      idata=dataall[j]+'1.tif'
      if file_test(idata) eq 0 then begin
        data=e.openraster(dataall[j])
        data.export, idata, 'tif'
        data.close
        print, 'success:', idata
      endif
     endfor
     t2 = SYSTIME(/second)
     print, 'success:', file
     print, 'total time: ', t2-t1
   endfor
 
end