#medianblur.dll
#RgTools.dll
#mt_masktools-26.dll
#mvtools2.dll
#flash3kyuu_deband.dll
#fluxsmooth.dll
#Ylevels.avs


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

# setmtmode(2)
# setmemorymax(1024)

o = spline36resize(1280,720)
m2 = spline16resize(960,360).removegrain(4).bicubicresize(1280,720,1,0)
lop = m2.fluxsmootht(5)
sup1 = lop.msuper(pel=1)
sup2 = m2.msuper(pel=1, levels=1)
bv1 = sup1.manalyse(isb=true, delta=1,blksize=16,overlap=8,truemotion=true,search=5,dct=0)
fv1 = sup1.manalyse(isb=false,delta=1,blksize=16,overlap=8,truemotion=true,search=5,dct=0)
bv2 = sup1.manalyse(isb=true, delta=2,blksize=16,overlap=8,truemotion=true,search=5,dct=0)
fv2 = sup1.manalyse(isb=false,delta=2,blksize=16,overlap=8,truemotion=true,search=5,dct=0)

KEEP = "0.75" # какое количество HiFreq-зерна надо сохранить. 0.0=ничего не сохраняем, 1.0=оставляем всё. !! String -это заданная величина !!
a = m2.mdegrain2(sup2,bv1,fv1,bv2,fv2,thSAD=160)
 \.mt_adddiff(mt_makediff(o,m2,U=3,V=3).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - "+KEEP+" * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=2,V=2),U=3,V=3)

b = a.medianblur(12,8,8)
c = a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(b,1),1),1),1),1),1),1),1)
mt_lutxy(a,c,"x x y - abs 1.62 2 ^ / 1 1.62 / ^ 1.62 3 ^ * x y - x y - abs 1.62 + / * +",U=3,V=3) 

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)

YlevelsS(0,1.0,255,0,255)

# перед строкой загрузки видео вписуйте в скрипт #setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 

