#RgTools.dll
#medianblur.dll
#mt_masktools-26.dll
#mvtools2.dll
#fluxsmooth.dll
#AddGrainC.dll
#GradFun2DB.dll
#dither.dll
#flash3kyuu_deband.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#minblur.avs
#ContraSharpening.avs
#GradFun2DBmod.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

o = last
m2 = o.medianblur(2,0,0).removegrain(11)
lop = m2.fluxsmootht(5)
sup1 = lop.msuper(pel=2, sharp=2, rfilter=2)
sup2 = m2.msuper(pel=2, sharp=2, levels=1)
bv2 = sup1.manalyse(isb=true, delta=2, blksize=16, overlap=8, truemotion=false, search=4)
bv1 = sup1.manalyse(isb=true, delta=1, blksize=16, overlap=8, truemotion=false, search=4)
fv1 = sup1.manalyse(isb=false,delta=1, blksize=16, overlap=8, truemotion=false, search=4)
fv2 = sup1.manalyse(isb=false,delta=2, blksize=16, overlap=8, truemotion=false, search=4)

KEEP = "0.5" # какое количество HiFreq-grain надо сохранить. 0.0=ничего не сохраняем, 1.0=оставляем всё
m2.mdegrain2(sup2,bv1,fv1,bv2,fv2,thSAD=400)
 \.mt_adddiff(mt_makediff(o,m2,U=3,V=3).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - "+KEEP+" * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=2,V=2),U=3,V=3)

ContraSharpening(last,o)

# DeBanding
# f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=56,cb=36,cr=36,grainY=0,grainC=0)
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255)



