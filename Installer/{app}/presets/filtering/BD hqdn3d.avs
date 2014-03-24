#RgTools.dll
#mt_masktools-26.dll
#UnDot.dll
#flash3kyuu_deband.dll
#hqdn3d.dll
#HighPassSharp.avs


# setmtmode(2)
# setmemorymax(256)

UnDot()
# Temporalsoften(3,2,2,6,2)
hqdn3d(0.8,0.9,1.5,1.5)
Temporalsoften(3,2,2,6,2)
HighPassSharp(r=0.15) 

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: для обработки любого источника для подавления горячих пикселей и сглаживания зернистости
# Тип основного шумоподавителя: UnDot + Temporalsoften или hqdn3d
# Тип шарпера: HighPassSharp 
# Скорость обработки: быстрая 



