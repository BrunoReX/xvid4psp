#HQDN3D.dll
#dfttest.dll
#FFT3DFilter.dll
#RgTools.dll
#mvtools.dll
#removedirt.dll
#unfilter.dll
#despot.dll
#deblock.dll
#DctFilter.dll
#undot.dll
#deblock_qed_MT2.avs
#awarpsharp2.dll
#medianblur.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Cnr2.dll
#Bifrost.dll
#Checkmate.dll
#Chubbyrain2.avs
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2DBMod 1.5.avsi
#Ylevels.avs
#vinverse.avs
#LimitedSharpenFaster.avs
#MC_Spuds.avs

# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

Chubbyrain2().Checkmate(tthr2=5) # удаление радужности и цветового шума

# mc_spuds(mode="anime high", blocksize=8, overlap=4, sharpp=2, chro=true)
mc_spuds(mode="anime low", blocksize=8, overlap=4, sharpp=2, chro=true) 

Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.3,temp=100,adapt=64)
YlevelsS(0,1.0,255,0,255,false)

# Назначение: качественная обработка мультфильмов (cartoon), можно применить в качестве конечного фильтра для классического анимэ 
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения мультиверсии mvtools v.1.9.7.7 с frames=3 на базе скрипта MC_Spuds_mvt  
# Тип шарпера: LSF 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная 