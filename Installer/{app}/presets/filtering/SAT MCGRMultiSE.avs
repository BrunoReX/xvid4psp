#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#Bifrost.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#GradFun2DB.dll
#MCGRMultiSE.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление радужности и цветового шума
# ConvertToRGB32().CamCD(2,1).ConvertToYV12()
  Bifrost(interlaced=false)

MCGRMultiSE(ssx=1.5,ssy=1.5,Sstr=1.2,Tlimit=2,Slimit=6,radius=2,search=5,thSAD=150,thSADC=150,DeBanding=true,thr=1.4,thrC=1.6)
Ylevels(0,1.0,255,0,255)


# Назначение: очень качественный пресет для обработки мягкого DVD или BD с повышением резкости изображения
# Тип шумоподавителя: на основе векторного анализа оценки движения на основе функции MDegrain1...3 
# Тип шарпера: MCGR
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                     


