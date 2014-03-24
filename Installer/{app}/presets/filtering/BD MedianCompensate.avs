#avstp.dll
#medianblur.dll
#RgTools.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#flash3kyuu_deband.dll
#fluxsmooth.dll
#Ylevels.avs


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

# setmtmode(2)
# setmemorymax(1024)

o = last
m2 = o.medianblur(2,0,0).removegrain(11)
lop = m2.fluxsmootht(5)
sup1 = lop.msuper(pel=1)
sup2 = m2.msuper(pel=1, levels=1)
bv1 = sup1.manalyse(isb=true, blksize=16,overlap=8,truemotion=true,search=5,sadx264=3)
fv1 = sup1.manalyse(isb=false,blksize=16,overlap=8,truemotion=true,search=5,sadx264=3)
bc1 = m2.mcompensate(sup2,bv1,thSAD=150)
fc1 = m2.mcompensate(sup2,fv1,thSAD=150)

KEEP = "0.75" # какое количество HiFreq-зерна надо сохранить. 0.0=ничего не сохраняем, 1.0=оставляем всё. !! String -это заданная величина !!
interleave(fc1,m2,bc1).fluxsmootht(5).selectevery(3,1)
 \.mt_adddiff(mt_makediff(o,m2,U=3,V=3).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - "+KEEP+" * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=2,V=2),U=3,V=3)

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
 
YlevelsS(0,1.0,255,0,255)


# перед строкой загрузки видео вписуйте в скрипт #setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
