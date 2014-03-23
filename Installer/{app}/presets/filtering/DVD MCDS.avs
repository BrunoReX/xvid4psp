#RgTools.dll
#mvtools2.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#Gradfun2dbmod.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
 
source = last
sharp = source.mt_adddiff(mt_makediff(source,source.removegrain(4)),U=2,V=2) # "median sharpen" (won't create halos on its own, IF the source is halo-free)
source_super = source.MSuper(pel=2, sharp=2, rfilter=2)
sharp_super = sharp.MSuper(pel=2, sharp=2, levels=1)
b1v = MAnalyse(source_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8, search=4)
f1v = MAnalyse(source_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8, search=4)
cf1 = MCompensate(source, sharp_super, f1v)
cb1 = MCompensate(source, sharp_super, b1v)
max = mt_logic(cb1,cf1,"max").mt_logic(source,"max")
min = mt_logic(cb1,cf1,"min").mt_logic(source,"min")
sharp1 = source.sharpen(0.5)#.mergechroma(last)
sharp1.mt_clamp(max,min,0,0,U=2,V=2)

super = MSuper(pel=2,sharp=2)
bv2 = MAnalyse(super, isb = true, truemotion=false, delta = 2, blksize=16, overlap=8,search=4)
#bv1 = MAnalyse(super, isb = true, truemotion=false, delta = 1, blksize=16, overlap=8,search=4)
#fv1 = MAnalyse(super,isb = false, truemotion=false, delta = 1, blksize=16, overlap=8,search=4)
fv2 = MAnalyse(super,isb = false, truemotion=false, delta = 2, blksize=16, overlap=8,search=4)
MDegrain2(super, b1v,f1v,bv2,fv2,thSAD=256)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)
YlevelsS(0,1.0,255,0,255,false) 


# Назначение: прекрасный пресет для "мягкого" DVD или HDV\AVCHD с повышением резкости движущего объекта
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: "median sharpen" 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная     
