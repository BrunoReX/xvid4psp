#WarpSharp.dll
#mt_masktools-26.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#Gradfun2db.dll
#LimitedSharpenFaster mod.avs

setmtmode(2)
# setmemorymax(256)

#LSFmod(defaults="old",strength=70)
#LSFmod(defaults="fast",strength=90)
LSFmod(defaults="slow",preblur="ON",strength=90)
Gradfun2db(1.21)


# качественный шарпер с режимом обработки МТ
