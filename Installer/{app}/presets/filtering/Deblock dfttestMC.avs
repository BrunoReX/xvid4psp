#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#degrainmedian.dll
#dfttest.dll
#mt_masktools-26.dll
#medianblur.dll
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod.avs
#dfttestMC.avs
#minblur.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)
 
#ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
source = last
NR = source.dfttestmc(sigma=80,tbsize=1,dither=1)
s = NR.minblur(2,1)                   
allD = mt_makediff(source,NR)                 
ssD = mt_makediff(s,s.removegrain(20,-1).removegrain(20,-1))
ssDD = ssD.repair(ssD.repair(allD,1),12)
ssDD = ssDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?")
NR.mt_adddiff(ssDD,U=2,V=2)
GradFun2DBmod(thr=1.4,thrC=1.6,str=1.0,strC=0,temp=50,mask=true) # сглаживает градиенты цветовых переходов, но излишне расходует битрейт
YlevelsS(0,1.0,255,0,255,false)
   
   
# Назначение: Для качественного удаления блочности изображения исходника
# Тип предварительного шумоподавителя: degrainmedian
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с frames=1 на базе скрипта dfttestMC
# Тип шарпера: Contra-Sharpening HD 
# Наличие фильтра DeBanding по умолчанию: включено
# Скорость обработки: медленная                      
