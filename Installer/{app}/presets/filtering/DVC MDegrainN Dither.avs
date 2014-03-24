#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Cnr2.dll
#TDeint.dll
#yadifmod.dll
#nnedi3.dll
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#fft3dfilter.dll
#DeFlicker.dll
#mvtools2mod.dll
#Warpsharp.dll
#Fluxsmooth.dll
#mt_masktools-26.dll
#avstp.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#AddGrainC.dll
#AutoYUY2.dll
#YV12ToYUY2imod.avs
#minblur.avs
#Contrasharpening.avs
#LimitedSharpenFaster Mod.avs


# setmemorymax(640)

# ConvertToYV12(interlaced=true)

# TDeint(mode=1,order=-1) # mode=0 deinterlace, mode=1 doubleframerate, order=0 BFF, order=1 TFF
# yadifmod(mode=1,order=-1, edeint=nnedi3(field=-2)) # mode=1 means double framerate,field=-2 means double rate (alternates each frame)

# setmtmode(2)
ConvertToRGB32()
CamCD(7,1)       # подавление цветового шума камкодеров
converttoyv12()

source = last.assumefps(50.00) # for PAL
W = source.width()
H = source.height()

# ==== Стабилизация изображения ====
dxmax = 40 
dymax = 30
mdata = DePanEstimate(source, dxmax=dxmax, dymax=dymax, improve=true, zoommax=1.05, range=2, trust=5.0, pixaspect=1.094) # trust подобрать от 1 до 100
stab1 = DepanStabilize(source, data=mdata, cutoff=0.5, damping=0.9, initzoom=1.0, addzoom=true, prev=2, next=2, mirror=15, blur=50, \
                       dxmax=dxmax, dymax=dymax, zoommax=1.05, rotmax=0.5, subpixel=2, pixaspect=1.094, fitlast=0, tzoom=3.0, info=false)

pre = stab1.blur(0.6)
Super = pre.MSuper()
vectors = MAnalyse(Super,  blksize=16, overlap=4, isb=false, delta=1, truemotion=false, search=4, searchparam=6)
globalmotion = MDepan(pre, vectors, zoom=true, rot=true, pixaspect=1.094, error=15.0, info=false,    \
                      wrong=10.0, zerow=0.05, range=2, thSCD1=400, thSCD2=130) 
stab = DepanStabilize(stab1, data=globalmotion, cutoff=0.5, damping=0.9, initzoom=1.0, addzoom=true, prev=2, next=2, mirror=15, blur=300, \ 
                       dxmax=dxmax, dymax=dymax, zoommax=1.05, rotmax=0.5, subpixel=2, pixaspect=1.094, fitlast=0, tzoom=3.0, info=false)
base = stab.tweak(sat=1.1).crop(dxmax, dymax, -dxmax, -dymax)

# Шумоподавление
calm = base.invert("Y").levels(0, 0.5, 255, 0, 255, coring = false)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)

blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 3   # Temporal radius
thSAD = 400
thSAD2 = 150
dct = 5

csuper = calm.MSuper(pel=2, sharp=2, rfilter=4, chroma=chroma)
bsuper = base.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (csuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, dct=dct)
base.MDegrainN (bsuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
# DB =  last.GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
  DB =  last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)
  den = DB.DitherPost(mode=-1).FluxsmoothST(5,5)
 
# EDGECLEANING
mP = mt_edge(den,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=4),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(24)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
output = mt_merge(den,Eval("den." + "Removegrain(2,2)"),mD,luma=true,U=3,V=3)

# ==== SHARPENING ====
# sharp8 = Contrasharpening(output, base) 
  sharp8 = output.LSFmod(defaults="slow", preblur="ON", strength=130)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out.coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255).spline36resize(W, H)

# Преобразование назад  к интерлейсному виду 25i при кодировании в Carbon Coder
# AutoYUY2()
# AssumeTFF().SeparateFields().SelectEvery(4, 0, 3).Weave() # TFF
# YV12ToYUY2imod() 


# Назначение: для качественной обработки материала DVC (цифровых видеокамер) и VHS-C с частичной стабилизацией изображения
# Установить деинтерлейс TDeint(mode=1,order=-1) # mode=0 deinterlace, mode=1 doubleframerate, order=0 BFF, order=1 TFF
# Установить кроп и ресайз в начале скрипта
# Тип предварительного шумоподавителя: CamCD 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с шумоподавлением: MDegrainN + FluxSmooth
# Тип шарпера: Contrasharpening или LSFmod
# Скорость обработки: медленная





