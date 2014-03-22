#avstp.dll
#EEDI2.dll
#nnedi3.dll
#mt_masktools-26.dll
#SangNom.dll
#TEdgeMask.dll
#tcanny.dll
#MSharpen.dll
#mvtools2.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#warpsharp.dll
#variableblur.dll
#dfttestmod.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#Toon-v1.1.dll
#awarpsharp2.dll
#dither.dll
#TEdgeMask.dll
#EdgeCleaner.avs
#dither.avsi
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Soothe.avs
#LimitedSharpenFaster mod.avs
#TAA.avsi
#MCAA.avsi
#mt_xxpand_multi.avsi
#Down10.avs


setmtmode(2)
# setmemorymax(1280)

W = width(last)
H = height(last)

MCAA(aafilter="taa(aatype=-3, preaa=-1, mtype=0, sharp=140, postaa=false)", sharptype="slow", predown=true, predownMC=true,\
     Tradius=2, aarepair=24, stabilize=true)
EdgeCleaner(smode=1,strength=17)

# DeBanding
# LumaDBL(lsb=true) 
GradFun3(smode=1, thr=0.5, radius=12, lsb=true)

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит 


# Для качественного антиайлиазинга аниме cо столь же качественным дебандингом c векторным анализим оценки движения с конвертацией в 16 бит
# Тип антиайлизинга по умолчанию: TAA
# Тип шумоподавителя: на основе векторного анализа оценки движения на функции MDegrain
# Тип шарпера: LSFmod  
# Наличие фильтра DeBanding по умолчанию: LumaDBL
# Скорость обработки: медленная
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile

