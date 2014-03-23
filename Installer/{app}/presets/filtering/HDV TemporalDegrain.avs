#RgTools.dll
#mvtools2.dll
#fft3dgpu.dll
#DePan.dll
#DePanEstimate.dll
#flash3kyuu_deband.dll
#Fluxsmooth.dll
#splineresize.dll
#mt_masktools-26.dll
#FineSharp.avs
#HighPassSharp.avs


# setmemorymax(1024)
setmtmode(5)
FFT3DGPU(wintype=1,bt=1,bw=32,bh=32,oh=16,ow=16,degrid=1,sigma=3.0,sigma2=3.0,sigma3=10.0,sigma4=3.0,plane=3,sharpen=0.3,mode=1,precision=2)
setmtmode(2)

# Частичная стабилизация изображения
source = last
W = 1280 # W = source.width()
H = 720  # H = source.height()
vectors = source.MSuper(pel=1).MAnalyse(blksize=16, isb=false)
globalmotion = MDepan(source, vectors, pixaspect=1.0, thSCD1=400) 
stab1 = DepanStabilize(source, data=globalmotion, cutoff=2.0, mirror=15, method=1, pixaspect=1.0)

dxmax=80  dymax=60
stab_reference = stab1.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference, dxmax=dxmax, dymax=dymax, trust=4.0, pixaspect=1.0) # trust подобрать от 1 до 100
DepanStabilize(stab1, data=mdata, cutoff=1.0, mirror=15, dxmax=dxmax, dymax=dymax, pixaspect=1.0)
spline144resize(W, H, dxmax, dymax, -dxmax, -dymax)   

base = last
psuper = base.blur(0.6).MSuper(pel=1, sharp=2, rfilter=2, chroma=false)
ssuper = base.MSuper(pel=1, sharp=2, rfilter=2, chroma=false, levels=1)
b1v = MAnalyse(psuper,isb=true, delta= 1, blksize=16, overlap=8, truemotion=false, search=5, sadx264=3, chroma=false)
f1v = MAnalyse(psuper,isb=false,delta= 1, blksize=16, overlap=8, truemotion=false, search=5, sadx264=3, chroma=false)
base.MDegrain1(ssuper, f1v, b1v, thSAD=240, plane=0)
NR_super = MSuper(pel=1, levels=1, chroma=false)
MDegrain1(NR_super,b1v,f1v,thSAD=135,plane=0)

# Soft Sharpeninig
# FineSharp()
  HighPassSharp(r=0.15)  

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)


# Назначение: для обработки зушумленного BD для улучшения сжимаемости
# Тип предварительного шумоподавителя: FFT3DGPU
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на двухэтапном шумоподавителе MDegrain1
# Тип шарпера: FineSharp или HighPassSharp
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: ниже среднего 
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
                   
