#FFT3DFilter.dll
#FFT3dgpu.dll
#RgTools.dll
#mvtools2T.dll
#TTempsmooth.dll
#EEDI2.dll
#nnedi3.dll
#Deblock.dll
#DctFilter.dll
#Sangnom.dll
#FluxSmooth.dll
#Gradfun2db.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#PNLM.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#Deblock_QEDmod.avsi
#Gradfun2dbmod.avs
#Ylevels.avs
#LimitedSharpenFaster MOD.avs
#MCTDmod.avsi
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#Soothe.avs
#TAA.avsi


Setmtmode(2)
# setmemorymax(768)

MCTD( 
\ p=PNLM(32, 4, 0),
\ p1nr="FluxSmoothST(7, 7)",
\ twopass=true,   p2nr="FluxSmoothST(7, 5)",
\ post=1,         ppnr="PNLM2(12, 3, 0)",
\ AA=true,        aaF ="taa(mtype=0, sharp=0, postaa=false)",
\ sharp=true,     shF ="Sharpen(0.3)",
\ enhance=true,   dbF ="f3kdb()", 
\ edgeclean=true, ECmode="PNLM(48, 4, 0)")


# Назначение: Для очень качественной обработки аниме
# Тип предварительного шумоподавителя: PNLM
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта MCTDmod
# Тип шарпера: LSFmod или sharpen
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная



