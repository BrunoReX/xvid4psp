#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#fft3dgpu.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#FineSharp.avs
#HighPassSharp.avs


setmtmode(2)
# setmemorymax(1280)

RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

source = last
str = 0.8
blendv = mt_lut(source, Y=Round(str*255), U=-128,V=-128)
psuper = source.removegrain(11).MSuper(pel=1, sharp=1, rfilter=2, chroma=false)
ssuper = source.MSuper(pel=1, sharp=2, rfilter=2, chroma=false, levels=1)
b2v = MAnalyse(psuper,isb=true, delta= 2, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
b1v = MAnalyse(psuper,isb=true, delta= 1, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
f1v = MAnalyse(psuper,isb=false,delta= 1, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
cf1 = MCompensate(source, ssuper, f1v, thSAD=96, thSCD1=300)
cb1 = MCompensate(source, ssuper, b1v, thSAD=96, thSCD1=300)
cb2 = MCompensate(source, ssuper, b2v, thSAD=96, thSCD1=300)
interleave(cb2, cb1, source, cf1)
setmtmode(5)
fft3dgpu(bw=32,bh=32,ow=16,oh=16,bt=4,sigma=1.2,sigma2=1.5,sigma3=2.2,sigma4=0.8,plane=4,mode=1,precision=2) 
setmtmode(2)
selectevery(4,2)
mt_merge(last, source, blendv, luma=true)

# SOFT SHARPENING
# FineSharp() 
  HighPassSharp(r=0.15)
 
# DEBANDING
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: Качественный пресет для обработки BD
# Тип шумоподавителя: на основе векторного анализа оценки движения на функции MCompensate с конечным фильтром fft3dgpu
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: средняя                    
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 




