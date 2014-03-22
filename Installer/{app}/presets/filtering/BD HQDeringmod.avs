#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#RemoveGrainHD.dll
#dfttestmod.dll
#flash3kyuu_deband.dll
#Dither.dll
#mt_masktools-26.dll
#Dither.avsi
#HQDeringmod.avsi



setMTMode(2)
# setmemorymax(512)

src = last
dr  = src.RemoveGrain(4, 2)
HQDeringmod(src, dr, drrep=13, Y=3, U=3, V=3)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

# Назначение: для обработки BD, имеющем звон на контурах
