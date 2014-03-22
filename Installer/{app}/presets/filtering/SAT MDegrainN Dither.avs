#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#nnedi3.dll
#fft3dgpu.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#Bifrost.dll
#AddGrainC.dll
#mvtools2mod.dll
#dfttestmod.dll
#mt_masktools-26.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#SmoothContrast.avsi
#minblur.avs
#Contrasharpening.avs


o = last
bob1 = o.nnedi3(field=-2)
bob2 = o.sharpen(0,1).nnedi3(field=-2)
max = bob1.mt_logic(bob1.selectevery(1,-1),"max",U=3,V=3).mt_logic(bob1.selectevery(1,1),"max",U=3,V=3)
min = bob1.mt_logic(bob1.selectevery(1,-1),"min",U=3,V=3).mt_logic(bob1.selectevery(1,1),"min",U=3,V=3)
clamped = bob2.mt_clamp(max,min,0,0,U=3,V=3)
clamped.selectevery(2,-1).trim(1,0)
  
# setmemorymax(640)

# ==== DeRainbow & Color denoiced ====
# setmtmode(5)
# fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=1.5,sigma2=1.2,sigma3=3.0,sigma4=1.5,bt=1,sharpen=0.5,plane=3)
  setmtmode(2)
# ConvertToRGB32().CamCD(2,1).ConvertToYV12()
  Bifrost(interlaced=false)

# ==== Denoiced =====
source = last 
blksize = 16
overlap = blksize/2
chroma = false
planes = chroma?4:0  
tr = 3   # Temporal radius
thSAD = 400
thSAD2 = 150
preNR = source.dfttest(sigma=16,tbsize=1,lsb=true,threads=1).ditherpost(mode=6)
psuper = preNR.MSuper (pel=2,sharp=2,chroma=chroma)
ssuper = source.MSuper (pel=2,sharp=2,chroma=chroma,levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, lambda=1000)
source.MDegrainN (ssuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
# f3kdb(16, 56, 36, 36, 0, 0, dynamic_grain=true,keep_tv_range=true,input_mode=1, output_mode=1)
GradFun3 (thr=0.35, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)
output = DB.DitherPost(mode=-1)

# Contrasharp
sharp8 = Contrasharpening(output, source) 
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 

# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=3
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 


# Назначение: качественный пресет для создания SATRip c каналов НТВ, РТР, ОРТ
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrainN 
# Тип шарпера: Contrasharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная

