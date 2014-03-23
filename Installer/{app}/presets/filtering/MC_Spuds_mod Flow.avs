#HQDN3D.dll
#dfttest.dll
#FFT3DFilter.dll
#FFT3DGPU.dll
#RgTools.dll
#despot.dll
#mvtools2.dll
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
#MC_Spudsmod.avsi
#Ylevels.avs

SetMTMode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# ==== режим MFlow =====
# mc_spudsmod(mode="very low",flow=true,gpu=true,sharpp=2)
# mc_spudsmod(mode="low",flow=true,gpu=true,sharpp=2)
# mc_spudsmod(mode="medium",flow=true,gpu=true,sharpp=2)
  mc_spudsmod(mode="medium high",flow=true,gpu=true,sharpp=2)
# mc_spudsmod(mode="high",flow=true,gpu=true,sharpp=2)
# mc_spudsmod(mode="very high",flow=true,gpu=true,sharpp=2)
# mc_spudsmod(mode="anime high",flow=true,gpu=true, blocksize=8, overlap=4, sharpp=2)
# mc_spudsmod(mode="anime low",flow=true,gpu=true, blocksize=8, overlap=4, sharpp=2) 
# mc_spudsmod(mode="medium high",flow=true,gpu=true,focus=true,removeblocks=true,edgeclean=true,sharpp=0)

Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.8,temp=50,adapt=64)
# Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.3,temp=100,adapt=64) # for Anime or Cartoon
YlevelsS(0,1.0,255,0,255,false) 

# Назначение: Для очень качественной обработки DVD и других источников
# Тип предварительного шумоподавителя: fft3dfilter
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с frames=3 на базе скрипта MC_Spuds 
# Тип шарпера: LimitedSharpenFaster
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная 