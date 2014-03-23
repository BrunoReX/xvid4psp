#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Gradfun2db.dll
#Warpsharp.dll
#Fizzkiller.avs
#Ylevels.avs
#Gradfun2dbmod 1.5.avsi


setmtmode(2)
# setmemorymax(640)

ConvertToRGB32().CamCD(9,1).converttoyv12()

source = last
W = source.width()
H = source.height()

dxmax=32 dymax=24 # for AR 4:3
# dxmax=36 dymax=20 # for AR 16:9

# Частичная стабилизация изображения
stab_reference = source.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).tweak(cont=1.04).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference,trust=5.0,pixaspect=1.094,dxmax=dxmax,dymax=dymax) # trust=1...100 подобрать иначе рывки
stab = DePanStabilize(source,data=mdata,cutoff=0.5,dxmax=dxmax,dymax=dymax,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab.tweak(sat=1.05).crop(dxmax,dymax,-dxmax,-dymax).sharpen(0.3).blur(0.1)

Fizzkiller(degrain=3, blksize=16, thSAD=400, chroma=false).unsharpmask(60,1,0)
Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.8,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255).Lanczos4Resize(W,H)


# Назначение: для обработки материала DV камкодеров с повышенной детализацией при съёмках насекомых с частичной стабилизацией изображения
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на Fizzkiller
# Тип шарпера: unsharpmask
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
