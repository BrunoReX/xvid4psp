#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#WarpSharp.dll
#RemoveGrainSSE2.dll
#degrainmedian.dll
#fft3dgpu.dll
#deflicker.dll
#mvtools2mod.dll
#RepairSSE2.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#AddGrainC.dll
#GradFun2DB.dll
#GradFun2DBmod 1.5.avsi


setmtmode(2)
# setmemorymax(640)

W = 720
H = 576

ConvertToRGB32()
CamCD(9,1)       # подавление цветового шума камкодеров
converttoyv12()

source= last.trim(1,0)

#STABILIZING
stab_reference= source.crop(48,36,-48,-36).tweak(cont=1.05).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata=DePanEstimate(stab_reference,trust=5.0,dxmax=24,dymax=18)
stab1 = DePanStabilize(source,data=mdata,cutoff=0.5,dxmax=24,dymax=18,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab = stab1.crop(24,18,-24,-18)

# Шумоподавление
base = stab.tweak(sat=1.05)#.deflicker()

setmtmode(5)
filtered = base.degrainmedian(mode=1,limity=3,limituv=4).fft3dgpu(wintype=1,degrid=1,bw=24,bh=24,ow=12,oh=12,bt=1,sigma=12.0,sigma2=6.0,sigma3=4,sigma4=2.0,plane=4)
setmtmode(2)

dark   = 32
bright = 196
mask1  = mt_lut(base,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(base,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(base,filtered,mt_logic(mask1,mask2,"min"),luma=true)
preNR_super = filtered.MSuper(pel=2, sharp=2, rfilter=2)
rdr_super = rdr.MSuper(pel=2, sharp=2, levels=1)
vb5 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=5, blksize=16, overlap=4, dct=5)
vb4 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=4, blksize=16, overlap=4, dct=5)
vb3 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=3, blksize=16, overlap=4, dct=5)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, overlap=4, dct=5)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=4, dct=5)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=4, dct=5)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, overlap=4, dct=5)
vf3 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=3, blksize=16, overlap=4, dct=5)
vf4 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=4, blksize=16, overlap=4, dct=5)
vf5 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=5, blksize=16, overlap=4, dct=5)

#Use this lines for MDegrain5 and activate ALL bvec and fvec above.
superDenoised = rdr.MDegrain3(rdr_super, vb1,vf1,vb2,vf2,vb3,vf3,thSAD=450)
rdr.MDegrain2(rdr_super, vb4,vf4,vb5,vf5,thSAD=450)
 \           .Merge(superDenoised, 0.436).FluxSmoothST(5,5)
 
sharpen(0.4).sharpen(0.4).blur(0.2)
coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255).spline36resize(W, H)
GradFun2DBmod(thr=1.6,thrC=2.0,mode=2,str=1.2,strC=0.0,temp=50,adapt=64)


# Назначение: для качественной обработки DVC VHS с частичной стабилизацией изображения 
# Наличие фильтра подавления радужности изображения и цветового шума: включен
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с шумоподавлением: MDegrain3
# Тип шарпера: unsharpmask + LSFmod
# Скорость обработки: медленная
# Рекомендуемый деинтерлейс SmoothDeInterlace или YadifmodNNEDI3 (х2)





