#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#fft3dfilter.dll
#warpsharp.dll
#AddGrainC.dll
#gradfun2db.dll
#Gradfun2DBMod 1.5.avsi
#LimitedSharpenFaster mod.avs
#Ylevels.avs


# setmtmode(2)
# setmemorymax(640)

# Deblock with Re-Sharp
source = last
fft = source.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0.1,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=1)
fftD  = mt_makediff(source,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)

blksize = 8
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 400
thSAD2 = 150
dct = 5
fft_super = fft.MSuper(pel=2, sharp=2, rfilter=2) 
fin_super = fin.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (fft_super, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, dct=dct)
fin.MDegrainN (fin_super, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes)
Temporalsoften(3,2,2,6,2)

# SHARPENING
LSFmod(defaults="slow", preblur="ON", strength=80)

# ENHANCING
GradFun2DBmod(thr=1.51,thrC=1.8,mode=2,str=0.6,strC=0.0,temp=50,adapt=64)


# Назначение: для обработки проблемного старого DVD с уменьшением блочности изображения настройками fft3dfilter
# Тип шарпера: LimitedSharpenFaster
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                    




