#RgTools.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#hqdn3d.dll
#FluxSmooth.dll
#Convolution3d.dll
#Bifrost.dll
#flash3kyuu_deband.dll


setmtmode(2)
# setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

BiFrost(interlaced=false)

# Temporalsoften(3,3,3,8,2)
hqdn3d(1.1, 0.9, 1.2, 1.0)
Convolution3d("moviehq")
FluxSmoothST(5,5)
mergechroma(last)
sharpen(0.2)

# LEVELS & DeBanding
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

  
# Назначение: для обработки исходника DVB телеканалов Интер, ТРК Украина, ICTV
# Тип шумоподавителя: на основе функции  hqdn3d или Temporalsoften
# Скорость обработки:  быстрая 


    