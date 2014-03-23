#RgTools.dll
#mt_masktools-26.dll
#Fluxsmooth.dll
#UnDot.dll
#flash3kyuu_deband.dll
#SPresso.avs
#STpresso.avs
#HighPassSharp.avs


setmtmode(2)
# setmemorymax(256)

# ==== Denoiced ====
UnDot()
Spresso(4,24,2).STpresso(4,24,4,12,3,49,1)
Temporalsoften(3,2,2,6,2)
mergechroma(last)

# ==== Soft Sharpening ====
HighPassSharp(r=0.15)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: для обработки чистого BD исходника
# Тип шумоподавителя: функция SPresso + STpresso выполнет здесь роль шумоподавителя и способстует 10% сжатию видеоряда исходника
# DEBANDING : GradFun3 или f3kdb
# Скорость обработки:  быстрая
 
    