#avstp.dll
#EEDI2.dll
#EEDI3.dll
#nnedi3.dll
#mt_masktools-26.dll
#SangNom.dll
#tcanny.dll
#MSharpen.dll
#awarpsharp2.dll
#RgTools.dll
#warpsharp.dll
#variableblur.dll
#dfttestmod.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#Soothe.avs
#LimitedSharpenFaster mod.avs
#TAA.avsi


# setmtmode(2)
# setmemorymax(640)

emask  = mt_edge("sobel",7,7,5,5).mt_inflate()
deband = LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)
taa(aatype=5, preaa=1, postaa=false, mtype=1, sharp=0.2, src=deband, mclip=emask)
# taa(aatype=1, preaa=1, postaa=true, mtype=5, sharp=0.2, src=deband, mclip=emask)


# Назначение: для антиайлиазинга и дебандинга аниме с низким уровнем шумов
# Тип антиайлизинга по умолчанию: Taa
# Тип шумоподавителя: tcanny
# Тип шарпера: LSFmod  
# Наличие фильтра DeBanding по умолчанию: LumaDB
# Скорость обработки: средняя