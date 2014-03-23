#HQDN3D.dll
#dfttest.dll
#FFT3DFilter.dll
#RgTools.dll
#mvtools.dll
#medianblur.dll
#aWarpSharp2.dll
#WarpSharp.dll
#deblock.dll
#DctFilter.dll
#deblock_qed_MT2.avs
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2DBMod 1.5.avsi
#LimitedSharpenFaster.avs
#MC_Spuds.avs
#Ylevels.avs


SetMTMode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

#mc_spuds(mode="very low",sharpp=2,chro=true)
#mc_spuds(mode="low",sharpp=2,chro=true)
#mc_spuds(mode="medium",sharpp=2,chro=true)

mc_spuds(mode="medium high",sharpp=2,chro=true)

#mc_spuds(mode="high",sharpp=2,chro=true)
#mc_spuds(mode="very high",sharpp=2,chro=true)

Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.8,temp=70,adapt=64)
YlevelsS(0,1.0,255,0,255,false) 

# Назначение: Для очень качественной обработки DVD и других источников
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с frames=3 на базе скрипта MC_Spuds 
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная 