#RgTools.dll
#TIVTC.dll
#TDeInt.dll
#repal.dll
#Deblock.dll
#AddGrainC.dll
#dctfilter.dll
#warpsharp.dll
#mt_masktools-26.dll
#NNEDI3.dll
#mvtools2mod.dll
#flash3kyuu_deband.dll
#GradFun2DB.dll
#Dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#srestore.avs
#QTGMC.avs
#Deblock_QED_MT2.avs
#LimitedSharpenFaster mod.avs


# setmtmode(2)
# setmemorymax(640)

# ==== ƒеинтерлейс ====
# TDeInt(order=-1, mode=1) # вариант 1
# QTGMC(preset="Fast", Sharpness=0.4, Edithreads=1) # вариант 2

# ==== DeBlend ==== 
# repal() # трансфер NTSC=>PAL вариант 1
# srestore(25.000) # трансфер NTSC=>PAL вариант 2

blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 321
thSAD2 = 135

# Deblock_QED(uv=3)

rest = last
w = rest.width()
h = rest.height()

# calm = rest.temporalsoften(1,255,255,32,2).merge(rest,0.25).repair(rest,1).removegrain(11)
# calm = calm.temporalsoften(1,255,255,16,2).merge(calm,0.25)

temporalsoften(6,32,32,24,2)
calm = clense(reduceflicker=false).repair(last,1)

LOP = calm.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)
HIP = rest.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)

HIP = mt_makediff(rest,HIP)
mix = LOP.mt_adddiff(HIP,U=2,V=2)

psuper = mix.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
rsuper = rest.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, global=true, truemotion=false, chroma=chroma, lambda=1024, dct=5)
rest.MDegrainN (rsuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
f3kdb(16, 56, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=1.4*0.3, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.1, uvar=0, soft=2)

DB.DitherPost(mode=-1)
output = mergechroma(last) 
 
# ===== ‘инальное повышение резкости 
sharp8 = output.LSFmod(defaults="fast", preblur="ON", strength=90)
lsbctr = Dither_merge16_8(DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 


# ƒл€ обработки проблемных материалов интерлейсных DVD c повышенным уровнем интерлива и мерцани€ по €ркости 
# отключить деинтерлейс, выставл€емый автоматически XviD 4PSP в случае подключени€ трансфера NTSC=>PAL
