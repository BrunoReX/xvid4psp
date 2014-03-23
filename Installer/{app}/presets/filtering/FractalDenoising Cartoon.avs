#Fluxsmooth.dll
#frfun7.dll
#WarpSharp.dll
#mt_masktools-26.dll
#RgTools.dll
#flash3kyuu_deband.dll
#Ylevels.avs
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

frfun7(1.2,8,3)
FluxsmoothT(3)
LSFmod(defaults="slow", preblur="ON", strength=90)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=88,cb=64,cr=64,grainY=0,grainC=0)

YlevelsS(0,1.0,255,0,255,false)


# Ќазначение: хороший пресет дл€ создани€ DVDRip с исходников среднего и высокого уровн€ зашумленности.
# “ип предварительного шумоподавител€: отсутствует
# “ип основного шумоподавител€: пространстенно-временной шумоподавитель FRFun7
# “ип шарпера: LimitedSharpenFaster
# —корость обработки: средн€€ 
 