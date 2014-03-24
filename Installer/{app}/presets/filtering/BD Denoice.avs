#RgTools.dll
#mt_masktools-26.dll
#AddGrainC.dll
#flash3kyuu_deband.dll


# setmtmode(2)
# setmemorymax(256)

o  = last
grain = blankclip(o,color_yuv=$808080,width=1920/3*2,height=816/3*2).addgrainC(12).bicubicresize(o.width(),o.height(),0,0)
ts    = o.Temporalsoften(2,12,12,24,2).merge(o,0.249)
tsD   = mt_makediff(o,ts)
XX = "x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?"
DD    = grain.repair(tsD,12,0).mt_lutxy(grain,XX+" 2 + y < "+XX+" 3 + "+XX+" 2 - y > "+XX+" 3 - y ? ?")

o.mt_makediff(DD).mergechroma(ts)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=64,cr=64,grainY=0,grainC=0)


# Назначение: для обработки HD источника для подавления горячих пикселей и сглаживания зернистости
# Наличие дебандинга: включен




