#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#average.dll
#nnedi3.dll
#AddGrainC.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#Gradfun2DBMod 1.5.avsi
#ReCon.avs
#Ylevels.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
nnedi3_rpow2(rfactor=2, cshift="Spline36resize", nsize=0, qual=1)
ReCon(strv=3,strh=3,Radv=2,Radh=2,lmode=1)
Spline36Resize(last.width/2,last.height/2) 
sharp = last

tr = 2
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
psuper = source.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
shsuper = sharp.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=8, overlap=4, chroma=chroma, truemotion=true, search=5)
den = source.MDegrainN (shsuper, multi_vec, tr, thSAD=160, thSAD2=96, plane=planes).Temporalsoften(2,1,1,6,2)

Diff = mt_makediff(source,den,U=ch31,V=ch31)
source.mt_makediff(Diff,U=ch31,V=ch31)
GradFun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255,false)



# Назначение: эксперементальный пресет для "мягкого" DVD с повышением резкости движущего объекта c антиайлизингом
# Тип предварительного шумоподавителя: блюр
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: на базе sharper ReCon by *.mp4 guy
# Наличие фильтра DeBanding по умолчанию: GradFun3
# Скорость обработки: очень медленная 
   
