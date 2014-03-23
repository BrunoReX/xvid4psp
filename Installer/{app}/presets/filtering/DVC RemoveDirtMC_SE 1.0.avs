#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#deflicker.dll
#RgTools.dll
#Warpsharp.dll
#RemoveDirt.dll
#mvtools2.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#AddGrainC.dll
#GradFun2DB.dll
#SeeSaw.avs
#RemoveDirtMC_SE 1.0.avs
#GradFun2DBmod 1.5.avsi
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

ConvertToRGB32().CamCD(9,1).converttoyv12()

source = last
W = source.width()
H = source.height()

# Частичная стабилизация изображения
stab_reference = source.crop(64,48,-64,-48).tweak(cont=1.04).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference,trust=4.0,pixaspect=1.094,dxmax=32,dymax=24) # trust=1...100 подобрать иначе рывки
stab1 = DePanStabilize(source,data=mdata,cutoff=1.0,dxmax=32,dymax=24,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab = stab1.crop(32,24,-32,-24)
stab.deflicker().spline36resize(W, H)

RemoveDirtMC_SE(radius=3,repmode=16,clmode=5,TwoPassDeNoise=true)
FluxSmoothST(5,5)
unsharpmask(40,1,0)

a = last
b = a.RemoveGrain(mode=25)
SeeSaw(a,b, NRlimit=3, NRlimit2=4, Sstr=1.5, Slimit=5, Spower=5, Sdamplo=6, Szp=16)
GradFun2DBmod(thr=1.6,thrC=2.0,str=1.0,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255)


# Назначение:для обработки старых проблемных DVD 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain3+ MCompensate c RemoveDirtMC
# Тип шарпера: unsharpmask + SeeSaw
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
