#fft3dfilter.dll
#fft3dgpu.dll
#WarpSharp.dll
#mt_masktools-26.dll
#RemoveGrainSSE2.dll
#RepairSSE3.dll
#flash3kyuu_deband.dll
#LimitedSharpenFaster Mod.avs


# setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление цветового шума
setmtmode(5)
fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=2.0,sigma2=1.75,sigma3=3.0,sigma4=2.0,bt=1,plane=3,sharpen=0.3,mode=1,precision=2)
setmtmode(2)

# удаление яркостного шума
fft3dfilter(wintype=1,degrid=1,bw=32,bh=32,oh=16,ow=16,sigma=2.0,sigma2=1.5,sigma3=1.75,sigma4=1.0,bt=5,plane=0,ncpu=1)

LSFmod(defaults="slow", preblur="ON", strength=100)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=72,cb=56,cr=56,grainY=0,grainC=0)


# Назначение: хороший пресет для создания DVDRip и SATRip сериалов, рекламных роликов, докуметнальных и демонстрацинных фильмов
# Тип основного шумоподавителя: пространстенно-временной шумоподавитель FFT3DFilter с подбором уровня шумоподавления под разные виды шума параметрами sigma
# Тип шарпера: LSFmod
      
