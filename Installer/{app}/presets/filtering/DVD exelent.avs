#degrainmedian.dll
#WarpSharp.dll
#mt_masktools-26.dll
#RgTools.dll
#flash3kyuu_deband.dll
#Ylevels.avs
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(256)

degrainmedian(limitY=5,limitUV=6,mode=2)
Temporalsoften(2,2,2,6,2)
LSFmod(defaults="fast",preblur="ON", strength=80)

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)
YlevelsS(0,1.0,255,0,255,false)


# Назначение: для посредственной обработки DVD для подавления горячих пикселей и сглаживания зернистости
# Тип предварительного шумоподавителя: отсутствует
# Тип основного шумоподавителя: degrainmedian
# Тип шарпера: LSFmod с блюром
# Наличие фильтра DeBanding по умолчанию: включен
 

