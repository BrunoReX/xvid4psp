#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DePanEstimate.dll
#RgTools.dll
#mvtools2mod.dll
#fft3dgpu.dll
#fft3dfilter.dll
#splineresize.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#FineSharp.avs
#HighPassSharp.avs


setmtmode(2) 
# setmemorymax(1333)

# ==== удаление цветового шума камкодера ====
ConvertToRGB32().CamCD(7,1).converttoyv12()  

# Частичная стабилизация изображения
source = last
W = 1280 # W = source.width()
H = 720  # H = source.height()
vectors = source.MSuper(pel=1).MAnalyse(blksize=16, isb=false)
globalmotion = MDepan(source, vectors, pixaspect=1.0, thSCD1=400) 
stab = DepanStabilize(source, data=globalmotion, cutoff=2.0, mirror=15, method=1, pixaspect=1.0)

dxmax=80  dymax=60
stab_reference = stab.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference, dxmax=dxmax, dymax=dymax, trust=4.0, pixaspect=1.0) # trust подобрать от 1 до 100
DepanStabilize(stab, data=mdata, cutoff=1.0, mirror=15, dxmax=dxmax, dymax=dymax, pixaspect=1.0)
spline144resize(W, H, dxmax, dymax, -dxmax, -dymax) 
 
####################################################################################

base = last
str = 0.8
blendv = mt_lut(base, Y=Round(str*255), U=-128,V=-128)
psuper  = base.blur(0.6).MSuper(pel=1, sharp=2, rfilter=2, chroma=false)
ssuper  = base.MSuper(pel=1, sharp=2, rfilter=2, chroma=false, levels=1)
b2v = MAnalyse(psuper,isb=true, delta=2, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
b1v = MAnalyse(psuper,isb=true, delta=1, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
f1v = MAnalyse(psuper,isb=false,delta=1, blksize=16, overlap=4, truemotion=true, search=5, sadx264=3, chroma=false)
cf1 = MCompensate(base, ssuper, f1v, thSAD=125, thSCD1=256)
cb1 = MCompensate(base, ssuper, b1v, thSAD=125, thSCD1=256)
cb2 = MCompensate(base, ssuper, b1v, thSAD=125, thSCD1=256)
interleave(cb2, cb1, base.MDegrain1(ssuper, b1v,f1v,thSAD=96,plane=0), cf1)
setmtmode(5)
fft3dgpu(bw=24,bh=24,ow=12,oh=12,bt=3,sigma=2.3,sigma2=1.6,sigma3=2.0,sigma4=0.5,plane=0,mode=1,precision=2) 
setmtmode(2)
# fft3dfilter(wintype=1,degrid=1,bw=32,bh=32,ow=16,oh=16,bt=4,sigma=2.3,sigma2=1.6,sigma3=2.5,sigma4=0.5,plane=0,ncpu=1)
selectevery(4,2)
mt_merge(last, base, blendv, luma=true, U=3, V=3)

# Soft Sharpening
# FineSharp() 
HighPassSharp(r=0.15) 

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=56,cb=40,cr=40,grainY=0,grainC=0)

coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255)


# Назначение: для качественной обработки материала HDV с частичной стабилизацией изображения
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе ускоренной функции MCompensate c пост-обработкой fft3dgpu
# Тип шарпера: FineSharp или HighPassSharp
# Скорость обработки: средняя
# Рекомендуемый деинтерлейс YadiModEDI( x2 )
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
