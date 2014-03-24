#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#MCDegrain.avs


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

# setmtmode(2)
# setmemorymax(1024)

o   = last
ox  = o.width
oy  = o.height
ox1 = 1280
oy1 =  720 # 544 for AR(2,35:1)
ox2 =  640
oy2 =  360 # 272 for AR(2,35:1)

sm1 = o.bicubicresize(ox1,oy1)   # medium scale
sm2 = sm1.bicubicresize(ox2,oy2) # small scale

D12 = mt_makediff(sm2.bicubicresize(ox1,oy1),sm1,U=3,V=3) # residual of (small)<>(medium)
D1o = mt_makediff(sm1.bicubicresize(ox,oy),o,U=3,V=3)     # residual of (medium)<>(original)

lev2 = sm2.MCDegrain(3,soft=true) # filter on smalle scale
up1 = lev2.bicubicresize(ox1,oy1)
up2 = up1.bicubicresize(ox,oy)

D12.MCDegrain(3,up1,soft=false,thSAD=480) # filter on medium scale
lev1 = up1.mt_makediff(last,U=3,V=3)
up3 = lev1.bicubicresize(ox,oy)

D1o.MCDegrain(3,up2,soft=true,thSAD=480)  # filter on original scale
up3.mt_makediff(last,U=3,V=3)

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)


# Назначение: пресет для обработки проблемного BD с пляшущим шумом 
# Тип шумоподавителя: на основе векторного анализа оценки движения на мульти-функции MCDegrain
# Наличие фильтра DeBanding по умолчанию: включен
# Установите кроп и ресайз в начале скрипта, кодирование производите в режиме lossless !!!
# Скорость обработки: черезвычайно медленная                    
# перед строкой загрузки видео вписуйте в скрипт #setmtmode(5,3), а вслучае ошибки вообще #setmtmode(5,2) при threads=4 




