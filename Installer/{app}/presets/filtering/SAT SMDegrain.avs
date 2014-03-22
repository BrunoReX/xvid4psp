#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#Dither.dll
#dfttestmod.dll
#mt_masktools-26.dll
#nnedi3.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#minblur.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#SmoothContrast.avsi
#SMDegrain.avsi
#LimitedSharpenFaster.avs


  setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(3,1).ConvertToYV12()  

# SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

SMDegrain(tr=3,thSAD=400,chroma=true,RefineMotion=false,contrasharp=true,prefilter=1,blksize=16,search=4,limit=235,limitc=115,lsb=true)
# DeBanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: оптимальный пресет для создания SATRip-сериалов с шумных исходников 
# Тип предварительного шумоподавителя:  CamCD
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе SMDegrain
# Тип шарпера: Contrasharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная      

