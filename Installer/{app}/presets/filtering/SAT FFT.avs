#avstp.dll
#fft3dgpu.dll
#fft3dfilter.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#RgTools.dll
#flash3kyuu_deband.dll


# setmemorymax(512)

# удаление цветового шума
setmtmode(5)
fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=2.5,sigma2=1.5,sigma3=8.0,sigma4=2.5,bt=1,sharpen=0.3,plane=3)
setmtmode(2)

# удаление яркостного шума
fft3dfilter(bw=32,bh=32,oh=16,ow=16,sigma=1.5,sigma2=1.1,sigma3=1.3,sigma4=0.5,bt=3,sharpen=0.6,plane=0,ncpu=1)

# LEVELS
# SmoothCurve(Ycurve="0-0;8-0;245-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0)
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: хороший фильтр для обработки качественного DVB для улучшения сжатия 
# Тип основного шумоподавителя: fft3dgpu + fft3dfilter
# Тип шарпера: внутренний


     
