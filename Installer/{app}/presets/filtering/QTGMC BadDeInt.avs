#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#fft3dfilter.dll
#nnedi3.dll
#AddGrainC.dll
#flash3kyuu_deband.dll
#vinverse.dll
#AddGrainC.dll
#SSE2Tools.dll
#mt_masktools-26.dll
#QTGMC.avs


  setmtmode(2)
# setmemorymax(640)
  
  vinverse() # удаление остатков гребёнки
  
# QTGMC(Preset="Slower", InputType=1, Sharpness=0.4, Edithreads=1, DCT=5)
  QTGMC(Preset="Slower", InputType=2, ProgSADMask=12.0, Sharpness=0.4, Edithreads=1, DCT=5)  
 
# t = QTGMC(Preset="Slower", InputType=2, ProgSADMask=12.0, Sharpness=0.4, Edithreads=1, DCT=5)
# b = QTGMC(Preset="Slower", InputType=3, PrevGlobals="Reuse",Edithreads=1) # Reuse motion vectors from first call for a good speed-up
# Repair( t, b, 1 )

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
  
# Назначение: Для прогрессивного материала с устранением артефактов некачественного деинтерлейса



