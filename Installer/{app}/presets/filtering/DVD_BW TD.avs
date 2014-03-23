#RgTools.dll
#mvtools2.dll
#fft3dfilter.dll
#fft3dgpu.dll
#HQDn3D.dll
#MaskTools.dll
#mt_masktools-26.dll
#minblur.avs
#TemporalDegrain_ChromaMod V1.0.avs
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod 1.5.avsi
 
 
setmtmode(2)
# setmemorymax(768)

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


FIR = Mt_Convolution(Horizontal=" 48 64 96 64 48 ", vertical ="1", u=-128, v=-128)
Diff = Mt_Makediff(Last, FIR)

THR=string("256")
MedianDiff = MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 2 0 -1 0 -2 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1).fft3dfilter(bw=2, bh=16, ow=1, oh=8, bt=1, sigma=16, sigma2=0.75, sigma3=16, sigma4=16, plane=4)
	ReconstructedMedian = mt_makediff(Diff, MedianDiff)
		Mt_AddDiff(FIR, ReconstructedMedian)
		
TemporalDegrain_ChromaMod(GPU=true,sigma=6,pel=2,degrain=3,SAD1=320,SAD2=180,HQ=1,chroma=false)
Gradfun2dbmod(thr=1.6,thrC=2.0,str=1.0,temp=50)
levels(16,1.0,235,0,255) # подстроить только уровни под свой исходник


# Ќазначение: ƒл€ качественной обработки старого черно-белого кино DVD с артефактами вертикальной паразитной решЄтки
# “ип предварительного шумоподавител€: fft3dfilter или fft3dgpu с HQdn3D
# “ип основного шумоподавител€: на основе векторного анализа оценки движени€ на двухэтапном шумоподавителе MDegrain1,2 или 3
# “ип шарпера: ContraSharpening
# Ќаличие фильтра DeBanding по умолчанию: включен
# —корость обработки: медленна€    