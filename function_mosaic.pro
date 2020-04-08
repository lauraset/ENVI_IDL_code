;README
;used for batch mosaicing with sentinel-2 images (band by band)
;usage: function_mosaic(['/20200131_1/B1','/20200131_2/B1'],'/20200131/B1_mosaic')
;requirement: ENVI/IDL 5.3 or higher
;reference: the reference book of envi/idl software
;coded by Yinxiacao
;date: April 8, 2020

FUNCTION function_mosaic,files,outpath
  COMPILE_OPT IDL2
  ; Start the application
  e = ENVI()
  FOR i=0, N_ELEMENTS(files)-1 DO BEGIN
    IF FILE_TEST(files[i])  EQ 0 THEN RETURN, 0 ;IF THE INPUT FILE NOT EXIST
  ENDFOR
  ; Select input scenes 
  ;files = REVERSE(FILE_SEARCH(inpath, inname))
  scenes = !NULL
  FOR i=0, N_ELEMENTS(files)-1 DO BEGIN
    raster = e.OpenRaster(files[i])
    ;query and update the data ignore value
    metadata = raster.METADATA
    pos = WHERE(STRCMP(metadata.tags, 'data ignore value', /FOLD_CASE), $  
       isDataIgnoreExists)   
    IF (isDataIgnoreExists) THEN BEGIN   
       metadata.UpdateItem, 'data ignore value', 0   
    ENDIF ELSE BEGIN   
       metadata.AddItem, 'data ignore value', 0   
    ENDELSE
    scenes = [scenes, raster]
  ENDFOR
  ; Get the task from the catalog of ENVITasks
  Task = ENVITask('BuildMosaicRaster')
  ; Define inputs 
  Task.INPUT_RASTERS = scenes ; the first scene will be set as the reference image
  Task.COLOR_MATCHING_METHOD = 'Histogram Matching' 
  ;Task.COLOR_MATCHING_STATISTICS = 'Entire Scene'  default value is overlapping area (10% overlap)
  Task.FEATHERING_METHOD = 'Seamline'
  Task.FEATHERING_DISTANCE = 20+intarr(N_ELEMENTS(files))  ; 20 (parameter): to blend 20 pixels
  Task.SEAMLINE_METHOD = 'Geometry'
  ; Define outputs 
  Task.OUTPUT_RASTER_URI = outpath;
  ; Run the task 
  Task.Execute
  ;print('success')
  ;close files
  FOR i=0, N_ELEMENTS(scenes)-1 DO BEGIN
    scenes[i].Close
  ENDFOR
  return, 1
end
