#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemovegrainSSE2.dll
#RepairSSE2.dll
#SmoothAdjust-ICL-x86.dll
#mvtools2mod.dll
#warpsharp.dll
#Bifrost.dll
#fft3dgpu.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#medianblur.dll
#minblur.avs
#SmoothContrast.avsi
#ContraHD.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление радужности и цветового шума
# fft3dfilter(bw=32,bh=32,oh=16,ow=16,sigma=2.0,sigma2=1.5,sigma3=4,sigma4=2.0,bt=1,plane=3,sharpen=0.3)
# ConvertToRGB32().CamCD(3,1).ConvertToYV12()
  Bifrost(interlaced=false)

source = last
blksize = 16 # для скорости обработки задайте 16
overlap = blksize/2
chroma = true
lambda = 512
planes = chroma?4:0
search = 5

maskstar = source.mt_binarize(upper=false)
super = source.MSuper(pel=1, sharp=2, chroma=chroma)
vb1 = MAnalyse(super, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf1 = MAnalyse(super,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)

cf1 = MCompensate(source, super, vf1, thSCD1=300)
cb1 = MCompensate(source, super, vb1, thSCD1=300)

# Use the vectors to create motion and static masks, we use these for prefilter and sharpening masks
maskstar = source.mt_binarize(upper=false)
maskmotion1 = source.mmask(kind=0, vb1, gamma=1, ml=130)
maskmotion1 = mt_adddiff(maskmotion1, mt_makediff(maskmotion1,source))
maskmotion2 = source.mt_motion(thy1=5,thy2=10,thc1=5,thc2=10,u=3,v=3).mt_lut(expr="x 255 == x 156 - 0 ?")
maskmotion  =  mt_lutxy(maskmotion1,maskmotion2,expr="x 0 == 0 x y < y x ? ?") 
maskstatic  = mt_invert(maskmotion)

interleave(cf1, source.MDegrain1(super,vb1,vf1,thSAD=90,plane=planes), cb1)
setmtmode(5)
fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=3,sigma=2.0,sigma2=1.4,sigma3=1.5,sigma4=0.7,mode=2,precision=2,plane=planes)
setmtmode(2)
selectevery(3,1)
output = mt_merge(last, source, maskstar)
# don't sharpen motion, dark area or starfield area
maskstatic = mt_lutxy(output,maskstatic,"x 32 < 0 y ?")

# SHARPENING
Sclp = output.LSFmod(defaults="fast", strength=80)
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(output, shrp, maskstatic)

# LEVELS
# SmoothContrast(contrast=0.03) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
   SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU
  
# DeBanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: для обработки качественных исходников DVB типа телеканалов НТВ, Россия1 и ОРТ с низким уровнем шума
# Тип шумоподавителя: на основе векторного анализа оценки движения с радиусом 1 на функции MСompensate + fft3dgpu 
# Тип шарпера: ContraHD
# Наличие фильтра DeBanding по умолчанию: f3kdb
# Скорость обработки: медленная                     


