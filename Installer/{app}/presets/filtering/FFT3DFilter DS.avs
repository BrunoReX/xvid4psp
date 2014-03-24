#fft3dfilter.dll
#flash3kyuu_deband.dll

# setmtmode(2)
# setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
FFT3DFilter(wintype=1,bt=5,bw=32,bh=32,oh=16,ow=16,degrid=1,\
sigma=1.75,sigma2=1.5,sigma3=2.0,sigma4=1.0,plane=4,sharpen=0.5,interlaced=false,ncpu=1)
# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=72,cb=56,cr=56,grainY=0,grainC=0)


# Ќазначение: хороший дл€ создани€ TVRip, рекламных роликов, докуметнальных и демонстрацинных фильмов
# “ип предварительного шумоподавител€: отсутствует
# “ип основного шумоподавител€: пространстенно-временной шумоподавитель FFT3DFilter с подбором уровн€ шумоподавлени€ под разные виды шума параметрами sigma
# “ип шарпера: встроенный в FFT3DFilter
# —корость обработки: средн€€    

