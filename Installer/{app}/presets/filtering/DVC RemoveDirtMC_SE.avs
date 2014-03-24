#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Warpsharp.dll
#RgTools.dll
#RemoveDirt.dll
#mvtools2.dll
#hqdn3d.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#AddGrainC.dll
#GradFun2DB.dll
#LimitedSharpenFaster Mod.avs
#RemoveDirtMC_SE.avs
#GradFun2DBmod 1.5.avsi
#Ylevels.avs


# setmtmode(2)
# setmemorymax(640)

ConvertToRGB32().CamCD(9,1).converttoyv12()
source = last.trim(1,0)
 
pred = source.Temporalsoften(3,6,12,15,2).mt_lutxy(source,Y=4,U=2,V=2)
preNR = pred.TemporalDeGrain()
preNR_super = preNR.MSuper(pel=2,sharp=2,hpad=4,vpad=4)
source_super = source.MSuper(hpad=4,vpad=4,pel=2,levels=1)
bv3 = MAnalyse(PreNR_super, search=4, isb=true,  delta=3, blksize=16, overlap=8, truemotion=false)
bv2 = MAnalyse(PreNR_super, search=4, isb=true,  delta=2, blksize=16, overlap=8, truemotion=false)
bv1 = MAnalyse(PreNR_super, search=4, isb=true,  delta=1, blksize=16, overlap=8, truemotion=false) 
fv1 = MAnalyse(PreNR_super, search=4, isb=false, delta=1, blksize=16, overlap=8, truemotion=false) 
fv2 = MAnalyse(PreNR_super, search=4, isb=false, delta=2, blksize=16, overlap=8, truemotion=false)
fv3 = MAnalyse(PreNR_super, search=4, isb=false, delta=3, blksize=16, overlap=8, truemotion=false)
		
bcomp = MCompensate(source, source_super,bv1) 
fcomp = MCompensate(source, source_super,fv1)
NR1 = RemoveDirtSE(source, fcomp, bcomp, repmode=16, clmode=5)
NR1_super = NR1.MSuper(hpad=4,vpad=4,pel=2,sharp=2,levels=1)
NR1.MDeGrain3(NR1_super, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=400).FluxSmoothST(5,5).unsharpmask(40,1,0)
 
sharpen(0.4).sharpen(0.4).blur(0.2)
GradFun2DBmod(thr=1.6,thrC=1.8,str=1.0,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255)

 
# Назначение:для обработки старых проблемных DVD 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain3+ MCompensate c RemoveDirtMC
# Тип шарпера: sharpen 
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
