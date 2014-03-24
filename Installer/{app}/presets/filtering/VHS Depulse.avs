#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#RemoveDirt.dll
#aWarpsharp2.dll
#mvtools2.dll
#ReduceFlicker.dll
#medianblur.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#Warpsharp.dll
#DePulse.dll
#deVCR.avs
#DeHalo_Alpha.avs
#RemoveColorBleeding.avs
#LimitedSharpenFaster Mod.avs
 
 
 #setmtmode(2)
# setmemorymax(640)
# ==== Подавление цветового шума и радужности изображения ====
 ConvertToRGB32()
 CamCD(12,1)
 ConvertToYUY2()
 DePulse(h=180, l=60, d=30, debug=false) # удаление белых и чёрных стрелок VHS
 ConvertToYV12()
 
RemoveColorBleeding() # Delate Colorbleeding
deVCR(30) # ремонт горизонтальных линий затиров

# ==== Ремонт полосы нарезки и наложение её на исходник ====
 source=last
 blksize = 8
 overlap = blksize/4
 
# Prefilter the clip
calm          = source.reduceflicker(strength=3,aggressive=true)
calm          = calm.repair(source, mode=1)
calm          = calm.removegrain(mode = 17)
calm          = calm.removegrain(mode = 17)
calm          = calm.removegrain(mode = 17)
preNR_super    = calm.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=2)
source_super  = source.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=2, levels=1)

vb2 = MAnalyse(preNR_super, isb=true, truemotion=true, delta=2, blksize=blksize, overlap=overlap, dct=5)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=true, delta=1, blksize=blksize, overlap=overlap, dct=5)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=true, delta=1, blksize=blksize, overlap=overlap, dct=5)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=true, delta=2, blksize=blksize, overlap=overlap, dct=5)
NRC = source.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=400,plane=3)
den = NRC.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=400,plane=0)
 dsup = den.MSuper(pel=2,levels=1,chroma=true)
 cf2 = MCompensate(den, dsup, vf2, thSCD1=500)
 cf1 = MCompensate(den, dsup, vf1, thSCD1=500)
 cb1 = MCompensate(den, dsup, vb1, thSCD1=500)
 cb2 = MCompensate(den, dsup, vb2, thSCD1=500)
 interleave(cf2, cf1, den, cb1, cb2)
 MedianblurT(0,0,0,2)
# Clense(reduceflicker=false)
 SelectEvery(5,2)
 
# ==== Sharpening ====
LSFmod(defaults="fast", preblur="ON", strength=120)
 
# ==== DeBanding & AddGrain ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
 
 
# Назначение:для обработки старых проблемных DVD
# Тип предварительного шумоподавителя: CamCD, DePulse, RemoveDirt
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain2+ MCompensate c MedianblurT
# Тип шарпера: LSFmod
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная
 