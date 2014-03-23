#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2.dll
#nnedi3.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Gradfun2db.dll
#Gradfun2dbmod 1.5.avsi


setmtmode(2)
# setmemorymax(768)

nnedi3(field=-2)

# patching vertical chroma placement
Vshift=2  # 2 пикселя на ленте 
Hshift=0 
crop(0,0,-Hshift,-Vshift).pointresize(width,height,0,0,width,height).mergeluma(last)
pointresize(width,height,Hshift,Vshift,width,height).mergeluma(last)

ConvertToRGB32().CamCD(12,1).converttoyv12()

bo = last

temporalsoften(6,32,32,28,2)
clense(reduceflicker=false).repair(last,1)
zz = last

sup = zz.removegrain(11).msuper()
bv6 = sup.manalyse(isb=true, delta=6,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)
bv5 = sup.manalyse(isb=true, delta=5,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)
bv4 = sup.manalyse(isb=true, delta=4,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)
bv3 = sup.manalyse(isb=true, delta=3,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
bv2 = sup.manalyse(isb=true, delta=2,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
bv1 = sup.manalyse(isb=true, delta=1,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
fv1 = sup.manalyse(isb=false,delta=1,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
fv2 = sup.manalyse(isb=false,delta=2,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
fv3 = sup.manalyse(isb=false,delta=3,truemotion=false,global=true,blksize=8,overlap=4,DCT=5)
fv4 = sup.manalyse(isb=false,delta=4,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)
fv5 = sup.manalyse(isb=false,delta=5,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)
fv6 = sup.manalyse(isb=false,delta=6,truemotion=false,global=true,blksize=16,overlap=8,DCT=5)

sup2 = bo.msuper(levels=1)
den = bo.MDegrain3(sup2,bv1,fv1,bv2,fv2,bv3,fv3,thsad=600).mt_lutxy(bo,"x 1 + y < x 2 + x 1 - y > x 2 - y ? ?",U=3,V=3)

sup3 = den.msuper(levels=1)
den.MDegrain3(sup3,bv4,fv4,bv5,fv5,bv6,fv6,thsad=400).mt_lutxy(den,"x 1 + y < x 2 + x 1 - y > x 2 - y ? ?",U=3,V=3)

sharpen(0.3).blur(0.2).sharpen(0.2)

# Дебандинг
Gradfun2dbmod(thr=1.6,thrC=1.8,str=1.0,temp=50,adapt=64)

# interleave(bo.subtitle("bobbed"),last.subtitle("bobbed + Filter"))


# Применить любой боб-деинтерлейс или nnedi3(field=-2)
# Назначение: для качественной обработки старых убитых записей VHS Camcoder
# Тип предварительного шумоподавителя: temporalsoften
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с многоступенчатым шумоподавлением MDegrain3
# Скорость обработки: медленная


