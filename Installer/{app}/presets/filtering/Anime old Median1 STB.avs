#avstp.dll
#DePan.dll
#DePanEstimate.dll
#RemoveGrainSSE209.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2.dll
#fft3dfilter.dll
#medianblur.dll
#mt_masktools-26.dll
#awarpsharp2.dll
#EEDI2.dll
#NNEDI3.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#minblur.avs
#Median1.avs
#Contra.avs


setmtmode(2)
setmemorymax(640)

# global motion stabilization stage
temp = last.TemporalSoften(7,255,255,25,2)
Interleave(temp.Repair(last.TemporalSoften(1,255,255,25,2)),last)
DePan(last,data=DePanEstimate(last,trust=0,dxmax=2,dymax=2),offset=-1)
SelectEvery(2,0)

MergeChroma(aWarpSharp2(chroma=4)) 

# local degrain stage
source = last
sigma = 5
filt = source.fft3dfilter(sigma=sigma,sigma2=sigma*0.75,sigma3=sigma*0.5,sigma4=sigma*0.25,bt=5,sharpen=0.3,ncpu=1)
Median1(source.RemoveGrain(12),temp,filt)
super = MSuper(pel=2, sharp=1, rfilter=2)
b2v = MAnalyse(super,isb=true, delta=2, blksize=8, overlap=4, truemotion=true)
b1v = MAnalyse(super,isb=true, delta=1, blksize=8, overlap=4, truemotion=true)
f1v = MAnalyse(super,isb=false,delta=1, blksize=8, overlap=4, truemotion=true)
f2v = MAnalyse(super,isb=false,delta=2, blksize=8, overlap=4, truemotion=true)
NR = source.MDegrain2(super,b1v,f1v,b2v,f2v,thSAD=400)

med = Median1(source,NR,filt,chroma="copy first")
med_super = med.MSuper(pel=2, chroma=true, levels=1) 
den = med.MDegrain2(med_super,b1v,f1v,b2v,f2v,thSAD=240,thSCD1=150,thSCD2=75).Temporalsoften(2,2,2,6,2)

# sharpening
Contra(den,source)

# restore stars stage
prest = last
prest.MT_Binarize(threshold=20,upper=true).MT_Expand()
MT_Merge(prest,source,last,chroma="copy first")

# anti-aliasing
last.EEDI2().Repair(last.NNEDI3(dh=true,field=1),9)

# DeBanding 
DB = f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
# DB = LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)


# Назначение: качественный пресет для обработки зашумленного исходника anime с крупно-зернистым шумом и требующий небольшой стабилизации изображения
# Тип шумоподавителя: на основе векторного анализа оценки движения c двухкаскадным MDegrain2 и функцией Median1
# Тип шарпера: Contra
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                     

