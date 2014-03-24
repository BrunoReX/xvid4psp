#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#avstp.dll
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#splineresize.dll
#mvtools2mod.dll
#Warpsharp.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#FFT3DGPU.dll
#Cnr2.dll
#minblur.avs
#Dither.avsi
#FineSharp.avs
#HighPassSharp.avs
#mt_xxpand_multi.avsi
#Contrasharpening.avs


# setmemorymax(1280)

# ==== удаление цветового шума камкодера ====
# setmtmode(5)
FFT3DGPU(bw=32, bh=32, oh=16, ow=16, sigma=3.0, sigma2=2.0, sigma3=10.0, sigma4=3.0, bt=4, plane=3, sharpen=0.3)
# setmtmode(2)

# ConvertToRGB32().CamCD(9,1).converttoyv12()  # удаление цветового шума 2-й вариант
# Cnr2("oxx",8,14,191,75,255,20,255,false)     # цветового шума 3-й вариант

# Частичная стабилизация изображения
# stab_reference = crop(160,120,-160,-120).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
# vectors = stab_reference.MSuper(pel=2).MAnalyse(isb=false, truemotion=false, blksize=16, blksizeV=8, overlap=4, chroma=true, searchparam=6)
# globalmotion = MDepan(vectors, pixaspect=1.0, thSCD1=480, thSCD2=150)
# stab1 = DepanStabilize(data=globalmotion, cutoff=0.5, prev=1, next=1, mirror=15, dxmax=80, dymax=60, zoommax=1.05, \
#                      rotmax=5.0, subpixel=2, pixaspect=1.0, method=1, blur=300)
# stab1.tweak(cont=1.03,sat=1.05).crop(80,60,-80,-60) # обрезка рамки пост-стабилизации 


# Частичная стабилизация изображения
source = last
W = 1280 # W = source.width()
H = 720  # H = source.height()
vectors = source.MSuper(pel=1).MAnalyse(blksize=16, isb=false)
globalmotion = MDepan(source, vectors, pixaspect=1.0, thSCD1=400) 
stab1 = DepanStabilize(source, data=globalmotion, cutoff=2.0, mirror=15, method=1, pixaspect=1.0)

dxmax=80  dymax=60
stab_reference = stab1.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference, dxmax=dxmax, dymax=dymax, trust=4.0, pixaspect=1.0) # trust подобрать от 1 до 100
DepanStabilize(stab1, data=mdata, cutoff=1.0, mirror=15, dxmax=dxmax, dymax=dymax, pixaspect=1.0)
spline144resize(W, H, dxmax, dymax, -dxmax, -dymax)   

blksize = 16 
overlap = blksize/4
hpad = blksize
vpad = blksize
thSAD = 256
thSAD2 = 115 
chroma = false
planes = chroma?4:0
search = 5
dct = 0
sadx264 = 3 # для CPU Intel Core2 sadx264 = 7
tr = 2   # Temporal radius
stab = last
psuper = stab.blur(0.8).MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
ssuper = stab.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, chroma=chroma, truemotion=false, search=search, sadx264=sadx264, dct=dct)
stab.MDegrainN (ssuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# DEBANDING
  DB = last.f3kdb(20, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3(smode=0, thr=0.5, radius=16, lsb_in=true, lsb=true)
# DB  = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2) 

# Sharpening
output = DB.DitherPost(mode=-1)
# sharp8 = output.FineSharp() 
sharp8 = output.HighPassSharp(r=0.15) 
# sharp8 = Contrasharpening(output, stab) 
Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
DitherPost(mode=7, ampo=1, ampn=0) 

coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255)


# Назначение: для качественной обработки материала HDV с частичной стабилизацией изображения
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе ускоренной функции MDegrainN 
# Тип шарпера: Contrasharpening или FineSharp
# Скорость обработки: медленная
# Рекомендуемый деинтерлейс YadiModEDI( x2 )
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 

