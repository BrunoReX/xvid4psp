#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#RemoveGrainTSSE2.dll
#fft3dfilter.dll
#RemoveDirt.dll
#RepairSSE3.dll
#Warpsharp.dll
#mvtools2.dll
#mt_masktools-26.dll
#vinverse.dll
#Fluxsmooth.dll
#AGC.dll
#LimitedSupport_09Jan06B.dll
#Gradfun2db.dll
#AddGrainC.dll
#RemoveDirtMC_03.avs
#Gradfun2dbmod 1.5.avsi
#LimitedSharpenFaster Mod.avs
 
 
setmtmode(2)
# setmemorymax(640)
 
# vinverse() # удаление остатков гребёнки
 
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

# удаление радужности и цветового шума
fft3dfilter(bw=32,bh=32,oh=16,ow=16,sigma=3.0,sigma2=3.0,sigma3=8.0,sigma4=3.0,bt=3,sharpen=0.3,plane=3) 
# ConvertToRGB32().CamCD(9,1).ConvertToYV12()
 
source=last
filtered = source.RemoveDirt(false,10)
# filtered = RemoveDirtMC(source,40)
 
dark   = 32
bright = 196
mask1  = mt_lut(source,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)
 
min   = 16
max   = 255
mask2 = mt_lutxy(source,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(source,filtered,mt_logic(mask1,mask2,"min"),luma=true)
preNR_super = filtered.MSuper(pel=2, sharp=2, rfilter=2)
rdr_super = rdr.unsharpmask(40,3,0).unsharpmask(30,2,0).MSuper(pel=2, sharp=2, levels=1)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, overlap=8, dct=5)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8, dct=5)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8, dct=5)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, overlap=8, dct=5)
rdr.MDegrain2(rdr_super,vb1,vf1,vb2,vf2,thSAD=400).FluxsmoothST(5,5).unsharpmask(20,1,0)
 
# HDRAGC(coef_gain=0.2, coef_sat=1.0, corrector=0.8, reducer=2.0) 
HDRAGC(coef_gain=0.2, min_gain=0.1, max_gain=1.0, coef_sat=0.9, corrector=0.8, reducer=2.0, black_clip=0.5)
 
# Повышение резкости 
LSFmod(defaults="slow", strength=100)

# Дебандинг
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)