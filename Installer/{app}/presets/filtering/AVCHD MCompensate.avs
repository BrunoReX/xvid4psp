#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mt_masktools-26.dll
#DePan.dll
#DePanEstimate.dll
#fft3dgpu.dll
#fft3dfilter.dll
#Cnr2.dll
#mvtools2mod.dll
#medianblur.dll
#AddGrainC.dll
#GradFun2DB.dll
#minblur.avs
#ContraHD.avs
#HighPassSharp.avs
#GradFun2DBmod 1.5.avsi


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

setmtmode(2)
# setmemorymax(1280)

# ==== удаление цветового шума камкодера ====
  fft3dfilter(wintype=1,bt=3,bw=32,bh=32,oh=16,ow=16,degrid=1,sigma=3.0,sigma2=2.0,sigma3=8.0,sigma4=3.0,plane=3,sharpen=0.3,ncpu=1)
# ConvertToRGB32().CamCD(7,1).converttoyv12()  # удаление цветового шума 2-й вариант
# Cnr2("oxx",8,14,191,75,255,20,255,false)     # цветового шума 3-й вариант

# Частичная стабилизация изображения
source = last
W = 1280 # W = source.width()
H = 720  # H = source.height()
vectors = source.MSuper(pel=1).MAnalyse(blksize=16, isb=false)
globalmotion = MDepan(source, vectors, pixaspect=1.0, thSCD1=400) 
stab = DepanStabilize(source, data=globalmotion, cutoff=2.0, mirror=15, method=1, pixaspect=1.0)

dxmax=106  dymax=60
stab_reference = stab.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference, dxmax=dxmax, dymax=dymax, trust=4.0, pixaspect=1.0) # trust подобрать от 1 до 100
DepanStabilize(stab, data=mdata, cutoff=1.0, mirror=15, dxmax=dxmax, dymax=dymax, pixaspect=1.0)
crop(dxmax, dymax, -dxmax, -dymax)
Blackmanresize(W, H, taps=4) 

# ==== Denoiced ====
base = last
str = 0.8
blendv = mt_lut(base, Y=Round(str*255), U=-128,V=-128)
psuper = base.blur(0.6).MSuper(pel=1, sharp=2, rfilter=2, chroma=false)
ssuper = base.MSuper(pel=1, sharp=2, rfilter=2, chroma=false, levels=1)
b2v = MAnalyse(psuper,isb=true, delta= 2, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3, chroma=false)
b1v = MAnalyse(psuper,isb=true, delta= 1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3, chroma=false)
f1v = MAnalyse(psuper,isb=false,delta= 1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3, chroma=false)
cf1 = MCompensate(base, ssuper, f1v, thSAD=135, thSCD1=300)
cb1 = MCompensate(base, ssuper, b1v, thSAD=135, thSCD1=300)
cb2 = MCompensate(base, ssuper, b2v, thSAD=135, thSCD1=300)
interleave(cb2, cb1, base, cf1)
setmtmode(5)
fft3dgpu(bw=32,bh=32,ow=16,oh=16,bt=4,sigma=2.3,sigma2=1.75,sigma3=2.75,sigma4=1.8,plane=0,mode=1,precision=2) 
setmtmode(2)
selectevery(4,2)
mt_merge(last, base, blendv, luma=true)

# ==== Sharpening ====
# ContraHD(last,base,cf1,cb1,0) # for 1280x720
  HighPassSharp(r=0.15) # for 1920x1080

# ==== DeBanding ====
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)

Blackmanresize(W, H, taps=4) 

# Назначение: для устранения шума AVCHD
# Тип предварительного шумоподавителя: ccd_sse2, fft3dfilter или Cnr2
# Тип основного шумоподавителя: MCompensate + fft3dgpu
# Тип шарпера: ContraHD, HighPassSharp 
# Скорость обработки: средняя
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
