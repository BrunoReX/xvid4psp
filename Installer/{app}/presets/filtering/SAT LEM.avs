#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2.dll
#Warpsharp.dll
#awarpsharp2.dll
#MSharpen.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#hqdn3d.dll
#flash3kyuu_deband.dll
#LEM.avs
#SmoothContrast.avsi
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32().CamCD(2,1).ConvertToYV12()
LEM(ff="hqdn3d(1.5,1.5,2.0,2.0)",flem="LSFmod(strength=80,Smode=3,Smethod=3)",mode="LEM")
Temporalsoften(2,1,1,6,2)

# LEVELS
# SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code
  
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: для обработки ATRemux
# Тип основного шумоподавителя: hqdn3d или fft3dfilter
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: быстрая




