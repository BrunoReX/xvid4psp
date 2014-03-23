#RgTools.dll
#mvtools2.dll
#fft3dfilter.dll
#fft3dgpu.dll
#HQDn3D.dll
#mt_masktools-26.dll
#minblur.avs
#TemporalDegrain_ChromaMod V1.0.avs
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod 1.5.avsi
  
  
setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

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

TemporalDegrain_ChromaMod(GPU=true,sigma=16,pel=2,degrain=3,limit=235,SAD1=450,SAD2=256,HQ=1,chroma=false)
Gradfun2dbmod(thr=1.6,thrC=2.3,mode=1,str=1.0,temp=50)

# Ќазначение: дл€ качественной обработки любого исходника методом подбора параметров на базе скрипта TemporalDegrain_ChromaMod
# “ип предварительного шумоподавител€: fft3dfilter или fft3dgpu с HQdn3D
# “ип основного шумоподавител€: на основе векторного анализа оценки движени€ на двухэтапном шумоподавителе MDegrain1,2 или 3
# “ип шарпера: ContraSharpening
# Ќаличие фильтра DeBanding по умолчанию: включен
# —корость обработки: медленна€                    
