#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2mod.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#dfttestmod.dll
#Bifrost.dll
#medianblur.dll
#AddGrainC.dll
#minblur.avs
#SmoothAdjust.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#ContraHD.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(2,1).ConvertToYV12()
#  Bifrost(interlaced=false)  

# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=3
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

source = last
chroma = false
planes = chroma?4:0
psuper = source.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2,chroma=chroma)
ssuper = source.MSuper(pel=2, sharp=2, rfilter=2,chroma=chroma, levels=1)
b1v = MAnalyse(psuper, isb=true, delta=1, blksize=16, overlap=4, truemotion=false, chroma=chroma)
f1v = MAnalyse(psuper, isb=false,delta=1, blksize=16, overlap=4, truemotion=false, chroma=chroma)
cf1 = MCompensate(source, ssuper, f1v, thSCD1=300)
cb1 = MCompensate(source, ssuper, b1v, thSCD1=300)
interleave(cf1, source, cb1)
dfttest(Y=true, U=false,V=false, sigma=6.0, tbsize=3, lsb=true, threads=1)
Selectevery(3,1)

# DEBANDING
# DB = last.GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
DB = last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)

output = DB.DitherPost(mode=-1)
sharp8 = ContraHD(output,source,cb1,cf1,3) 
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 


# Назначение: качественный пресет для создания SATRip c каналов НТВ, РТР, ОРТ
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MCompensate + Dither
# Тип шарпера: ContraHD
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная

