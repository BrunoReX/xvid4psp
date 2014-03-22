#deen_1.0.dll
#UnFilter.dll
#mvtools2.dll
#deblock.dll
#RemovegrainSSE2.dll
#fft3dfilter.dll
#RepairSSE2.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Ylevels.avs
#HybridFuPP.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

HybridFupp(preset = "high", M_TRadius=3, ME_Resizer=8, M_SCD=400, Deblock=true, dering = true, skin=true)
#HybridFupp(preset = "HybridQ", D_mode=2, dering = true, E_Auto_Str=false)
#HybridFupp(preset = "very high", E_Thr = 133, dering = true)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0) 
YlevelsS(10,1.0,250,0,255,false)


# Назначение: Для обработки DVD с применением "маски кожи" на базе скрипта HybridFuPP
# Тип предварительного шумоподавителя: deen
# Тип основного шумоподавителя: на базе скрипта HybridFuPP
# Тип шарпера: на базе скрипта HybridFuPP
# Наличие фильтра DeBanding по умолчанию: нет
# Скорость обработки: средняя                     





