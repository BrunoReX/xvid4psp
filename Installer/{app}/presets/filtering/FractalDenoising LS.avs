#frfun7.dll
#WarpSharp.dll
#mt_masktools-26.dll
#RemoveGrainSSE3.dll
#RepairSSE3.dll
#flash3kyuu_deband.dll
#Ylevels.avs
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(256)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

FRFun7(1.0, 6.0, 2.0)
LSFmod(defaults="fast", preblur="ON", strength=100) 

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=88,cb=64,cr=64,grainY=0,grainC=0)
YlevelsS(0,1.0,255,0,255,false)


# Ќазначение: хороший пресет дл€ создани€ DVDRip с исходников среднего и высокого уровн€ зашумленности.
# “ип предварительного шумоподавител€: отсутствует
# “ип основного шумоподавител€: пространстенно-временной шумоподавитель FRFun7
# “ип шарпера: LimitedSharpenFaster
# —корость обработки: средн€€ 
 