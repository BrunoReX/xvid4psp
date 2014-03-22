#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#nnedi3.dll
#AddGrainC.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#Gradfun2DBMod 1.5.avsi
#minblur.avs
#sbr.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
mb1 = source.minblur(1)
enh = source.mt_adddiff(mt_makediff(mb1,mb1.removegrain(4))) 
big1 = source.nnedi3_rpow2(rfactor=2,cshift="spline36resize",fwidth=source.width,fheight=source.height)
big2 = enh.spline36resize(source.width, source.height)
sharp1 = big1.mt_lutxy(big1.sbr(),"x x y - +",U=2,V=2)  
sharp = sharp1.repair(big2,1)

tr = 2
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
psuper = source.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
shsuper = sharp.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=8, overlap=4, chroma=chroma, truemotion=true, search=5)
den = source.MDegrainN (shsuper, multi_vec, tr, thSAD=160, thSAD2=96, lsb=true, plane=planes)
Diff1 = mt_makediff(source,den,U=3,V=3)
NR  = den.Temporalsoften(2,1,1,6,2)
Diff2 = mt_makediff(source,NR,U=3,V=3)
lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")
source.mt_makediff(lutxy,U=3,V=3)
GradFun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.5,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255,false)



# Назначение: хороший пресет для "мягкого" DVD с повышением резкости движущего объекта c суперсэмплингом
# Тип предварительного шумоподавителя: нет
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения на шумоподавителе MDegrain2
# Тип шарпера: скрипт "Linda" (sbr.avs) by Didйе 
# Наличие фильтра DeBanding по умолчанию:  есть
# Скорость обработки: очень медленная