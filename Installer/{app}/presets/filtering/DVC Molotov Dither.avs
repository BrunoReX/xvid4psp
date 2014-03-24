#avstp.dll
#Depan.dll
#DepanEstimate.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#degrainmedian.dll
#RgTools.dll
#Warpsharp.dll
#fft3dgpu.dll
#deen.dll
#mvtools2mod.dll
#FluxSmooth.dll
#mt_masktools-26.dll
#AddGrainC.dll
#GradFun2DB.dll
#dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#Gradfun2dbmod 1.5.avsi
#LimitedSharpenFaster Mod.avs

# SetMTMode(2)
# setmemorymax(768)

ConvertToRGB32()
CamCD(9,1)       # подавление цветового шума камкодеров
converttoyv12()

source = last
W = source.width()
H = source.height()

# Частичная стабилизация изображения
stab_reference = source.crop(48,36,-48,-36).tweak(cont=1.04).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference,trust=5.0,pixaspect=1.094,dxmax=24,dymax=18) # trust=1...100 подобрать иначе рывки
stab1 = DePanStabilize(source,data=mdata,cutoff=0.5,dxmax=24,dymax=18,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab2 = stab1.degrainmedian(mode=2,limity=5,limituv=6).crop(24,18,-24,-18)

preNR = stab2.blur(1.0)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=2)
sharp = stab2.sharpen(0.3)
sharp_super = sharp.MSuper(pel=2, sharp=2, levels=1)
tr = 2
multi_vec = MAnalyse (preNR_super, multi=true, delta=tr, blksize=16, overlap=8, chroma=true, truemotion=false, search=5)
den = stab2.MDegrainN (sharp_super, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

f = den.DitherPost(mode=-1)
# setmtmode(5)
output = f.fft3dgpu(bw=24,bh=24,ow=12,oh=12,bt=3,sigma=2.5,sigma2=1.75,sigma3=2.5,sigma4=2,plane=4)
# setmtmode(2)

sharp = output.LSFmod(defaults="slow",preblur="ON",strength=90)
DB8 = sharp.Gradfun2DBmod(thr=1.51,thrC=1.8,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)
lsbctr = Dither_merge16_8 (den,DB8.Dither_convert_8_to_16(), DitherBuildMask(DB8, output))
lsb_out = lsbctr.DitherPost(mode=6,ampn=1, ampo=1) 
# lsb_out = lsbctr.DitherPost(mode=7,ampn=1, ampo=0) 
lsb_out.spline36resize(W, H)

# для обработки видеоматериалов DV камкодеров с частичной стабилизацией изображения
# Рекомендуемый деинтерлейс SmoothDeInterlace, или YadifmodNNEDI3 (х2)


