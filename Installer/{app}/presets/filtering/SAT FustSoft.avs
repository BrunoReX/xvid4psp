#mt_masktools-26.dll
#RemoveGrainSSE2.dll
#fft3dgpu.dll
#Bifrost.dll
#SmoothAdjust-ICL-x86.dll
#AddGrainC.dll
#flash3kyuu_deband.dll


# setmemorymax(256)
setmtmode(5)
fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=2.5,sigma2=1.75,sigma3=6.8,sigma4=2.5,bt=1,sharpen=0.3,plane=3)
setmtmode(2)
# Bifrost(interlaced=false)

Temporalsoften(3,2,0,6,2)
sharpen(0.1)

# LEVELS
# SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

# DEBANDING
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

# Назначение: для посредственной обработки DVD для подавления горячих пикселей и сглаживания зернистости
# Наличие фильтра DeBanding по умолчанию: включен
 

