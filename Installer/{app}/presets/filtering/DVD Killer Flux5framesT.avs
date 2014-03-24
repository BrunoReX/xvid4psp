#avstp.dll
#RgTools.dll
#ReduceFlicker.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#flash3kyuu_deband.dll
#Flux5framesT.avs
#Killer_VG.avs
#Ylevels.avs
#SeeSaw.avs


# setmtmode(2)
# setmemorymax(640)

a = last
b = a.RemoveGrain(11)
f = b.Flux5framesT.merge(b,0.49)
ref = a.mt_makediff(mt_makediff(b,f,U=3,V=3),U=3,V=3)

Killer(3, calm=0, ref=ref, oversharp=false)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0) 
YlevelsS(0,1.0,255,0,255,false) 


# Назначение: Для качественной обработки сильно зашумленного любого типа видеоматериала  на базе скрипта Killer
# Тип предварительного шумоподавителя: reduceflicker с removegrain(mode = 17)
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain1,2 или 3
# Тип шарпера: LSFmod с блюром
# Наличие фильтра DeBanding по умолчанию: отсутствует
# Скорость обработки: очень медленная                    


