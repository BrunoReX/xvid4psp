#DeScratch.dll
#RemoveGrainSSE2.dll
#mvtools2.dll
#HQDn3D.dll
#RepairSSE2.dll
#fft3dfilter.dll
#fft3dgpu.dll
#FluxSmooth.dll
#WarpSharp.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Gradfun2db.dll
#minblur.avs
#GradFun2DBmod 1.5.avsi
#TemporalDegrain_ChromaMod V1.0.avs
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(768)

DeScratch(mindif=4, maxgap=20, minlen=300, blurlen=50, keep=100, border=0, maxangle=0) # удаление царапин и полос старых киноплЄнок

#GPU     = default( GPU,   false ) # bcgjkmpeqnt FFT3DGPU если у вас мощный и быстрый GPU
#sigma   = default( sigma,    16 ) # уровень шумоподавлени€ фильтром FFT3D
#bw      = default( bw,       16 ) # FFT3D ширина блока
#bh      = default( bh,       16 ) # FFT3D высота блока
#pel     = default( pel,       2 ) # точность прогнозировани€ движени€ в MAnalyse
#blksize = default( blksize,   8 ) # размер блока в MAnalyse, используйте 16 дл€ большей скорости , или дл€ HD resolutions like 1080p
#ov      = default( ov, blksize/2) # Increase for better motion vectors but slower speed. Max is blksize/2
#degrain = default( degrain,   2 ) # MVDegrain 1, 2 или 3
#limit   = default( limit,   255 ) # ѕредел максимального изменени€ пиксел€. ѕо умолчанию порог на максимуме 255
#SAD1    = default( SAD1,    400 ) # ѕорог дл€ degraining. ”меньшайте, если вы имеете дело с качественным исходником
#SAD2    = default( SAD2,    300 ) # см. выше
#HQ      = default( HQ,        1 ) #  ачественна€ очистка клипа дл€ поиска векторного движени€
#s2      = floor ( sigma * 0.625 ) # см sigma
#s3      = floor ( sigma * 0.375 ) # см sigma
#s4      = floor ( sigma * 0.250 ) # см sigma
#ow      = bw / 2                  
#oh      = bh / 2                  
#ov      = blksize/2 
#chroma  = default( chroma, true ) # когда обрабатываетс€ €ркостной сигнал, то false

TemporalDegrain_ChromaMod(GPU=false,sigma=16,pel=2,degrain=3,limit=235,SAD1=500,SAD2=300,HQ=1,chroma=false).FluxSmoothST(7,0)
LSFmod(defaults="fast", strength=75)
GradFun2DBmod(thr=1.6,thrC=1.01,str=1.0,strC=0.0,temp=50,adapt=64)
greyscale()
levels(20,1.0,225,0,235) # подстроить только уровни под свой исходник


# Ќазначение: ƒл€ очень качественной обработки черно-белого кино DVD
# “ип предварительного шумоподавител€: fft3dfilter или fft3dgpu
# “ип основного шумоподавител€: на основе векторного анализа оценки на шумоподавителе MDegrain3
# “ип шарпера: LimitedSharpenFaster
# Ќаличие фильтра DeBaning по умолчанию: отсутствует
# —корость обработки: медленный 