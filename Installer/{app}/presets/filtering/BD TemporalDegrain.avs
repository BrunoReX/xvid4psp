#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#AddGrainC.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#HighPassSharp.avs


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

setmtmode(2)
# setmemorymax(1280)

tr = 1
source = last
psuper = source.blur(0.6).MSuper(pel=1, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=1, sharp=2, rfilter=2,levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=16, overlap=8, truemotion=false, search=5, sadx264=3)
source.MDegrainN(ssuper, multi_vec, tr, thSAD=240, thSAD2=96)
NR_super = MSuper(pel=1, levels=1, chroma=true)
MDegrainN(NR_super, multi_vec, tr, thSAD=96, thSAD2=64, lsb=true)

#DeBanding
# GradFun3 (thr=0.5, smode=0, radius=16, lsb_in=true, lsb=true)
# DB = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)
DB = last.f3kdb(20, 56, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)

# Soft Sharpening
output = DB.DitherPost(mode=-1)
sharp8 = output.HighPassSharp(r=0.15) 
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=6) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out 


# Назначение: для обработки зушумленного BD для улучшения сжимаемости
# Тип предварительного шумоподавителя: отсутствует
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на двухэтапном шумоподавителе MDegrainN
# Тип шарпера: HighPassSharp
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: ниже среднего 
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
                   
