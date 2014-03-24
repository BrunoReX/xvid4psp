#Undot.dll
#mt_masktools-26.dll
#degrainmedian.dll
#RgTools.dll
#flash3kyuu_deband.dll
#LimitedSharpenFaster Mod.avs

# setmtmode(2)
setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
Undot()
degrainmedian(limitY=8,limitUV=8,mode=3)
Temporalsoften(3,2,2,6,2)
LSFmod(defaults="fast",strength=90)

f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0) 

  
# Назначение: для обработки исходника DVB телеканалов НТВ, ОРТ, Россия
# Тип шумоподавителя: на основе функции hqdn3d или Temporalsoften + FluxSmooth
# Скорость обработки:  быстрая 


    