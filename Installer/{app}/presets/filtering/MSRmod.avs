#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#nnedi3.dll
#mvtools2mod.dll
#AddGrainC.dll
#mt_masktools-26.dll
#dfttestmod.dll
#awarpsharp2.dll
#dither.dll
#dither.avsi
#flash3kyuu_deband.dll
#mt_xxpand_multi.avsi
#MSRmod.avs
#MSR_mod.avs
#HighPassSharp.avs


setmtmode(2)
# setmemorymax(1024)

# MSR_mod( W=1280, H=544, HPS=true, r=0.15, smode=2, radius=12, var=1, uvar=0, lsb=false)
# MSR_mod( W=1280, H=720, HPS=true, r=0.15, smode=2, radius=12, var=1, uvar=0, lsb=false)

  MSRmod( W=1280, H=544, HPS=true, str=4, r=0.15, GF3=false, lsb=false)
# MSRmod( W=1280, H=720, HPS=true, str=4, r=0.15, GF3=false, lsb=false)
# MSRmod( W=1280, H=720, HPS=true, str=4, r=0.15, GF3=true, smode=0, thr=0.5, radius=12, lsb=false)


# предназначен для UpScale с шумоподавлением и повышением резкости
# кроп и ресайз установить в начале скрипта

