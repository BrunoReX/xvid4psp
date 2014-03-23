#avstp.dll
#RgTools.dll
#deen_1.0.dll
#Warpsharp.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#Deblock.dll
#AddGrainC.dll
#dctfilter.dll
#gradfun2db.dll
#Gradfun2DBMod 1.5.avsi
#Soothe.avs
#ab16.avs
#Deblock_QED_MT2.avs
#LimitedSharpenFaster mod.avs
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

  clp = last
# calculate the appropriate borders so its width and height are mod 16, these will be removed later
  x_temp      = ab16(clp.width)
  x1          = round(x_temp / 2.0)
  x0          = int(x_temp - x1)
  y_temp      = ab16(clp.height)
  y1          = round(y_temp / 2.0)
  y0          = int(y_temp - y1)
  
# add blank borders (to improve frame edge processsing and make the clip mod 16), we will remove these at the end.  
# clp = clp.addborders(x0,y0,x1,y1)
clp.pointresize( clp.width()+x_temp, clp.height()+y_temp, -x0, -y0, clp.width()+x_temp+.001, clp.height()+y_temp+.001 )
  
# Deblock with Re-Sharp
source = last
dbl = source.Deblock_QED(uv=3)                                 # variant 1
# dbl = source.Deblock(30)                                     # variant 2
# dbl = source.deen("a2d",7,7,7,7,7,7/77.).gradfun2db(77/7/7.) # variant 3
dblD = mt_makediff(source,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
d = dbl.mt_adddiff(DD,U=3,V=3) 
fin = Soothe(d,dbl) # успокоение, если не нужно, можно убрать

blksize = 8
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 400
thSAD2 = 150
dct = 5
dbl_super = dbl.MSuper(pel=2, sharp=2, rfilter=2) 
fin_super = fin.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (dbl_super, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, dct=dct)
fin.MDegrainN (fin_super, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes)
Temporalsoften(3,2,2,6,2)

# SHARPENING
LSFmod(defaults="slow", preblur="ON", strength=80)

# ENHANCING
GradFun2DBmod(thr=1.51,thrC=1.8,mode=2,str=0.6,strC=0.0,temp=50,adapt=64)
crop(x0,y0,-x1,-y1)

YlevelsS(0,1.0,255,0,255)


# Назначение: Для качественного удаления блочности изображения исходника
# Тип предварительного шумоподавителя : deen
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с frames=2 на базе MDegrain2 
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: включено
# Скорость обработки: медленная                      





