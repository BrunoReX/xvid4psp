#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#mvtools2mod.dll
#RepairSSE2.dll
#dfttest.dll
#MaskTools.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#Ylevels.avs
#Gradfun2dbmod.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
setmemorymax(768)
 
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
 
source = last
sigma=48*1.5
sigmamc=32
preNR1 = source.dfttest_dfttest(Y=true,U=false,V=false,tbsize=1,ftype=1,sbsize=8,sosize=6,sigma=sigma,threads=1)
preNR = preNR1.dfttest_dfttest(Y=false,U=true,V=true,tbsize=1,ftype=1,sbsize=16,sosize=12,sigma=1.5*sigma,threads=1)
#preNR = source.degrainmedian(mode=3,limity=12,limituv=8).dfttest(sigma=5,f0beta=1.0,tbsize=3,threads=1)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=2)
source_super = source.MSuper(pel=2, sharp=2, levels=1)
vb3 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=3, blksize=16, search=4, overlap=8, badSAD=2000)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, search=4, overlap=8, badSAD=2000)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, search=4, overlap=8, badSAD=2000)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, search=4, overlap=8, badSAD=2000)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, search=4, overlap=8, badSAD=2000)
vf3 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=3, blksize=16, search=4, overlap=8, badSAD=2000)

mcomp7 = interleave(\
  mcompensate(source,source_super,vf3,thSCD1=500)\
, mcompensate(source,source_super,vf2,thSCD1=500)\
, mcompensate(source,source_super,vf1,thSCD1=500)\
, source\
, mcompensate(source,source_super,vb1,thSCD1=500)\
, mcompensate(source,source_super,vb2,thSCD1=500)\
, mcompensate(source,source_super,vb3,thSCD1=500))
chroma=mcomp7.dfttest_dfttest(Y=false,U=true,V=true,tbsize=7,ftype=1,sbsize=16,sosize=12,sigma=1.5*sigmamc,threads=1).selectevery(7,3)
mcomp7.dfttest_dfttest(Y=true,U=false,V=false,tbsize=7,ftype=1,sbsize=8,sosize=6,sigma=sigmamc,threads=1).selectevery(7,3)
MergeChroma(chroma)
LSFmod(defaults="slow", strength=100)
Gradfun2dbmod(thr=1.6,thrC=2.0,str=1.0,temp=50)
#StackVertical(source,last)
YlevelsS(0,1.0,255,0,255,false)


# Назначение: Для обработки шумного блочного DVD
# Тип предварительного шумоподавителя: degrainmedian + fft3dfilter или dfttest
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения на шумоподавителе MDegrain3
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: отключен
# Скорость обработки: медленный 