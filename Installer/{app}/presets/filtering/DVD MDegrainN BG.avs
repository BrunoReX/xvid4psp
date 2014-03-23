#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#AddGrainC.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#Gradfun2DBMod 1.5.avsi
#HPblur.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
base = source.HPblur().HPblur().HPblur()
head = base.mt_adddiff(mt_makediff(base,base.removegrain(4,-1)))
shrp = base.mt_adddiff(mt_makediff(base,base.removegrain(11,-1)))
lim = shrp.repair(head,1)
shrpL = source.mt_adddiff(mt_makediff(lim,base),U=2,V=2)
shrpLL = shrpL.mt_adddiff(mt_makediff(lim,base),U=2,V=2)
shrpLLD = mt_makediff(source,shrpLL)
shrpLLx = source.mt_lutxy(shrpLLD,"x y 128 - abs 15 / 1 2 / ^ 15 * y 128 - 2 ^ y 128 - 2 ^ 2.3 + / * y 128 - y 128 - abs 0.0001 + / * -",U=2,V=2)
shrpLLxD = mt_makediff(shrpLLx,source)
backglow = shrpLLx.mt_makediff(shrpLLxD.removegrain(11,-1).removegrain(11,-1),U=2,V=2). \
           mt_makediff(shrpLLxD.removegrain(11,-1),U=2,V=2).mergeluma(shrpLLx,0.618).AddgrainC(6)

tr = 2
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
psuper = source.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
shsuper = backglow.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=8, overlap=4, chroma=chroma, truemotion=true, search=5)
den = source.MDegrainN(shsuper, multi_vec, tr, thSAD=321, thSAD2=135, plane=planes).Temporalsoften(3,2,2,6,2)
Diff = mt_makediff(source,den,U=ch31,V=ch31)
source.mt_makediff(Diff,U=ch31,V=ch31)
GradFun2DBmod(thr=1.6,thrC=1.8,mode=2,str=0.1,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255,false)


# Назначение: хороший пресет для "мягкого" DVD с повышением резкости и детализации изображения
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: на базе скрипта backglow (median sharpen) by Didee 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: очень медленная    
# ПРЕДУПРЕЖДЕНИЕ: необходим высокий битрейт, чтобы обеспечить коэффициент качества не ниже 0,23 бит\пиксель

