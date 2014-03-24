#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#RemoveDirtSSE2.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#AddGrainC.dll
#Gradfun2db.dll
#degrainmedian.dll
#VagueDenoiser.dll
#Warpsharp.dll
#RemoveDirtMC_SE 1.0.avs
#Ylevels.avs
#SeeSaw.avs
#Gradfun2dbmod 1.5.avsi

# setmtmode(2)
# setmemorymax(640)

ConvertToRGB32().CamCD(9,1).converttoyv12()

source = last
W = source.width()
H = source.height()

# Частичная стабилизация изображения
stab_reference = source.crop(48,36,-48,-36).tweak(cont=1.05).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata=DePanEstimate(stab_reference,trust=5.0,dxmax=24,dymax=18) # trust=1...100 подобрать иначе рывки
stab1=DePanStabilize(source,data=mdata,cutoff=0.5,dxmax=24,dymax=18,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab = stab1.tweak(sat=1.1).crop(24,18,-24,-18).sharpen(0.3).blur(0.1)

NR = stab.RemoveDirtMC_SE(radius=3,repmode=16,clmode=5,thSAD=400,TwoPassDeNoise=true).FluxSmoothST(5,5).unsharpmask(40,1,0)

# Повышение резкости 
a = NR.degrainmedian(mode=2,limity=5,limituv=6).VagueDenoiser(threshold=0.8, method=1, nsteps=6, chromaT=0.8) 
SeeSaw(NR, a, NRlimit=3, NRlimit2=4, Sstr=1.75, Slimit=5, Spower=5, Sdamplo=6, Szp=16)

Gradfun2dbmod(thr=1.4,thrC=1.8,str=0.8,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255).Lanczos4Resize(W,H)


# Назначение: для обработки материалов DV камкодеров c повышенной детализацией сцен \ VHS и с частичной стабилизацией изображения 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на RemoveDirtMC_SE
# Тип шарпера: SeeSaw
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
