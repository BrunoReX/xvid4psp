#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#fft3dgpu.dll
#Bifrost.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#medianblur.dll
#AddGrainC.dll
#GradFun2DB.dll
#Gradfun2DBMod 1.5.avsi


# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# ==== DeRainbow & Color denoiced ====
# setmtmode(5)
# fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=1.75,sigma2=1.3,sigma3=4.0,sigma4=1.5,bt=1,sharpen=0.6,plane=3,mode=1,precision=2)
  setmtmode(2)
# ConvertToRGB32().CamCD(2,1).ConvertToYV12()
  Bifrost(interlaced=false)

# LEVELS
# SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code
    
source = last
chroma = false
planes = chroma?4:0
chr31 = chroma?3:1
chr21 = chroma?2:1
oo = source.levels(16+6,1.0,235-3,16,235,false)
x  = oo.bicubicresize(72*4,56*4).medianblur(1,0,0).bicubicresize(width(),height(),1,0)
d  = mt_lutxy(source,x,"128 x y - abs 2 / 1 1.4 / ^ 2 * x y - x y - abs 0.001 + / * +",U=chr21,V=chr21)
s  = oo.mt_makediff(d.gradfun2db(5.5),U=chr21,V=chr21).sharpen(0.9)
mm = blankclip(source,width=16,height=16,color=$FFFFFF).addborders(8,8,8,8).levels(16+2,1.0,235-2,0,255,false)
 \   .blur(1).medianblur(3,0,0).blur(1).bicubicresize(64,64,1,0).blur(1).blur(1).bicubicresize(width(),height(),1,0)
sharp = s.mt_merge(oo,mm,U=chr21,V=chr21).mt_merge(source,mm,U=chr21,V=chr21)

# ==== Denoiced =====
blksize = 8
overlap = blksize/2
chroma = false
planes = chroma?4:0  
tr = 1   # Temporal radius
thSAD = 160
thSAD2 = 96

psuper = source.blur(0.5).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
shsuper = sharp.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=true, chroma=chroma, lambda=768)
source.MDegrainN (shsuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes)
Temporalsoften(2,1,1,6,2)
GradFun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)

# Назначение: хороший пресет для "мягкого" DVB с повышением резкости, делает чуть темнее изображение
# Тип предварительного шумоподавителя: нет
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения на шумоподавителе MDegrain2
# Тип шарпера: скрипт "blur-levels"  
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: средняя

