#RgTools.dll
#mvtools2.dll
#fft3dfilter.dll
#fft3dgpu.dll
#dfttest.dll
#HQdn3D.dll
#mipsmooth.dll
#MSharpen.dll
#MaskTools.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#DeRainbow.avs
#TemporalDegrain_beta.avs
#minblur.avs
#Gradfun2dbmod 1.5.avsi
#Ylevels.avs

# setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

DeRainbow()

#GPU     = default( GPU,   False ) # Use FFT3DGPU -- helpful if you have a fast GPU
#fix     = default( fix,   False ) # Use a gentler limiting clip
#sigma   = default( sigma,    16 ) # Default seems to work fine -- Higher values don't help much
#bw      = default( bw,       16 ) # FFT3D block width
#bh      = default( bh,       16 ) # FFT3D block height
#pel     = default( pel,       2 ) # Higher values increase motion vector quality at the cost of speed
#blksize = default( blksize,   8 ) # use 16 for more speed, or for HD resolutions like 1080p
#ov      = default( ov, blksize/2) # Increase for better motion vectors but slower speed. Max is blksize/2
#degrain = default( degrain,   2 ) # MVDegrain 1, 2 or 3
#limit   = default( limit,   255 ) # Limits maximum change of a pixel. Default means no limit
#SAD1    = default( SAD1,    400 ) # Threshold for degraining. Decrease if you suffer from ghosting
#SAD2    = default( SAD2,    300 ) # See above
#HQ      = default( HQ,        1 ) # How much to clean up clip for motion vector searching
#s2      = floor ( sigma * 0.625 ) # See sigma
#s3      = floor ( sigma * 0.375 ) # See sigma
#s4      = floor ( sigma * 0.250 ) # See sigma
#ow      = bw / 2                  # Don't adjust unless you need speed
#oh      = bh / 2                  # See above

TemporalDegrain_beta(GPU=true,sigma=16,pel=2,degrain=3,blksize=8,SAD1=480,SAD2=256,HQ=1)
Gradfun2dbmod(thr=1.51,thrC=1.8,mode=2,str=1.0,temp=50)
YlevelsS(0,1.0,255,0,255)


# Назначение: для качественной обработки любого исходника методом подбора параметров на базе скрипта TemporalDegrain_beta
# Тип предварительного шумоподавителя: fft3dfilter или fft3dgpu с HQdn3D
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на двухэтапном шумоподавителе MDegrain1,2 или 3
# Тип шарпера: ContraSharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                    


