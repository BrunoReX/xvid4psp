#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#WarpSharp.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#Fizzkiller.avs
#LimitedSharpenFaster Mod.avs

# setmtmode(2)
setmemorymax(640)

ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
den = last.Fizzkiller(degrain=2, blksize=16, chroma=true, thSAD=300)

# EDGECLEANING
mP = mt_edge(den,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=2),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(32)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
mt_merge(den,Eval("den." + "Removegrain(2,0)"),mD,luma=true,U=3,V=3)

LSFmod(defaults="slow", preblur="ON", strength=100)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: Для обработки зашумленного DVD с артифактами на контурах
# Тип предварительного шумоподавителя: removegrain(mode = 17)
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: f3kdb
# Скорость обработки: средняя                     

