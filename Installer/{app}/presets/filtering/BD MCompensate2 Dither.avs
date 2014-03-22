#avstp.dll
#RemovegrainSSE2.dll
#RepairSSE2.dll
#dfttestmod.dll
#mvtools2mod.dll
#AddGrainC.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#dither.avsi
#Dither.dll
#HighPassSharp.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#FineSharp.avs
#LimitedSharpenFaster mod.avs


SetMTMode(2)
# setmemorymax(1280)

RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

source = last
str = 0.8
blendv = mt_lut(source, Y=Round(str*255), U=-128,V=-128)
psuper = source.removegrain(11).MSuper(pel=1, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=1, sharp=2, rfilter=2, levels=1)
b2v = MAnalyse(psuper,isb=true, delta=2, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
b1v = MAnalyse(psuper,isb=true, delta=1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
f1v = MAnalyse(psuper,isb=false,delta=1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
f2v = MAnalyse(psuper,isb=false,delta=2, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
cf2 = MCompensate(source, ssuper, f2v, thSAD=96, thSCD1=300)
cf1 = MCompensate(source, ssuper, f1v, thSAD=96, thSCD1=300)
cb1 = MCompensate(source, ssuper, b1v, thSAD=96, thSCD1=300)
cb2 = MCompensate(source, ssuper, b2v, thSAD=96, thSCD1=300)
interleave(cf2, cf1, source, cb1, cb2)
dfttest(sigma=6.0, sbsize=12, sosize=8, tbsize=5, lsb=true, threads=1)
Selectevery(5,2)

# ==== DeBanding ====
  f3kdb(20, 64, 40, 40, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=0.5, smode=0, radius=16, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)

# Soft Sharpening
den = DB.DitherPost(mode=-1)
output = mt_merge(den, source, blendv, luma=true) 
sharp8 = output.HighPassSharp(r=0.15)
# sharp8 = output.FineSharp()  
# sharp8 = output.LSFmod(defaults="fast", strength=75) 

lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 



# Назначение: для создания BDRip кодеком х264
# Тип шумоподавителя: на основе векторного анализа оценки движения на функции MCompensate с конечным фильтром dfttest 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                     
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 




