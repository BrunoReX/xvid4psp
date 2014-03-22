#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#ReduceFlicker.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#WarpSharp.dll
#Killer.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# Killer(3,thSAD=450)
  Killer(3,thSAD=450,RefineMotion=false)
# Killer(2,thSAD=350)
# Killer(2,thSAD=350,RefineMotion=false)

LSFmod(defaults="slow",preblur="ON",strength=100)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=56,cb=36,cr=36,grainY=0,grainC=0)

# Назначение: Для качественной обработки сильно зашумленного любого типа видеоматериала на базе скрипта Killer
# Тип предварительного шумоподавителя: reduceflicker с removegrain(mode = 17)
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain1,2 или 3
# Тип шарпера: LSFmod с блюром
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: очень медленная                    


