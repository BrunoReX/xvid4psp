#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#Warpsharp.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#minblur.avs
#Dither.avsi
#FineSharp.avs
#HighPassSharp.avs
#mt_xxpand_multi.avsi
#Contrasharpening.avs


setMTMode(2)
# setmemorymax(1024)

RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

source = last.assumeframebased()
maskstar = source.mt_binarize(upper=false) 

blksize = 16 # для увеличения скорости обработки установите 16
overlap = blksize/2
hpad = blksize
vpad = blksize
thSAD = 135 
halfblksize = blksize/2                    
halfoverlap = overlap/2                    
halfthSAD   = thSAD/2
chroma = true
planes = chroma?4:0 
search = 5
tr = 1   # Temporal radius
pre = source.removegrain(11)
psuper = pre.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=1, rfilter=3, chroma=chroma)
ssuper = source.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=2, rfilter=3, chroma=chroma, levels=1)
Recalculate = pre.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=2, rfilter=3, chroma=chroma, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, chroma=chroma, truemotion=true, search=search, sadx264=3)
vb1 = multi_vec.SelectEvery (tr * 2, 0)
vf1 = multi_vec.SelectEvery (tr * 2, 1)
vbr1 = MRecalculate(Recalculate, vb1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
vfr1 = MRecalculate(Recalculate, vf1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
source.MDegrain1 (ssuper, vbr1, vfr1, thSAD=thSAD, plane=planes, lsb=true)

# DEBANDING
# DB = last.GradFun3 (thr=0.5, smode=0, radius=16, lsb_in=true, lsb=true) 
  DB = last.f3kdb(20, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)

# SHARPENING
den = DB.DitherPost(mode=-1) 
output = mt_merge(den,source,maskstar)
# sharp8 = Contrasharpening(output, source) 
  sharp8 = output.HighPassSharp(r=0.15)
# sharp8 = output.FineSharp() # for 1920x1080 
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=0) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 



# Назначение: для обработки BD, типовой для улучшения сжимаемости
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с радиусом 2 и MRecalculate на шумоподавителе MDegrain1 
# Тип шарпера: Contrasharpening, HighPassSharp или FineSharp
# Наличие фильтра DeBanding по умолчанию: включен 
# Скорость обработки: ниже среднего                    
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
