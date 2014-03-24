#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#SmoothAdjust.dll
#RemoveDirt.dll
#WarpSharp.dll
#degrainmedian.dll
#VagueDenoiser.dll
#awarpsharp2.dll
#mvtools2.dll
#mt_masktools-26.dll
#DeScratch.dll
#Fluxsmooth.dll
#AddGrainC.dll
#Gradfun2DB.dll
#stab.avs
#deVCR.avs
#Limitedsharpenfaster mod.avs
#RemoveColorBleeding.avs
#RemoveDirtMC_03.avs
#Gradfun2dbmod 1.5.avsi


# setmtmode(2)
# setmemorymax(640)

# подавление цветового шума и радужности изображения
ConvertToRGB32().CamCD(20,1).ConvertToYV12()

# DeScratch(mindif=4, maxgap=20, minlen=300, blurlen=50, keep=100, border=0, maxangle=0) # удаление царапин и полос старых киноплёнок

# Убираем горизонтальные линии нарезки VHS
  deVCR(30).deVCR(0)
  
# Удалить Colorbleeding (размытость цветовых контуров)
 RemoveColorBleeding() 

# Удалить VHS colorshift (цветовой сдвиг)
Vshift=2  # 2 пикселя на ленте 
Hshift=0 
mergechroma(last.crop(Hshift,Vshift,0,0, align=true).addborders(0,0,Hshift,Vshift)) 

# Частичная стабилизация изображения
# Stab()

 
# Шумоподавление
  source = last
  filtered = source.RemoveDirt(false,23)
# filtered = RemoveDirtMC(source,40)

dark   = 32
bright = 196
mask1  = mt_lut(source,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(source,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(source,filtered,mt_logic(mask1,mask2,"min"),luma=true)
preNR_super = filtered.MSuper(pel=2, sharp=2, rfilter=4)
rdr_super = rdr.MSuper(pel=2, sharp=2, levels=1, chroma=false)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, overlap=8, dct=5)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8, dct=5)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8, dct=5)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, overlap=8, dct=5)
rdr.MDegrain2(rdr_super,vb1,vf1,vb2,vf2,thSAD=400,plane=3)
MDegrain2(rdr_super,vb1,vf1,vb2,vf2,thSAD=400,plane=0)
FluxSmoothST(5,5)

# Повышение резкости 
LSFmod(defaults="slow", strength=100)

# Подстройка уровней
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# Дебандинг
GradFun2DBmod(thr=1.4,thrC=1.8,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)


# Назначение: для качественной обработки DVC VHS с частичной стабилизацией изображения 
# Наличие фильтра подавления радужности изображения и цветового шума: включен
# Тип предварительного шумоподавителя: RemoveDirtMC
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с шумоподавлением: MDegrain2
# Тип шарпера: unsharpmask + SeeSaw + Limitedsharpenfaster
# Скорость обработки: медленная


