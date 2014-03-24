#mvtools2.dll
#mt_masktools-26.dll
#AddGrainC.dll
#GradFun2DB.dll
#Ylevels.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

a = last
b = a.AddGrain(10)
asuper = a.MSuper(pel=2, sharp=2, rfilter=2)
bsuper = b.MSuper(pel=2, sharp=2, levels=1)
b1v = asuper.MAnalyse(isb=true, delta=1, blksize=8, overlap=4)
f1v = asuper.MAnalyse(isb=false,delta=1, blksize=8, overlap=4)
c = a.MDegrain1(bsuper, b1v, f1v, thSAD=200)
d = mt_makediff(a,b)
e = mt_makediff(a,c)
f = mt_lutxy(e,d,"x 128 - abs y 128 - abs < x y ?")
mt_makediff(a,f,U=2,V=2)
GradFun2DB(1.21)
YlevelsS(0,1.0,255,0,255,false)


# Назначение: Для обработки мягкого DVD с добавлением искусственной мелко-дисперсионной зернистости изображения
# Тип предварительного шумоподавителя: отсутствует
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c шумоподавителем MDegrain1 
# Тип шарпера:  генератор зерна AddGrain
# Наличие фильтра DeBanding по умолчанию: отсутствует
# Скорость обработки: быстрая


