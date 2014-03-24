#avstp.dll
#FFT3DFilter.dll
#FFT3dgpu.dll
#RgTools.dll
#mvtools2mod.dll
#TTempsmooth.dll
#EEDI2.dll
#Deblock.dll
#DctFilter.dll
#Sangnom.dll
#Gradfun2db.dll
#WarpSharp.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Deblock_QED_MT2.avs
#Gradfun2DBMod 1.5.avsi
#Ylevels.avs
#LimitedSharpenFaster MOD.avs
#MCTemporalDenoise.avs


# Setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

#MCTemporalDenoise(settings="low", enhance=true, gpu=true)       
#MCTemporalDenoise(settings="very low", enhance=true, gpu=true)  
MCTemporalDenoise(settings="medium", sigma=4, gpu=true, enhance=true) 
#MCTemporalDenoise(settings="high", sigma=6, bwbh=8, owoh=4, overlap=4, blksize=8, enhance=true, gpu=true)       
#MCTemporalDenoise(settings="very high", sigma=8, enhance=true, gpu=true) 
YlevelsS(0,1.0,255,0,255,false)

# Назначение: Для очень качественной обработки DVD и BD
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта MCTemporalDenoise
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная



