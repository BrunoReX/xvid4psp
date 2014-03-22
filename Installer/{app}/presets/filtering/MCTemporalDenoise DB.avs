#avstp.dll
#FFT3DFilter.dll
#FFT3dgpu.dll
#RepairSSE2.dll
#RemoveGrainSSE2.dll
#mvtools2mod.dll
#TTempsmooth.dll
#EEDI2.dll
#Deblock.dll
#DctFilter.dll
#Sangnom.dll
#Gradfun2db.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#ab16.avs
#Deblock_QED_MT2.avs
#Gradfun2DBMod 1.5.avsi
#LimitedSharpenFaster MOD.avs
#MCTemporalDenoise.avs


Setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

  clp = last
# calculate the appropriate borders so its width and height are mod 16, these will be removed later
  x_temp      = ab16(clp.width)
  x1          = round(x_temp / 2.0)
  x0          = int(x_temp - x1)
  y_temp      = ab16(clp.height)
  y1          = round(y_temp / 2.0)
  y0          = int(y_temp - y1)
  
# add blank borders (to improve frame edge processsing and make the clip mod 16), we will remove these at the end.  
# clp = clp.addborders(x0,y0,x1,y1)
  clp.pointresize( clp.width()+x_temp, clp.height()+y_temp, -x0, -y0, clp.width()+x_temp+.001, clp.height()+y_temp+.001 )

# MCTemporalDenoise(settings="low", deblock=true, edgeclean=true, enhance=true,GFthr=1.6,AGstr=0.5,gpu=false)       
# MCTemporalDenoise(settings="very low", deblock=true,edgeclean=true, enhance=true, GFthr=1.6,AGstr=0.5,gpu=false)  
  MCTemporalDenoise(settings="medium", deblock=true, edgeclean=true, enhance=true,useQED=true,GFthr=1.8,AGstr=0.8,gpu=false)
# MCTemporalDenoise(settings="high", deblock=true, edgeclean=true, enhance=true,GFthr=2.3,AGstr=1.2,gpu=false)      
# MCTemporalDenoise(settings="very high",twopass=true,useTTmpSm=true,deblock=true,useQED=true,enhance=true,gpu=false)
  crop(x0,y0,-x1,-y1)
  
  
# Назначение: Для очень качественной обработки DVD и ориентирован на снижение блочности изображения
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта MCTemporalDenoise.v1.4.20
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная 




