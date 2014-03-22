#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#nnedi3.dll
#fft3dfilter.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#Gradfun2db.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#SSE2Tools.dll
#VerticalCleanerSSE2.dll
#Gradfun2dbmod 1.5.avsi
#QTGMC.avs


SetMTmode(2)
# setmemorymax(640)
  
AssumeTFF() 
# AssumeBFF()
QTGMC( Preset="Slow", Sharpness=0.7, FPSDivisor=2, Edithreads=1)

mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )

# Debanding
# f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
  Gradfun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)


# Назначение: Для качественного деинтерлейса видеоматериалов с повышенным уровнем радужности
# Предупреждение: деинтерлейс, выставляемый XviD 4XvidPSP 5.0 убрать!!!



